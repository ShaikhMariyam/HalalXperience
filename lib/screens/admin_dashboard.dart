import 'dart:convert';
import 'package:flutter/material.dart';
import 'addHCO.dart';
import 'addRestaurant.dart';
import 'HCO.dart';
import 'restaurant.dart';

class adminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor:
            const Color(0xffFFD700), // Change the primary color to green
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/companies': (context) => CompaniesPage(),
        '/products': (context) => ProductsPage(),
        '/restaurant': (context) => RestaurantPage(),
        '/addCompany': (context) => AddCompanyPage(),
        '/addProduct': (context) => AddProductPage(),
        '/addRestaurant': (context) => addRestaurantPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade700,
        title: const Text(
          'HalalXperience',
        ),
        centerTitle: true, // Align the text in the middle
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildButton(context, 'Companies', Icons.business, '/companies'),
                buildButton(
                    context, 'Products', Icons.shopping_basket, '/products'),
                buildButton(context, 'Brands', Icons.label, '/restaurant'),
                buildButton(
                    context, 'Add Company', Icons.add_business, '/addCompany'),
                buildButton(context, 'Add Product', Icons.add_shopping_cart,
                    '/addProduct'),
                buildButton(context, 'Add Restaurant', Icons.add_circle_outline,
                    '/addRestaurant'),
              ],
            ),
            const SizedBox(height: 16.0),
            Image.asset(
              'assets/logo.png',
              width: 400,
              height: 400,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(
      BuildContext context, String label, IconData icon, String route) {
    return Container(
      margin: const EdgeInsets.all(8.0), // Adjust the margin as needed
      width: 70.0, // Adjust the width as needed
      height: 70.0, // Adjust the height as needed
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero, // Remove the padding
          shape:
              const CircleBorder(), // Use CircleBorder to make the button circular
          primary: Colors.yellow.shade700, // Set the background color to gold
        ),
        onPressed: () {
          if (route == '/addCompany') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCompanyPage()),
            );
          } else if (route == '/companies') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompaniesPage()),
            );
          } else if (route == '/addRestaurant') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addRestaurantPage()),
            );
          } else if (route == '/restaurant') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RestaurantPage()),
            );
          } else {
            Navigator.pushNamed(context, route);
          }
        },
        icon: Icon(icon),
        label: Text(
          label,
          style:
              const TextStyle(fontSize: 12.0), // Adjust the font size as needed
        ),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Center(
        child: Text('Products Page'),
      ),
    );
  }
}

class BrandsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brands'),
      ),
      body: Center(
        child: Text('Brands Page'),
      ),
    );
  }
}

class AddProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Center(
        child: Text('Add Product Page'),
      ),
    );
  }
}
