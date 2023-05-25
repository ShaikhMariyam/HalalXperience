import 'dart:convert';
import 'package:flutter/material.dart';

class adminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor:
            const Color(0xffFFD700), // Change the primary color to green
      ),
      home: Scaffold(
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
                  buildButton('Companies', Icons.business),
                  buildButton('Product', Icons.shopping_basket),
                  buildButton('Brand', Icons.label),
                  buildButton('Add Company', Icons.add_business),
                  buildButton('Add Product', Icons.add_shopping_cart),
                  buildButton('Add Brand', Icons.add_circle_outline),
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
      ),
    );
  }

  Widget buildButton(String label, IconData icon) {
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
        onPressed: () {},
        icon: Icon(icon),
        label: Text(
          label,
          style:
              const TextStyle(fontSize: 12.0), // Adjust the font size as needed
        ),
      ),
    );
  }

  Widget buildButtonWithImage(String label, IconData icon, String imagePath) {
    return Column(
      children: [
        buildButton(label, icon),
        const SizedBox(height: 8.0),
        Image.asset(
          imagePath,
          width: 64.0,
          height: 64.0,
        ),
      ],
    );
  }
}