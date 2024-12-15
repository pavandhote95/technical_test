import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackerkernal/add_product_page.dart'; // You can also create an AddAccessoryPage
import 'package:hackerkernal/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> _products = [];
  List<Map<String, String>> _accessories = []; // For accessories
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadAccessories(); // Load accessories as well
  }

Future<void> _loadProducts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _products = (prefs.getStringList('products') ?? []).map((item) {
      final parts = item.split('|');
      return {
        'name': parts[0],
        'image': parts[1],
        'price': parts[2],
      };
    }).toList();
  });
}

Future<void> _loadAccessories() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _accessories = (prefs.getStringList('accessories') ?? []).map((item) {
      final parts = item.split('|');
      return {
        'name': parts[0],
        'image': parts[1],
        'price': parts[2],
      };
    }).toList();
  });
}
  Future<void> _addProduct(Map<String, String> product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDuplicate = _products.any((existingProduct) =>
        existingProduct['name']!.toLowerCase() == product['name']!.toLowerCase());

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product already exists!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _products.add(product);
      prefs.setStringList(
        'products',
        _products.map((p) => '${p['name']}|${p['image']}|${p['price']}').toList(),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product added successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Add accessory
  Future<void> _addAccessory(Map<String, String> accessory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDuplicate = _accessories.any((existingAccessory) =>
        existingAccessory['name']!.toLowerCase() == accessory['name']!.toLowerCase());

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Accessory already exists!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _accessories.add(accessory);
      prefs.setStringList(
        'accessories',
        _accessories.map((a) => '${a['name']}|${a['image']}|${a['price']}').toList(),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accessory added successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteProduct(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _products.removeAt(index);
      prefs.setStringList(
        'products',
        _products.map((p) => '${p['name']}|${p['image']}|${p['price']}').toList(),
      );
    });
  }

  // Delete accessory
  Future<void> _deleteAccessory(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessories.removeAt(index);
      prefs.setStringList(
        'accessories',
        _accessories.map((a) => '${a['name']}|${a['image']}|${a['price']}').toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _logout(context);
                  },
                  child: Icon(Icons.logout_outlined),
                ),
                _isSearching
                    ? Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      )
                    : SizedBox.shrink(),
                IconButton(
                  icon: Icon(_isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) {
                        _searchController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            const Text(
              "Hi-Fi Shop & Service",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Row(
       
              children: [
                Text("Products", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                Text("${_products.length}", style: TextStyle(color: const Color.fromARGB(255, 15, 15, 15))),
              ],
            ),
            Expanded(
              child: _products.isEmpty
                  ? Center(child: Text("No products found"))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return GestureDetector(
                          onTap: () {},
                          child: Card(
                            child: Column(
                              children: [
                               kIsWeb
          ? Image.network(
              product['image'].toString(),  
              fit: BoxFit.fill,
              width: double.infinity, 
              height: double.infinity, 
            )
          : Image.file(
            File(product['image']!), 
              fit: BoxFit.fill,
              width: double.infinity, 
              height: double.infinity, 
            ),
                             
                                Text(product['name']!),
                                Text('₹${product['price']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Add similar section for accessories
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Accessories", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                Text("${_accessories.length}", style: TextStyle(color: Colors.grey)),
              ],
            ),
            Expanded(
              child: _accessories.isEmpty
                  ? Center(child: Text("No accessories found"))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _accessories.length,
                      itemBuilder: (context, index) {
                        final accessory = _accessories[index];
                        return GestureDetector(
                          onTap: () {},
                          child: Card(
                            child: Column(
                              children: [
                                 kIsWeb
          ? Image.network(
              accessory['image']!.toString(),  
              fit: BoxFit.fill,
              width: double.infinity, 
              height: double.infinity, 
            )
          : Image.file(
            File(accessory['image']!), 
              fit: BoxFit.fill,
              width: double.infinity, 
              height: double.infinity, 
            ),
                             
                                Image.file(File(accessory['image']!)),
                                Text(accessory['name']!),
                                Text('₹${accessory['price']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
 floatingActionButton: FloatingActionButton(
  child: const Icon(
    Icons.add,
    color: Colors.white,
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(
          onAddProduct: (product) {
            _addProduct(product);  // Handle product addition
          },
          onAddAccessory: (accessory) {
            _addAccessory(accessory);  // Handle accessory addition
          },
        ),
      ),
    );
  },
  shape: CircleBorder(),
  backgroundColor: Colors.blue,
),

    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
    Fluttertoast.showToast(msg: "Logged out successfully");
  }
}
