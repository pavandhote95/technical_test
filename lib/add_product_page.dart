import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackerkernal/login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddProductPage extends StatefulWidget {
  final Function(Map<String, String>) onAddProduct;

  const AddProductPage({required this.onAddProduct, Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _imagePath;
  bool _isLoading = false;
  String? _nameError, _priceError;

  Future<void> _pickImage() async {
    // if (kIsWeb) {
    //   html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    //   uploadInput.accept = 'image/*';
    //   uploadInput.click();

    //   uploadInput.onChange.listen((e) async {
    //     final files = uploadInput.files;
    //     if (files!.isEmpty) return;

    //     final reader = html.FileReader();
      

    //     reader.onLoadEnd.listen((e) {
    //       setState(() {
    //         _imagePath = reader.result as String;
    //       });
    //     });
    //   });
    // } else {
      final ImagePicker _picker = ImagePicker();
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    
  }

  Future<void> _logout(context) async {
  
  SharedPreferences prefs = await SharedPreferences.getInstance();

  
  await prefs.setBool('isLoggedIn', false);

  

  
 Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
    Fluttertoast.showToast(
    msg: "Logout", 
    toastLength: Toast.LENGTH_SHORT, 
    gravity: ToastGravity.BOTTOM, 
    backgroundColor: Colors.blue, 
    textColor: Colors.white, 
    fontSize: 16.0, 
  );

}


  void _submitProduct() async {
    if (_isLoading) return;

    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = 'Product name is required';
      });
      return;
    } else {
      setState(() {
        _nameError = null;
      });
    }

    final price = _priceController.text.trim();
    if (price.isEmpty) {
      setState(() {
        _priceError = 'Price is required';
      });
      return;
    } else {
      setState(() {
        _priceError = null;
      });
    }

    final priceValue = double.tryParse(price);
    if (priceValue == null) {
      setState(() {
        _priceError = 'Enter a valid price';
      });
      return;
    } else {
      setState(() {
        _priceError = null;
      });
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulating loading
    final product = {
      'name': _nameController.text.trim(),
      'price': price,
      'image': _imagePath ?? '',
    };

    widget.onAddProduct(product);

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);
  }

  Widget _customButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(231, 243, 242, 242),
              border: Border.all(
                color: const Color.fromARGB(18, 123, 123, 123),
                width: 1.0,
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color.fromARGB(149, 0, 0, 0),
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _logout(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(231, 243, 242, 242),
                  border: Border.all(
                    color: const Color.fromARGB(18, 123, 123, 123),
                    width: 1.0,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Color.fromARGB(149, 0, 0, 0),
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      errorText: _nameError,
                    ),
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      errorText: _priceError,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  if (_imagePath != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: kIsWeb
                          ? Image.network(
                              _imagePath!,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_imagePath!),
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  _customButton(
                    text: 'Pick Image',
                    icon: Icons.image,
                    onPressed: _pickImage,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3.0,
                                ),
                              )
                            : const Text(
                                "Add Product",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
