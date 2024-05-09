import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/view/dashboard/dashboard.dart';
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/view/login/rouind_button.dart';
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/view/login/round_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/user-data.dart';
import '../summary/summary.dart';
import '../tab/main-tab.dart';
import 'color.dart';
import 'complete_profile_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loginUser() async {
    // Prepare the login data
    Map<String, dynamic> loginData = {
      'username': emailController.text,
      'password': passwordController.text,
    };

    // Convert login data to JSON
    String jsonData = jsonEncode(loginData);

    String uri = UserData().hostname;
    // Make POST request to your backend API for login
    var response = await http.post(
      Uri.parse('$uri/api/auth/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var token = jsonResponse['jwtToken'];
      var roles = jsonResponse['roles'];
      List<String> rolesList = roles is List ? List<String>.from(roles) : [roles];
      var username = jsonResponse['username'];
      var firstName = jsonResponse['firstName'];
      var lastName = jsonResponse['lastName'];
      UserData().setUser(token, username,firstName,lastName);
      prefs.setString('token', token);
      prefs.setStringList('roles', rolesList);
      prefs.setString('username', username);
      // Login successful, navigate to complete profile view or home screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainTabView()),
      );
    } else {
      // Login failed, show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text("Incorrect email or password. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: emailController,
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: passwordController,
                  hitText: "Password",
                  icon: "assets/img/lock.png",
                  obscureText: true,
                  rigtIcon: TextButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        "assets/img/show_password.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        color: TColor.gray,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot your password?",
                      style: TextStyle(
                          color: TColor.gray,
                          fontSize: 10,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                const Spacer(),
                RoundButton(title: "Login", onPressed: loginUser),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don’t have an account yet? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
