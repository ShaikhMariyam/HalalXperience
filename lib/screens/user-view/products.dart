import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No products found.'),
              );
            }

            return GridView.count(
              crossAxisCount: 2, // Set the number of columns
              crossAxisSpacing: 8.0, // Set the spacing between columns
              mainAxisSpacing: 8.0, // Set the spacing between rows
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> productData =
                    document.data() as Map<String, dynamic>;
                productData['documentId'] =
                    document.id; // Add this line to assign the documentId

                return ProductTile(productData: productData);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductTile({required this.productData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(productData['name']),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display product image again
                    productData['image'] != null &&
                            productData['image'].isNotEmpty
                        ? Image.network(
                            productData['image'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.contain,
                          )
                        : Container(
                            width: 200.0,
                            height: 200.0,
                            color: Colors.grey,
                          ),
                    SizedBox(height: 16.0),
                    Text('SKU: ${productData['SKU']}'),
                    Text('Category: ${productData['cuisines'].join(", ")}'),
                    // Add more details as needed
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          // Customize the appearance of each product tile
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display product image
              productData['image'] != null && productData['image'].isNotEmpty
                  ? Image.network(
                      productData['image'],
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.contain,
                    )
                  : Container(
                      width: 80.0,
                      height: 80.0,
                      color: Colors.grey,
                    ),
              SizedBox(height: 8.0),
              // Display product name
              Text(
                productData['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                productData['SKU'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
