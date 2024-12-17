import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackerkernal/add_product_page.dart';
import 'package:hackerkernal/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> _products = [];
  List<Map<String, String>> _accessories = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _showAllProducts = false; 
bool _showAllAccessories = false; 



  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadAccessories();
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

  Future<void> _addProduct(Map<String, String> product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isDuplicate = _products.any((existingProduct) =>
        existingProduct['name']!.toLowerCase() ==
        product['name']!.toLowerCase());

    if (isDuplicate) {
      
Fluttertoast.showToast(
  msg: "Product already exists!",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: const Color.fromARGB(231, 243, 242, 242),
  textColor: Colors.black,
  fontSize: 16.0,
);


    
      return;
    }

    setState(() {
      _products.add(product);
      prefs.setStringList(
        'products',
        _products
            .map((p) => '${p['name']}|${p['image']}|${p['price']}')
            .toList(),
      );
    });

Fluttertoast.showToast(
  msg: "Product added successfully!",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: const Color.fromARGB(231, 243, 242, 242),
  textColor: Colors.black,
  fontSize: 16.0,
);

  }

  Future<void> _addAccessory(Map<String, String> accessory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    
    bool isDuplicate = _accessories.any((existingAccessory) =>
        existingAccessory['name']!.toLowerCase() ==
        accessory['name']!.toLowerCase());

    if (isDuplicate) {
      Fluttertoast.showToast(
  msg: "Accessory already exists!",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: const Color.fromARGB(231, 243, 242, 242),
  textColor: Colors.black,
  fontSize: 16.0,
);

      
 
      return;
    }

    setState(() {
      _accessories.add(accessory); 
      prefs.setStringList(
        'accessories', 
        _accessories
            .map((a) => '${a['name']}|${a['image']}|${a['price']}')
            .toList(),
      );
    });
Fluttertoast.showToast(
  msg: "Accessory added successfully!",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: const Color.fromARGB(231, 243, 242, 242),
  textColor: Colors.black,
  fontSize: 16.0,
);


  
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

  Future<void> _deleteAccessory(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessories.removeAt(index); 
      prefs.setStringList(
        'accessories',
        _accessories
            .map((a) => '${a['name']}|${a['image']}|${a['price']}')
            .toList(), 
      );
    });
      Fluttertoast.showToast(
    msg: "Accessory deleted successful!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: const Color.fromARGB(231, 243, 242, 242),
    textColor: Colors.black,
    fontSize: 16.0,
  );
  }


    Future<void> _deleteProduct(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _products.removeAt(index);
    prefs.setStringList(
        'products',
        _products
            .map((p) => '${p['name']}|${p['image']}|${p['price']}')
            .toList());
  });

  // Show a toast message
  Fluttertoast.showToast(
    msg: "Product deleted successful!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: const Color.fromARGB(231, 243, 242, 242),
    textColor: Colors.black,
    fontSize: 16.0,
  );


  }

  @override
  Widget build(BuildContext context) {
      bool _keyboardActive = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height:25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _logout(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromARGB(231, 243, 242, 242),
                      border: Border.all(
                        color: Color.fromARGB(18, 123, 123, 123),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.logout_outlined,
                        color: Color.fromARGB(149, 0, 0, 0),
                        size: 18,
                      ),
                    ),
                  ),
                ),
                _isSearching
                    ? Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Products',
                            hintStyle: TextStyle(
                                color: const Color.fromARGB(130, 0, 0, 0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 2.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      )
                    : SizedBox.shrink(),
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:Colors.white,
                      border: Border.all(
                        color: Color.fromARGB(48, 123, 123, 123),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _isSearching ? Icons.close : Icons.search,
                        color: Color.fromARGB(149, 0, 0, 0),
                        size: 20,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (_isSearching) {
                        _searchController.clear();
                      }
                      _searchController.clear();
                    });
                  },
                ),
             
             
              ],
            ),
            SizedBox(
              height: 30,
            ),
            !_keyboardActive ?   const Text(
              "Hi-Fi Shop & Service",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ):SizedBox.shrink(),
          !_keyboardActive ?  SizedBox(
              height: 15,
            ):SizedBox.shrink(),
        ! _keyboardActive?  const Text(
              'Audio shop on Rustaveli Ave 57.\nThis shop offers both products and services',
              style: TextStyle(color: Colors.grey),
            ):SizedBox.shrink(),
        !_keyboardActive?  SizedBox(
              height: 30,
            ):SizedBox.shrink(),
          




Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Text(
          "Products",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8),
        Text(
          "${_products.length}",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    ),
    GestureDetector(
      onTap: () {
        setState(() {
          _showAllProducts = !_showAllProducts;  
        });
      },
      child: Text(
        _showAllProducts ? 'Show Less' : 'Show All',
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    ),
  ],
),
Expanded(
  child: _products.isEmpty
      ? Center(child: Text("No products found", style: TextStyle(fontSize: 18, color: Colors.grey)))
      : LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;

            int crossAxisCount = 2;
            double childAspectRatio = _keyboardActive?1.3:0.9;
            if (screenWidth > 600 && screenWidth <= 1024) {
              crossAxisCount = 3;
              childAspectRatio = 1.2;
            } else if (screenWidth > 1024) {
              crossAxisCount = 4;
              childAspectRatio = 1.2;
            }

            
            final itemsToShow = _showAllProducts ? _products : _products.take(2).toList();
             final searchText = _searchController.text.toLowerCase();
final filteredProducts = itemsToShow.where((product) {
  return product['name']!.toLowerCase().contains(searchText);
}).toList();


            return filteredProducts.isEmpty
          ? Center(
              child: Text(
                "No products found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ): GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: itemsToShow.length,
              itemBuilder: (context, index) {
           final searchText = _searchController.text.toLowerCase();
final filteredProducts = itemsToShow.where((product) {
  return product['name']!.toLowerCase().contains(searchText);
}).toList();

            if (filteredProducts.isEmpty) {
  return Center(
    child: Text(
      "No products found",
      style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );
}
                
                if (index >= filteredProducts.length) {
                  return SizedBox();  
                }

                final product = filteredProducts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Card(
                        color: Color(0xFFF2F2F2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Stack(
                          children: [
                            product['image'] != null && product['image']!.isNotEmpty
                                ? Padding(
                                    padding:_keyboardActive? const EdgeInsets.all(10.0):const EdgeInsets.all(20.0),
                                    child: kIsWeb
                                        ? Image.network(product['image'].toString(), fit: BoxFit.fill, width: double.infinity, height: double.infinity)
                                        : Image.file(File(product['image']!), fit: BoxFit.fill, width: double.infinity, height: double.infinity),
                                  )
                                : const Placeholder(),
                            Positioned(
                              top: 0.0,
                              right: 0.0,
                                         left: 115,                        bottom:  _keyboardActive?10:68,
                              child: IconButton(
                                icon: Image.asset('assets/images/delete.png', width:_keyboardActive?15: 35, height: _keyboardActive?15: 35,),
                                onPressed: () => _deleteProduct(index),
                                tooltip: 'Delete product',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name']!,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '₹${(product['price'] != null ? double.parse(product['price']!).toStringAsFixed(2) : '0.00')}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
         
         
         
          },
        ),
),
 

Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Text(
          "Accessories",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8),
        Text(
          "${_accessories.length}",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    ),
    GestureDetector(
      onTap: () {
        setState(() {
          _showAllAccessories = !_showAllAccessories;  
        });
      },
      child: Text(
        _showAllAccessories ? 'Show Less' : 'Show All',
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    ),
  ],
),
Expanded(
  child: _accessories.isEmpty
      ? Center(child: Text("No accessories found", style: TextStyle(fontSize: 18, color: Colors.grey)))
      : LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;

            int crossAxisCount = 2;
            double childAspectRatio = _keyboardActive?1.3:0.9;
            if (screenWidth > 600 && screenWidth <= 1024) {
              crossAxisCount = 3;
              childAspectRatio = 1.2;
            } else if (screenWidth > 1024) {
              crossAxisCount = 4;
              childAspectRatio = 1.0;
            }

            
            final itemsToShow = _showAllAccessories ? _accessories : _accessories.take(2).toList();
              final searchText = _searchController.text.toLowerCase();
                final filteredAccessories = itemsToShow.where((accessory) {
                  return accessory['name']!.toLowerCase().contains(searchText);
                }).toList();

return filteredAccessories.isEmpty?   Center(child: Text("No accessories found", style: TextStyle(fontSize: 16, color: Colors.grey))): GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing:  10,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: itemsToShow.length,
              itemBuilder: (context, index) {
                final searchText = _searchController.text.toLowerCase();
                final filteredAccessories = itemsToShow.where((accessory) {
                  return accessory['name']!.toLowerCase().contains(searchText);
                }).toList();

              
                   if (index >= filteredAccessories.length) {
                  return SizedBox();  
                }

                final accessory = filteredAccessories[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Card(
                        color: Color(0xFFF2F2F2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Stack(
                          children: [
                            accessory['image'] != null && accessory['image']!.isNotEmpty
                                ? Padding(
                                    padding:_keyboardActive? const EdgeInsets.all(10.0):const EdgeInsets.all(20.0),
                                    child: kIsWeb
                                        ? Image.network(accessory['image'].toString(), fit: BoxFit.fill, width: double.infinity, height: double.infinity)
                                        : Image.file(File(accessory['image']!), fit: BoxFit.fill, width: double.infinity, height: double.infinity),
                                  )
                                : const Placeholder(),
                            Positioned(
                              top: 0,
                              right: 0.0,
                            left: 115,                        bottom:  _keyboardActive?10:68,
                             
                              
                              child: IconButton(
                                icon: Image.asset('assets/images/delete.png',width: _keyboardActive ? 15: 25, height: _keyboardActive? 15: 25,),
                                onPressed: () => _deleteAccessory(index),
                                tooltip: 'Delete accessory',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            accessory['name']!,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '₹${(accessory['price'] != null ? double.parse(accessory['price']!).toStringAsFixed(2) : '0.00')}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
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
  onPressed: () async {
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(
          onAddProduct: (product) {
            _addProduct(product); 
          },
          onAddAccessory: (accessory) {
            _addAccessory(accessory); 
          },
        ),
      ),
    );
  },
  shape: const CircleBorder(),
  backgroundColor: Colors.blue,
),

    );
  }
}
