import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/view/profile/profile.dart';

import '../../global/user-data.dart';

class EditProfileScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? initialHeight;
  final String? initialWeight;
  final DateTime? initialDateOfBirth;

  const EditProfileScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.initialHeight,
    required this.initialWeight,
    required this.initialDateOfBirth,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  DateTime? _selectedDate;

  void _saveProfile() async {
    String uriH = UserData().hostname;
    final uri = Uri.parse('$uriH/api/user');
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserData().token}', // Assuming you have the token stored in a singleton UserData class
      },
      body: jsonEncode({
        'username': UserData().username,
        'firstName': _firstName.text,
        'lastName': _lastName.text,
        'height': _heightController.text,
        'weight': _weightController.text,
        'dateOfBirth': DateFormat('yyyy-MM-dd').format(_selectedDate!), // Ensure the date format matches your backend expectation
      }),
    );

    if (response.statusCode == 200) {
      // Assuming the backend returns a success response
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileView()),
      );
    } else {
      // Handle errors or unsuccessful updates
      final responseBody = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Update Failed'),
          content: Text(responseBody['message'] ?? 'Something went wrong'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: widget.firstName);
    _lastName = TextEditingController(text: widget.lastName);
    _heightController = TextEditingController(text: widget.initialHeight.toString());
    _weightController = TextEditingController(text: widget.initialWeight.toString());
    _selectedDate = widget.initialDateOfBirth;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstName,
              decoration: InputDecoration(labelText: "First Name"),
            ),
            TextField(
              controller: _lastName,
              decoration: InputDecoration(labelText: "Last Name"),
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: "Height (cm)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: "Weight (kg)"),
              keyboardType: TextInputType.number,
            ),
            ListTile(
              title: Text("Date of Birth: ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Confirm Changes'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // double.infinity is the width and 50 is the height
              ),
            ),
          ],
        ),
      ),
    );
  }
}
