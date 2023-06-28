import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user-view/restaurants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  late Stream<QuerySnapshot> _restaurantsStream;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _restaurantsStream =
        FirebaseFirestore.instance.collection('restaurants').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants List'),
        backgroundColor: Colors.yellow.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: RestaurantSearchDelegate());
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _restaurantsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Restaurants found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var restaurant = snapshot.data!.docs[index];
              final RImage = restaurant.get('image');
              final name = restaurant.get('name');
              final url = restaurant.get('url');
              final Rid = restaurant.get('restaurantID');

              DocumentReference favoriteRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('favorite')
                  .doc(Rid);

              return FutureBuilder<DocumentSnapshot>(
                future: favoriteRef.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  bool isFavorite = snapshot.hasData && snapshot.data!.exists;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Restaurant(restaurantId: Rid),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: RImage != null && RImage.isNotEmpty
                          ? Image.network(
                              RImage,
                              width: 48.0,
                              height: 48.0,
                            )
                          : Container(
                              width: 48.0,
                              height: 48.0,
                              color: Colors.grey,
                            ),
                      title: Text(name ?? 'Unknown'),
                      subtitle: Text(url ?? 'Unknown'),
                      trailing: FavoriteButton(
                        restaurant: restaurant,
                        isFavorite: isFavorite,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class RestaurantSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return _buildSearchResults(context, query.toLowerCase());
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('restaurants')
          .where('name', isGreaterThanOrEqualTo: query)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No Restaurants found.'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var restaurant = snapshot.data!.docs[index];
            final RImage = restaurant.get('image');
            final name = restaurant.get('name');
            final url = restaurant.get('url');
            final Rid = restaurant.get('restaurantID');
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Restaurant(restaurantId: Rid),
                  ),
                );
              },
              child: ListTile(
                leading: RImage != null && RImage.isNotEmpty
                    ? Image.network(
                        RImage,
                        width: 48.0,
                        height: 48.0,
                      )
                    : Container(
                        width: 48.0,
                        height: 48.0,
                        color: Colors.grey,
                      ),
                title: Text(name ?? 'Unknown'),
                subtitle: Text(url ?? 'Unknown'),
              ),
            );
          },
        );
      },
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final DocumentSnapshot restaurant;
  final bool isFavorite;

  FavoriteButton({required this.restaurant, required this.isFavorite});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  int favoriteCount = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    favoriteCount = widget.restaurant.get('favorites') ?? 0;
    isFavorite = widget.isFavorite;
  }

  Future<void> toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
      favoriteCount += isFavorite ? 1 : -1;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorite');

    if (isFavorite) {
      // Add restaurant to favorites
      await favoritesCollection
          .doc(widget.restaurant.id)
          .set({'favorite': true});
      FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurant.id)
          .update({'favorites': FieldValue.increment(1)});
    } else {
      // Remove restaurant from favorites
      await favoritesCollection.doc(widget.restaurant.id).delete();
      FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurant.id)
          .update({'favorites': FieldValue.increment(-1)});
    }
  }

  Future<bool> checkFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    final favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorite');

    final favoriteDoc =
        await favoritesCollection.doc(widget.restaurant.id).get();
    return favoriteDoc.exists && favoriteDoc['favorite'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkFavorite(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final bool isFavorite = snapshot.data ?? false;

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: toggleFavorite,
        );
      },
    );
  }
}
