import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackerkernal/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  _emailFocusNode.dispose();
  _passwordFocusNode.dispose();
  super.dispose();
}


  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

   final email = _emailController.text;
    final password = _passwordController.text;


    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Email and Password cannot be empty!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (!_EmailValid(email)) {
      Fluttertoast.showToast(
        msg: "Please enter a valid email!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (!_PasswordValid(password)) {
      Fluttertoast.showToast(
        msg: "Password should be at least 6 characters!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    setState(() => _isLoading = true);

    final url = Uri.parse('https://reqres.in/api/login');
    final body = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Fluttertoast.showToast(
        msg: "Login successful!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        final errorMessage = jsonDecode(response.body)['error'] ?? 'Login failed!';
        _showToast(errorMessage);
      }
    } catch (e) {
      _showToast('Something went wrong. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }
 
  bool _EmailValid(String email) {
    final emailRegExp =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(email);
  }


  bool _PasswordValid(String password) {
    return password.length >=
        6; 
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                   duration: Duration(milliseconds: 1000),
                  child: Image.asset(
                    'assets/images/login.png',
                    height: 290,
                    width: double.infinity,
                  ),
                ),
          
                FadeInDown(
                     duration: Duration(milliseconds: 1000),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInDown(
                   duration: Duration(milliseconds: 1000),
                  child: TextFormField(
                    
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Icon(
                          Icons.alternate_email,
                          color: Colors.grey,
                          size: 22,
                        ),
                      ),
                      labelText: "Email ID",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      border: InputBorder.none,
                    ),
                                
                    onFieldSubmitted: (_) {
                      _passwordFocusNode.requestFocus();
                    },
                  ),
                ),
              
              
                FadeInDown(
                   duration: Duration(milliseconds: 1000),
                  child: Container(
                    margin: const EdgeInsets.only(left: 40),
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
           FadeInDown(
             duration: Duration(milliseconds: 1000),
             child: TextFormField(
               controller: _passwordController,
               focusNode: _passwordFocusNode,
               obscureText: !_isPasswordVisible,
               decoration: InputDecoration(
                 prefixIcon: Padding(
                   padding: const EdgeInsets.only(right: 25.0),
                   child: Image.asset(
                     'assets/images/lock.png', 
                     width: 21,
                     height: 21,
                       color: Colors.grey, 
                   ),
                 ),
                 labelText: "Password",
                 labelStyle: TextStyle(
                   fontWeight: FontWeight.bold,
                   color:    Colors.grey,
                   fontSize: 14,
                 ),
                 suffixIcon: IconButton(
                   icon: Icon(
                     color: Colors.grey,
                     _isPasswordVisible
              ? Icons.visibility
              : Icons.visibility_off,
                   ),
                   onPressed: () {
                     setState(() {
                       _isPasswordVisible = !_isPasswordVisible;
                     });
                   },
                 ),
                 contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                 border: InputBorder.none,
               ),
             ),
           ),

                FadeInDown(
                   duration: Duration(milliseconds: 1000),
                  child: Container(
                    margin: const EdgeInsets.only(left: 40),
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                  const SizedBox(height: 10),
                FadeInDown(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                           fontSize: 14,),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInUp(
                   duration: Duration(milliseconds: 1000),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3.0,
                              ),
                            )
                          : Text(
                              "Login",
                              style: TextStyle(
                             fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                   duration: Duration(milliseconds: 1000),
                  child: Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              FadeInUp(
                 duration: Duration(milliseconds: 1000),
                child: Container(
                  decoration: BoxDecoration(
                    color:Color(0xFFF1F6F7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: double.infinity,
                        height: 44,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Image.asset(
                            'assets/images/Google.png',
                            height: 20, 
                            width: 20,
                          ),
                        ),
                        const Text(
                          "Login with Google",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              
                const SizedBox(height: 20),
                FadeInUp(
                   duration: Duration(milliseconds: 1000),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "New to Logistics? ",
                        style: TextStyle(
                                 fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 125, 124, 124)),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Register",
                          style: TextStyle(
                               fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
