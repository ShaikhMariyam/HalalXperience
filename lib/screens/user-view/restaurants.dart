import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantPage extends StatefulWidget {
  final String restaurantId;

  RestaurantPage({required this.restaurantId});

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
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
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _restaurantData != null
              ? ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
                    Text(
                      _restaurantData!['name'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    //Text('Location: ${_restaurantData!['location']}'),
                    Text('Phone: ${_restaurantData!['phone']}'),
                    // Add more details as needed
                  ],
                )
              : Center(child: Text('Restaurant not found.')),
    );
  }
}
