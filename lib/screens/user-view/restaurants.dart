import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../maps.dart';

class Restaurant extends StatefulWidget {
  final String restaurantId;

  Restaurant({required this.restaurantId});

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<Restaurant> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _restaurantData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getRestaurantDetails();
  }

  Future<void> _getRestaurantDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('restaurants')
          .doc(widget.restaurantId)
          .get();
      if (snapshot.exists) {
        setState(() {
          _restaurantData = snapshot.data();
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error retrieving restaurant details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Details'),
        backgroundColor: Colors.yellow.shade700,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _restaurantData != null
              ? ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
                    ImageSection(restaurantName: _restaurantData!['name']),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _restaurantData!['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _restaurantData!['phoneNumber'],
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ButtonSection(),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        _restaurantData!['description'],
                        textAlign: TextAlign.justify,
                        softWrap: true,
                      ),
                    ),
                  ],
                )
              : Center(child: Text('Restaurant not found.')),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String restaurantName;

  ImageSection({required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.docs;
          final imageUrls =
              data.map((docSnapshot) => docSnapshot.data()['image']).toList();
          final logoUrls =
              data.map((docSnapshot) => docSnapshot.data()['logo']).toList();

          return CarouselSlider.builder(
            itemCount: imageUrls.length,
            itemBuilder: (BuildContext context, int index, _) {
              final imageUrl = imageUrls[index];
              final logoUrl = logoUrls[index];

              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    width: 600,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                  Image.network(
                    logoUrl,
                    width: 600,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ],
              );
            },
            options: CarouselOptions(
              height: 240,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching images from Firestore'),
          );
        } else {
          return Container(
            height: 240,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class ButtonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColorDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(context, color, Icons.call, 'CALL'),
        _buildButtonColumn(context, color, Icons.near_me, 'ROUTE'),
        _buildButtonColumn(context, color, Icons.share, 'SHARE'),
      ],
    );
  }

  Column _buildButtonColumn(
      BuildContext context, Color color, IconData icon, String label) {
    String location = 'location';
    if (label == 'location') {
      location;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            if (label == 'CALL') {
              // Retrieve the phone number from Firebase
              String phoneNumber = await _getPhoneNumberFromFirebase();
              // Call the phone number
              _callPhoneNumber(context, phoneNumber);
            } else {
              launch(location);
            }
          },
          child: Icon(icon, color: color),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Future<String> _getPhoneNumberFromFirebase() async {
    // Replace 'your_restaurant_id' with the actual ID used in Firebase
    String restaurantId = 'restaurantID';

    // Retrieve the phone number from Firebase
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('restaurants')
        .doc(restaurantId)
        .get();

    if (snapshot.exists) {
      return snapshot.data()!['phoneNumber'] ?? '';
    } else {
      return '';
    }
  }

  void _callPhoneNumber(BuildContext context, String phoneNumber) async {
    // Check if the phone number is valid
    if (phoneNumber.isNotEmpty) {
      String url = 'tel:$phoneNumber';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      // Handle case where phone number is not available
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Phone Number Not Available'),
            content:
                Text('The phone number for this restaurant is not available.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
