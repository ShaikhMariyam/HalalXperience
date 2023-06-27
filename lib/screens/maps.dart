import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RestaurantsPage extends StatelessWidget {
  RestaurantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurants',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Restaurants'),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              FirebaseFirestore.instance.collection('restaurants').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.docs;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final restaurantName = data[index].data()['name'];
                  final restaurantEmail = data[index].data()['url'];
                  final restaurantDesc = data[index].data()['description'];

                  return RestaurantDetails(
                    restaurantName: restaurantName,
                    restaurantEmail: restaurantEmail,
                    restaurantDesc: restaurantDesc,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching data from Firestore'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class RestaurantDetails extends StatelessWidget {
  final String restaurantName;
  final String restaurantEmail;
  final String restaurantDesc;

  RestaurantDetails({
    required this.restaurantName,
    required this.restaurantEmail,
    required this.restaurantDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageSection(restaurantName: restaurantName),
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurantName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                restaurantEmail,
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
            restaurantDesc,
            textAlign: TextAlign.justify,
            softWrap: true,
          ),
        ),
      ],
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
        _buildButtonColumn(color, Icons.call, 'CALL'),
        _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
        _buildButtonColumn(color, Icons.share, 'SHARE'),
      ],
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    String url =
        'https://www.google.com/maps/search/?api=1&query=Pizza+Hut+Malaysia';
    if (label == 'ROUTE') {
      url =
          'https://www.google.com/maps/dir/?api=1&destination=Pizza+Hut+Malaysia';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            launch(url);
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
}
