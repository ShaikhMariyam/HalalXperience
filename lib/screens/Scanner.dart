import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  void initState() {
    super.initState();
    _scanBarcode();
  }

  Future<void> _scanBarcode() async {
    String barcodeResult;
    try {
      barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color for the scan button
        'Cancel', // Text for the cancel button
        true, // Show flash icon
        ScanMode.DEFAULT, // Scan mode
      );
    } catch (e) {
      barcodeResult = 'Error: $e';
    }

    if (!mounted) return;

    setState(() {
      // Handle the barcode result here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child:
            CircularProgressIndicator(), // Show a loading indicator while scanning
      ),
    );
  }
}
