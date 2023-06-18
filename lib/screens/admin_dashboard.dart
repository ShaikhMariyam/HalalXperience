import 'dart:convert';
import 'package:flutter/material.dart';
import 'addHCO.dart';
import 'addRestaurant.dart';
import 'addProduct.dart';
import 'HCO.dart';
import 'restaurant.dart';
import 'product.dart';

class adminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xffFFD700),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/companies': (context) => CompaniesPage(),
        '/products': (context) => ProductPage(),
        '/restaurant': (context) => RestaurantPage(),
        '/addCompany': (context) => AddCompanyPage(),
        '/addProduct': (context) => addProductPage(),
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
        centerTitle: true,
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
                buildButton(context, 'Restaurants', Icons.label, '/restaurant'),
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
      margin: const EdgeInsets.all(8.0),
      width: 70.0,
      height: 70.0,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          primary: Colors.yellow.shade700,
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
          } else if (route == '/addProduct') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addProductPage()),
            );
          } else if (route == '/product') {
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
          style: const TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
