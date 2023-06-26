import 'package:flutter/material.dart';
import 'prayer.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'maps.dart';
import 'user-view/products.dart';
import 'user-view/companies.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Scanner.dart';

class userDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              drawer: _buildDrawer(context),
              appBar: AppBar(
                title: const Text('HalalXperience'),
                backgroundColor: Colors.yellow.shade700,
              ),
              body: Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CarouselSlider(
                        items: [
                          GestureDetector(
                            onTap: () => _navigateToPrayerTimesApp(context),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2.0),
                              ),
                              child: Image.asset('assets/image.jpg'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToPrayerTimesApp(context),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2.0),
                              ),
                              child: Image.asset('assets/image.png'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToPrayerTimesApp(context),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2.0),
                              ),
                              child: Image.asset('assets/logo.png'),
                            ),
                          ),
                        ],
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        buildButton('Favorites', Icons.favorite),
                        buildButton('Cuisines', Icons.restaurant_menu),
                        buildButton('Must Try', Icons.thumb_up),
                        buildButton('Restaurants', Icons.restaurant),
                        buildButton('Near You', Icons.near_me),
                        buildButton('More', Icons.more_horiz),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Restaurants Near You',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _buildRestaurantList(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildButton(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          primary:
              Colors.yellow.shade700, // Set the color to Colors.yellow.shade700
        ),
        onPressed: () {
          // TODO: Implement button functionality
        },
        icon: Icon(icon),
        label: Text(
          label,
          style: TextStyle(fontSize: 12.0), // Adjust the font size as needed
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              color: const Color(0xffFFD700),
            ),
          ),
          ListTile(
            leading: Icon(Icons.mosque_sharp),
            title: Text('Prayer Timings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => userDashboard()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.restaurant),
            title: Text('Restaurants'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RestaurantPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Favorites'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => userDashboard()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Hijri Calendar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompaniesPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Halal Organizations'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompaniesPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.qr_code_scanner_rounded),
            title: Text('Barcode Scanner'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScannerPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              _performLogout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard({
    required String imagePath,
    required String name,
    required String distance,
    required String travelingTime,
    required String cuisine,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RestaurantPage()), // Replace with the desired screen
          );
        },
        child: Row(
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text('Distance: $distance'),
                  Text('Traveling Time: $travelingTime'),
                  Text('Cuisine: $cuisine'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRestaurantList(BuildContext context) {
    // Dummy data for demonstration purposes
    List<Map<String, String>> restaurants = [
      {
        'imagePath': 'assets/image.jpg',
        'name': 'Pizza Hut',
        'distance': '1.2 km',
        'travelingTime': '5 mins',
        'cuisine': 'Italian, Fast Food',
      },
      {
        'imagePath': 'assets/image.jpg',
        'name': 'Restaurant 2',
        'distance': '0.8 km',
        'travelingTime': '3 mins',
        'cuisine': 'Mexican',
      },
      // Add more restaurant data here
    ];

    return restaurants.map((restaurant) {
      return _buildRestaurantCard(
        imagePath: restaurant['imagePath']!,
        name: restaurant['name']!,
        distance: restaurant['distance']!,
        travelingTime: restaurant['travelingTime']!,
        cuisine: restaurant['cuisine']!,
        context: context,
      );
    }).toList();
  }

  void _navigateToPrayerTimesApp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PrayerTimesApp()),
    );
  }

  void _performLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => startPage()),
        (route) => false,
      );
    } catch (e) {
      print('Failed to log out. Error: $e');
    }
  }
}
