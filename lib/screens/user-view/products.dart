import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No products found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var product = snapshot.data!.docs[index];
              final image = product.get('image');
              final name = product.get('name');
              final SKU = product.get('SKU');

              DocumentReference favoriteRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('favorite')
                  .doc(product.id);

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
                          builder: (context) =>
                              productDetailsPage(product: product),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: image != null && image.isNotEmpty
                          ? Image.network(
                              image,
                              width: 48.0,
                              height: 48.0,
                            )
                          : Container(
                              width: 48.0,
                              height: 48.0,
                              color: Colors.grey,
                            ),
                      title: Text(name ?? 'Unknown'),
                      subtitle: Text(SKU ?? 'Unknown'),
                      trailing: FavoriteButton(
                        product: product,
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

class FavoriteButton extends StatefulWidget {
  final DocumentSnapshot product;
  final bool isFavorite;

  FavoriteButton({required this.product, required this.isFavorite});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  int favoriteCount = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    favoriteCount = widget.product.get('favorites') ?? 0;
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
      // Add product to favorites
      await favoritesCollection.doc(widget.product.id).set({'favorite': true});
      FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update({'favorites': FieldValue.increment(1)});
    } else {
      // Remove product from favorites
      await favoritesCollection.doc(widget.product.id).delete();
      FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
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

    final favoriteDoc = await favoritesCollection.doc(widget.product.id).get();
    return favoriteDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkFavorite(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
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

class productDetailsPage extends StatelessWidget {
  final DocumentSnapshot product;

  productDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    final image = product.get('image');
    final name = product.get('name');
    final SKU = product.get('SKU');
    final company = product.get('company');
    final country = product.get('country');
    final cuisines = product.get('cuisines');
    final int favorites = product.get('favorites');

    return Scaffold(
      appBar: AppBar(
        title: Text(name ?? 'Product Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (image != null && image.isNotEmpty)
                  Image.network(
                    image,
                    fit: BoxFit.contain,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                Positioned(
                  top: 16.0,
                  left: 16.0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${name ?? 'Unknown'}',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'SKU: ${SKU ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Company: ${company ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Country: ${country ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Cuisines: ${cuisines ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    FavoriteButton(
                      product: product,
                      isFavorite: favorites != null && favorites > 0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '${favorites}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
