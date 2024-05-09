import 'package:flutter/material.dart';
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/view/login/sign_up_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garmin Text Receiver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SignUpView(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   static const EventChannel _eventChannel = EventChannel('incrementerChannel');
//   String _message = "Waiting for messages...";
//
//   @override
//   void initState() {
//     super.initState();
//     _eventChannel.receiveBroadcastStream().listen(_updateText, onError: _onError);
//   }
//
//   void _updateText(dynamic data) {
//     setState(() {
//       if (data is Map) {
//         _message = "Received map: ${data.toString()}";
//         // If you know the structure of the map, you can extract specific values like this:
//         // _message = "Value: ${data['key']}";
//       } else {
//         _message = "Received unexpected data type";
//       }
//     });
//   }
//
//
//   void _onError(Object error) {
//     setState(() {
//       _message = "Error receiving message: $error";
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Garmin Text Receiver"),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(_message, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//         ),
//       ),
//     );
//   }
// }
