import 'dart:convert';

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:http/http.dart' as http;

import '../../common/collor.dart';
import '../../global/user-data.dart';
import '../login/rouind_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<int> showingTooltipOnSpots = [21];
  List<FlSpot> allSpots = [];
  DateTime selectedDate = DateTime.now();
  String selectedFrequency = 'hourly';
  Map<String, dynamic> lastHeartRateData = {};
  DateTimeRange? selectedDateRange;
  String selectedPeriod = 'Daily';  // Default to daily


  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch initial data
  }

  void fetchData() async {
    // Call your backend API to fetch data based on selected frequency and date
    String uri = UserData().hostname;
    Uri url = Uri.parse('$uri/api/auth/signin?date=${selectedDate.toIso8601String()}&frequency=$selectedFrequency');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      setState(() {
        allSpots = data.map((e) => FlSpot(
          DateTime.parse(e['timestamp']).hour.toDouble(),
          e['value'].toDouble(),
        )).toList();
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange ?? DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 7)), // Default last week
        end: DateTime.now(),
      ),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
        // Optionally fetch data right after picking
        fetchData();
      });
    }
  }

  void showDetails(FlSpot spot) {
    // Calculate time difference from now
    var dateOfData = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt() * 1000);
    var duration = DateTime.now().difference(dateOfData);
    var timeAgo = formatDuration(duration);
    setState(() {
      lastHeartRateData = {
        'value': spot.y,
        'timeAgo': timeAgo,
      };
    });
  }

  String formatDuration(Duration duration) {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} mins ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hours ago';
    } else {
      return '${duration.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back,",
                          style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 12),
                        ),
                        Text(
                          "Stefani Wong",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      value: selectedFrequency,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedFrequency = newValue;
                          });
                          fetchData();
                        }
                      },
                      items: <String>['hourly', 'daily', 'weekly', 'monthly']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Heart Rate Data",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 10),
                AspectRatio(
                    aspectRatio: 1.7,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: allSpots, // make sure this is properly defined above as List<FlSpot>
                            isCurved: true,
                            barWidth: 3,
                            belowBarData: BarAreaData(
                              show: true,
                              //colors: [Colors.lightBlueAccent.withOpacity(0.5)],
                            ),
                            aboveBarData: BarAreaData(
                              show: true,
                              //colors: [Colors.blue.withOpacity(0.6)],
                            ),
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                      radius: 3,
                                      color: Colors.deepOrange,
                                      strokeWidth: 1,
                                      strokeColor: Colors.white),
                            ),
                          ),
                        ],
                        titlesData: FlTitlesData(show: false),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black12, width: 1)),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchCallback: (FlTouchEvent event, LineTouchResponse? lineTouch) {
                            if (event is FlTapUpEvent && lineTouch != null) {
                              final spot = lineTouch.lineBarSpots!.first;
                              showDetails(spot); // showDetails function will handle the display of this spot's details
                            }
                          },
                          touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.blueGrey,
                              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                return touchedBarSpots.map((barSpot) {
                                  return LineTooltipItem(
                                    '${barSpot.y} bpm\n${barSpot.x.toInt()} mins ago',
                                    const TextStyle(color: Colors.white),
                                  );
                                }).toList();
                              }
                          ),
                        ),
                      ),
                    )
                ),



                if (lastHeartRateData.isNotEmpty) ...[
                  Text('Last Selected Heart Rate: ${lastHeartRateData['value']} BPM'),
                  Text('Time Ago: ${lastHeartRateData['timeAgo']}'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
