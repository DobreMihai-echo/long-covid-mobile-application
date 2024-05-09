import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/view/login/login_view.dart';
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/view/login/rouind_button.dart';
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/view/login/round_textfield.dart';

import '../../global/user-data.dart'; // For date formatting

class UserInfoInput extends StatefulWidget {

  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String email;

  UserInfoInput({required this.username, required this.password, required this.firstName, required this.lastName, required this.email});

  @override
  _UserInfoInputState createState() => _UserInfoInputState();
}

class _UserInfoInputState extends State<UserInfoInput> {
  String _gender = 'Male';
  DateTime _dateOfBirth = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();


  Future<void> sendDataToBackend() async {
    String uri = UserData().hostname;
    var url = Uri.parse('$uri/api/auth/signup');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': widget.username,
        'password': widget.password,
        'firstName': widget.firstName,
        'lastName': widget.lastName,
        'email': widget.email,
        'gender': _gender,
        'dateOfBirth': DateFormat('yyyy-MM-dd').format(_dateOfBirth),
        'weight': _weightController.text,
        'height': _heightController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginView(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Register Failed"),
            content: Text("There was a problem registering your account."),
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
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_dateOfBirth);
  }

  Widget genderSelection(String gender, String assetName) {
    bool isSelected = _gender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _gender = gender;
          });
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.grey[300] : Colors.transparent,
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(assetName, height: 80),
                  const SizedBox(height: 8),
                  Text(gender),
                ],
              ),
            ),
            if (isSelected)
              const Positioned(
                right: 10,
                top: 10,
                child: Icon(Icons.check_circle, color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Your Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                genderSelection('Male', 'assets/img/man.png'),
                genderSelection('Female', 'assets/img/woman.png'),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(context);
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RoundTextField(
                    controller: _weightController,
                    hitText: "Your Weight",
                    icon: "assets/img/weight.png",
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B4D8), Color(0xFF89CFF0)], // Example gradient colors
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "KG",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RoundTextField(
                    controller: _heightController,
                    hitText: "Your Height",
                    icon: "assets/img/height.png",
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B4D8), Color(0xFF89CFF0)], // Example gradient colors
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "CM",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            RoundButton(
              title: "Next >",
              onPressed: sendDataToBackend
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}