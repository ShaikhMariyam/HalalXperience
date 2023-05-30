import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class addRestaurantPage extends StatefulWidget {
  @override
  _addRestaurantPageState createState() => _addRestaurantPageState();
}

class _addRestaurantPageState extends State<addRestaurantPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  File? _selectedLogo;
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source, {bool isLogo = false}) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source);

    if (pickedImage != null) {
      setState(() {
        if (isLogo) {
          _selectedLogo = File(pickedImage.path);
        } else {
          _selectedImage = File(pickedImage.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Restaurant'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Restaurant Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Website URL',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        _pickImage(ImageSource.gallery, isLogo: true),
                    child: const Text('Upload Logo'),
                  ),
                  const SizedBox(width: 16.0),
                  if (_selectedLogo != null)
                    Image.file(
                      _selectedLogo!,
                      width: 80.0,
                      height: 80.0,
                    ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: const Text('Upload Restaurant Image'),
                  ),
                  const SizedBox(width: 16.0),
                  if (_selectedImage != null)
                    Image.file(
                      _selectedImage!,
                      width: 80.0,
                      height: 80.0,
                    ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    String name = _nameController.text;
                    String description = _descriptionController.text;
                    String phoneNumber = _phoneNumberController.text;
                    String url = _urlController.text;

                    String? logoUrl =
                        await uploadFileToStorage(name, _selectedLogo, 'logo');
                    String? imageUrl = await uploadFileToStorage(
                        name, _selectedImage, 'image');

                    addRestaurantToFirestore(
                      name,
                      description,
                      phoneNumber,
                      url,
                      logoUrl,
                      imageUrl,
                    );

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Restaurant added successfully'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              Navigator.pop(
                                  context); // Go back to the previous page
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    print('Error adding restaurant: $e');
                  }
                },
                child: const Text('Add Restaurant'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> uploadFileToStorage(
      String uid, File? file, String fileType) async {
    if (file == null) return null;

    try {
      // Upload the file to Firestore Storage
      String fileName = '${fileType}_$uid';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(file);

      // Get the download URL of the uploaded file
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading $fileType: $e');
      return null;
    }
  }

  void addRestaurantToFirestore(
    String name,
    String description,
    String phoneNumber,
    String url,
    String? logoUrl,
    String? imageUrl,
  ) {
// Add the restaurant to Firestore
    CollectionReference restaurantsRef =
        FirebaseFirestore.instance.collection('restaurants');

    restaurantsRef.add({
      'name': name,
      'description': description,
      'phoneNumber': phoneNumber,
      'url': url,
      'logo': logoUrl,
      'image': imageUrl,
    });
  }
}
