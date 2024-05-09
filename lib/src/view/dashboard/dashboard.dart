import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/global/user-data.dart';
Timer? timer;

Future<void> sendDataToBackend(Map<String, dynamic> data, String? token,String? username) async {
  String uri = UserData().hostname;
  final response = await http.post(
    Uri.parse('$uri/api/health?username=$username'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    print('Data successfully sent to the backend');
  } else {
    print('Failed to send data');
    print(response.body);
  }
}


class DashboardScreen extends StatefulWidget {

  final String? token = UserData().token;
  final String? username = UserData().username;
  DashboardScreen({super.key});


  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String heartRate = "78 bpm";
  String spo2 = "98 mmHg";
  String steps = "100";
  String sleep = "8 hrs";
  String respiration = "0";
  String distance = "0";
  String bodyBattery = "0";
  String calories = "0";


  static const platform = EventChannel('incrementerChannel');

  @override
  void initState() {
    super.initState();
    platform.receiveBroadcastStream().listen(_updateStats, onError: _onError);
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t)=>postData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void postData() {
    final DateTime now = DateTime.now();
    final Map<String, dynamic> data = {
      'heartRateVariability': heartRate.split(" ")[0], // Assuming heartRate is a string like "78 bpm"
      'spo2': spo2.split(" ")[0],
      'steps': steps,
      'respirationsPerMinute': respiration,
      'distance': distance,
      'calories': calories,
      'bodyBattery': bodyBattery,
      'receivedDate': now.toIso8601String()
    };

    //sendDataToBackend(data, widget.token,widget.username);
  }

  void _updateStats(dynamic event) {
    //print(event);
    if(event is Map) {
      setState(() {
        heartRate = "${event['heartRate'] ?? 0} bpm";
        spo2="${event['pulseOx'] ?? 0} mmHg";
        steps="${event['steps'] ?? 0}";
        respiration="${event['respiration'] ?? 0}";
        calories="${event['calories'] ?? 0}";
        distance="${event['distance'] ?? 0}";
        bodyBattery="${event['bodyBatery'] ?? 0}";
      });
    } else {
      print("Not a map");
    }
  }

  void _onError(Object error) {
    print('Received error: ${error.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    String? firstName = UserData().firstName;
    String? lastName = UserData().lastName;
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, $firstName $lastName"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                StatCard(label: 'Heart Rate', value: heartRate, icon: FontAwesomeIcons.heartPulse, color: Colors.pink),
                StatCard(label: 'SPO2', value: spo2, icon: FontAwesomeIcons.lungs, color: Colors.red),
                StatCard(label: 'Steps', value: steps, icon: FontAwesomeIcons.shoePrints, color: Colors.teal),
                StatCard(label: 'Body Battery', value: bodyBattery, icon: FontAwesomeIcons.batteryFull, color: Colors.green),
                StatCard(label: 'Distance', value: distance, icon: FontAwesomeIcons.road, color: Colors.orange),
                StatCard(label: 'Calories', value: calories, icon: FontAwesomeIcons.fire, color: Colors.yellow),
                StatCard(label: 'Respiration', value: respiration, icon: FontAwesomeIcons.lungs, color: Colors.lightBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}
