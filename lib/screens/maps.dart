import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user-view/restaurants.dart';

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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantPage(restaurantId: Rid),
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
                    builder: (context) => RestaurantPage(restaurantId: Rid),
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
