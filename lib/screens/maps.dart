import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class restaurantPage extends StatelessWidget {
  restaurantPage({super.key});

  final List<String> _imageUrls = [
    'https://www.palmmall.my/photo/store/400.jpg',
    'https://people.com/thmb/J7mMPxWT0MhdrKuy0FqxXsL2HiE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(999x0:1001x2)/pizza-hut-2-d194594b6b594e27912d5174c2fe8e06.jpg',
    'https://i.ytimg.com/vi/upTkcxwYHXY/maxresdefault.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Pizza Hut',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Located at LOT G-4 & 5',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          const Text('41'),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColorDark;

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.call, 'CALL'),
        _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
        _buildButtonColumn(color, Icons.share, 'SHARE'),
      ],
    );

    Widget textSection = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'QSR Brands (M) Holdings Sdn Bhd operates more than 270 Pizza Hut restaurants throughout Malaysia and Singapore, making it the largest pizza operator on both sides of the causeway. The first outlet started its operations in 1982. Offering an enticing range of nutritious Italian-American dishes, including the ever-popular pan pizza, Pizza Hut caters to both young and old. The success of Pizza Hut is derived from its imaginative and innovative ways with continuously development, marketing and promoting of new products. To cater to an ever larger section of the population, the company plans to further expand the chain, while simultaneously making its products more affordable.',
        textAlign: TextAlign.justify,
        softWrap: true,
      ),
    );

    Widget imageSection = Container(
      height: 240,
      child: PageView(
        children: _imageUrls
            .map((url) => Image.network(
                  url,
                  width: 600,
                  height: 240,
                  fit: BoxFit.cover,
                ))
            .toList(),
      ),
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: ListView(
          children: [
            imageSection,
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
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
