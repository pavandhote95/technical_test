
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
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false; 
  @override
  void initState() {
    super.initState();
    _loadProducts();
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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Product already exists!',
        style: TextStyle(color: Colors.black),       ),
      duration: Duration(seconds: 2),
      backgroundColor: Color.fromARGB(231, 243, 242, 242),
    ),
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product added successfully!',  style: TextStyle(color: Colors.black),),
        duration: Duration(seconds: 2),
        backgroundColor:       Color.fromARGB(231, 243, 242, 242),
      ),
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
    msg: "Logged out successfully", 
    toastLength: Toast.LENGTH_SHORT, 
    gravity: ToastGravity.BOTTOM, 
    backgroundColor: Colors.green, 
    textColor: Colors.white, 
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(


          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(
              height: 30,
            ),
                  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,   children: [
    GestureDetector(
      onTap: () {
        _logout(context);       },
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
        ?  Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
              controller: _searchController,
               decoration: InputDecoration(
                                  hintText: 'Search Products' ,
                                  hintStyle: TextStyle(color: const Color.fromARGB(130, 0, 0, 0)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width:
                                            2.0), 
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,
                                        width:
                                            1.0), 
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
        : SizedBox.shrink(),     IconButton(
      icon: Container(
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
            _isSearching ? Icons.close : Icons.search,
            color: Color.fromARGB(149, 0, 0, 0),
            size: 20,
          ),
        ),
      ),
      onPressed: () {
        setState(() {
          _isSearching = !_isSearching;           if (!_isSearching) {
            _searchController.clear();           }
        });
      },
    ),
  ],
),
     SizedBox(
              height: 30,
            ),

          
            const Text(
              "Hi-Fi Shop & Service",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              'Audio shop on Rustaveli Ave 57.\nThis shop offers both products and services',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 40,
            ),
     Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Text(
          "Products",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8,),
                Text(
          "${_products.length}",            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    ),
    Text("Show all", style: TextStyle(color: Colors.blue)),
  ],
),

       
Expanded(
  child: _products.isEmpty
      ? Center(child: Text("No products found", style: TextStyle(fontSize: 18, color: Colors.grey)))
      : LayoutBuilder(
          builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;

                        int crossAxisCount = 2;             double childAspectRatio = 0.8; 
            if (screenWidth > 600 && screenWidth <= 1024) {
              crossAxisCount = 3;               childAspectRatio = 1.2;             } else if (screenWidth > 1024) {
              crossAxisCount = 4;               childAspectRatio = 1.0;             }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: childAspectRatio,               ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final searchText = _searchController.text.toLowerCase();
                final filteredProducts = _products.where((product) {
                  return product['name']!.toLowerCase().contains(searchText);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(child: Text("No products match your search", style: TextStyle(fontSize: 16, color: Colors.grey)));
                }

                                if (index >= filteredProducts.length) {
                  return SizedBox.shrink();                  }

                final product = filteredProducts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Card(
                        color: Color(0xFFF2F2F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            product['image'] != null && product['image']!.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: kIsWeb
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
                                
                                  )
                                : const Placeholder(),
                            Positioned(
                              top: 0.0,
                              right: 0.0,
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/images/delete.png',                                   width: 25,                                   height: 25,                                 ),
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
)

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
                  _addProduct(product);
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
}
