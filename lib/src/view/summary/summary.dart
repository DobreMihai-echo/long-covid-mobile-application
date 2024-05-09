import 'dart:convert';

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../common/collor.dart';
import '../../global/user-data.dart';
import '../login/rouind_button.dart';

import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<BarChartGroupData> barGroups = [];
  List<int> showingTooltipOnSpots = [];
  // List<FlSpot> heartRateSpots = [];
  List<FlSpot> stepSpots = [];
  List<FlSpot> get heartRateSpots => const [
    FlSpot(0, 65),
    FlSpot(1, 66),
    FlSpot(2, 70),
    FlSpot(3, 74),
    FlSpot(4, 75),
    FlSpot(5, 78),
    FlSpot(6, 75),
    FlSpot(7, 74),
    FlSpot(8, 70),
    FlSpot(9, 68),
    FlSpot(10, 69),
    FlSpot(11, 70),
    FlSpot(12, 68),
    FlSpot(13, 65),
    FlSpot(14, 68),
    FlSpot(15, 70),
    FlSpot(16, 75),
    FlSpot(17, 73),
    FlSpot(18, 70),
    FlSpot(19, 68),
    FlSpot(20, 70),
    FlSpot(21, 72),
    FlSpot(22, 70),
    FlSpot(23, 65),
    FlSpot(24, 70),
    FlSpot(25, 74),
    FlSpot(26, 78),
    FlSpot(27, 80),
    FlSpot(28, 84),
    FlSpot(29, 86),
    FlSpot(30, 75)
  ];
  double currentStepCount = 1000;
  String currentStepCountTime = "Just now";
  double currentHeartRate = 78.0; // Default value
  String currentHeartRateTime = "Just now"; // Default description

  // Assume these values can be set by user interactions not shown here
  DateTime startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime endDate = DateTime.now();
  String aggregation = "hourly"; //



  double parseTimeToDouble(String dateTime) {
    List<String> parts = dateTime.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours / 24.0 + minutes / 1440.0;
  }

  String calculateTimeDescription(double timeValue) {
    int hour = (timeValue * 24).toInt();
    int minutes = ((timeValue * 1440) % 60).toInt();
    if(hour!=0 && minutes!=0) {
      return "$hour h and $minutes m";
    } else if (hour!=0) {
      return "$hour h";
    } else if (minutes!=0) {
      return "$minutes m";
    }
    return "No data available";
  }

  @override
  void initState() {
    super.initState();
    //fetchHeartRateData(); // Fetch initial data
    if (heartRateSpots.length > 21) {
      showingTooltipOnSpots = [21];
    } else if (heartRateSpots.isNotEmpty) {
      showingTooltipOnSpots = [heartRateSpots.length -1];
    }

    if (stepSpots.length > 21) {
      showingTooltipOnSpots = [21];
    } else if (stepSpots.isNotEmpty) {
      showingTooltipOnSpots = [stepSpots.length -1];
    }

    // fetchWeeklyBodyBattery();
  }

  @override
  Widget build(BuildContext context) {
    int touchedIndex = -1;
    var media = MediaQuery.of(context).size;

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: heartRateSpots,
        isCurved: false,
        barWidth: 2,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            TColor.primaryColor2.withOpacity(0.4),
            TColor.primaryColor1.withOpacity(0.1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: TColor.primaryG,
        ),
      ),
    ];

    List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
      switch (i) {
        case 0:
          return makeGroupData(0, 50, TColor.primaryG , isTouched: i == touchedIndex);
        case 1:
          return makeGroupData(1, 70, TColor.secondaryG, isTouched: i == touchedIndex);
        case 2:
          return makeGroupData(2, 60, TColor.primaryG , isTouched: i == touchedIndex);
        case 3:
          return makeGroupData(3, 50, TColor.secondaryG, isTouched: i == touchedIndex);
        case 4:
          return makeGroupData(4, 50, TColor.greyish , isTouched: i == touchedIndex);
        case 5:
          return makeGroupData(5, 90, TColor.greyish, isTouched: i == touchedIndex);
        case 6:
          return makeGroupData(6, 8.5, TColor.greyish , isTouched: i == touchedIndex);
        default:
          return throw Error();
      }
    });

    final tooltipsOnBar = lineBarsData[0];

    String? firstName = UserData().firstName;
    String? lastName = UserData().lastName;

    return Scaffold(
      backgroundColor: TColor.white,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back,",
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                        Text(
                          "$firstName $lastName",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Health metrics",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: TColor.primaryG),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: ["Daily","Weekly", "Monthly"]
                                .map((name) => DropdownMenuItem(
                              value: name,
                              child: Text(
                                name,
                                style: TextStyle(
                                    color: TColor.gray, fontSize: 14),
                              ),
                            ))
                                .toList(),
                            onChanged: (value) {},
                            icon: Icon(Icons.expand_more, color: TColor.white),
                            hint: Text(
                              "Weekly",
                              textAlign: TextAlign.center,
                              style:
                              TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: media.width * 0.5,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: TColor.primaryColor2.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Heart Rate Over Time",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                      colors: TColor.primaryG,
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight)
                                      .createShader(Rect.fromLTRB(
                                      0, 0, bounds.width, bounds.height));
                                },
                                child: Text(
                                  "$currentHeartRate BPM",
                                  style: TextStyle(
                                      color: TColor.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container (
                          height: media.height * 0.8,
                          child: LineChart(
                            LineChartData(
                              showingTooltipIndicators:
                              showingTooltipOnSpots.map((index) {
                                return ShowingTooltipIndicators([
                                  LineBarSpot(
                                    tooltipsOnBar,
                                    lineBarsData.indexOf(tooltipsOnBar),
                                    tooltipsOnBar.spots[index],
                                  ),
                                ]);
                              }).toList(),
                              lineTouchData: LineTouchData(
                                enabled: true,
                                handleBuiltInTouches: false,
                                touchCallback: (FlTouchEvent event,
                                    LineTouchResponse? response) {
                                  if (response == null ||
                                      response.lineBarSpots == null) {
                                    return;
                                  }
                                  if (event is FlTapUpEvent) {
                                    final spotIndex =
                                        response.lineBarSpots!.first.spotIndex;
                                    showingTooltipOnSpots.clear();
                                    final selectedSpot = heartRateSpots[spotIndex];
                                    setState(() {
                                      showingTooltipOnSpots.add(spotIndex);
                                      currentHeartRate = selectedSpot.y;
                                      currentHeartRateTime = calculateTimeDescription(selectedSpot.x);
                                    });
                                  }
                                },
                                mouseCursorResolver: (FlTouchEvent event,
                                    LineTouchResponse? response) {
                                  if (response == null ||
                                      response.lineBarSpots == null) {
                                    return SystemMouseCursors.basic;
                                  }
                                  return SystemMouseCursors.click;
                                },
                                getTouchedSpotIndicator:
                                    (LineChartBarData barData,
                                    List<int> spotIndexes) {
                                  return spotIndexes.map((index) {
                                    return TouchedSpotIndicatorData(
                                      FlLine(
                                        color: Colors.red,
                                      ),
                                      FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                              radius: 3,
                                              color: Colors.white,
                                              strokeWidth: 3,
                                              strokeColor: TColor.secondaryColor1,
                                            ),
                                      ),
                                    );
                                  }).toList();
                                },
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipBgColor: TColor.secondaryColor1,
                                  tooltipRoundedRadius: 20,
                                  getTooltipItems:
                                      (List<LineBarSpot> lineBarsSpot) {
                                    return lineBarsSpot.map((lineBarSpot) {
                                      return LineTooltipItem(
                                        "${lineBarSpot.x.toInt()} mins ag",
                                        const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                              lineBarsData: lineBarsData,
                              minY: 0,
                              maxY: 130,
                              titlesData: FlTitlesData(
                                show: false,
                              ),
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Body battery",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                Container(
                  height: media.width * 0.5,
                  padding: const EdgeInsets.symmetric(vertical: 15 , horizontal: 0),
                  decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 3)
                      ]),
                  child: BarChart(

                      BarChartData(
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                            tooltipMargin: 10,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String weekDay;
                              switch (group.x) {
                                case 0:
                                  weekDay = 'Monday';
                                  break;
                                case 1:
                                  weekDay = 'Tuesday';
                                  break;
                                case 2:
                                  weekDay = 'Wednesday';
                                  break;
                                case 3:
                                  weekDay = 'Thursday';
                                  break;
                                case 4:
                                  weekDay = 'Friday';
                                  break;
                                case 5:
                                  weekDay = 'Saturday';
                                  break;
                                case 6:
                                  weekDay = 'Sunday';
                                  break;
                                default:
                                  throw Error();
                              }
                              return BarTooltipItem(
                                '$weekDay\n',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: (rod.toY - 1).toString(),
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          touchCallback: (FlTouchEvent event, barTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  barTouchResponse == null ||
                                  barTouchResponse.spot == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex =
                                  barTouchResponse.spot!.touchedBarGroupIndex;
                            });
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles:  AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles:  AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: getTitles,
                              reservedSize: 38,
                            ),
                          ),
                          leftTitles:  AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: showingGroups(),
                        gridData:  FlGridData(show: false),
                      )

                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Container(
                //               width: double.maxFinite,
                //               height: media.width * 0.50,
                //               padding: const EdgeInsets.symmetric(
                //                   vertical: 25, horizontal: 20),
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius: BorderRadius.circular(25),
                //                   boxShadow: const [
                //                     BoxShadow(color: Colors.black12, blurRadius: 2)
                //                   ]),
                //               child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Text(
                //                       "Calories",
                //                       style: TextStyle(
                //                           color: TColor.black,
                //                           fontSize: 12,
                //                           fontWeight: FontWeight.w700),
                //                     ),
                //                     ShaderMask(
                //                       blendMode: BlendMode.srcIn,
                //                       shaderCallback: (bounds) {
                //                         return LinearGradient(
                //                             colors: TColor.primaryG,
                //                             begin: Alignment.centerLeft,
                //                             end: Alignment.centerRight)
                //                             .createShader(Rect.fromLTRB(
                //                             0, 0, bounds.width, bounds.height));
                //                       },
                //                       child: Text(
                //                         "760 kCal",
                //                         style: TextStyle(
                //                             color: TColor.white.withOpacity(0.7),
                //                             fontWeight: FontWeight.w700,
                //                             fontSize: 14),
                //                       ),
                //                     ),
                //                     const Spacer(),
                //                     Container(
                //                       alignment: Alignment.center,
                //                       child: SizedBox(
                //                         width: media.width * 0.2,
                //                         height: media.width * 0.2,
                //                         child: Stack(
                //                           alignment: Alignment.center,
                //                           children: [
                //                             Container(
                //                               width: media.width * 0.15,
                //                               height: media.width * 0.15,
                //                               alignment: Alignment.center,
                //                               decoration: BoxDecoration(
                //                                 gradient: LinearGradient(
                //                                     colors: TColor.primaryG),
                //                                 borderRadius: BorderRadius.circular(
                //                                     media.width * 0.075),
                //                               ),
                //                               child: FittedBox(
                //                                 child: Text(
                //                                   "230kCal\nleft",
                //                                   textAlign: TextAlign.center,
                //                                   style: TextStyle(
                //                                       color: TColor.white,
                //                                       fontSize: 11),
                //                                 ),
                //                               ),
                //                             ),
                //                             SimpleCircularProgressBar(
                //                               progressStrokeWidth: 10,
                //                               backStrokeWidth: 10,
                //                               progressColors: TColor.primaryG,
                //                               backColor: Colors.grey.shade100,
                //                               valueNotifier: ValueNotifier(50),
                //                               startAngle: -180,
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     )
                //                   ]),
                //             ),
                //           ],
                //         ))
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text =  Text('Sun', style: style);
        break;
      case 1:
        text =  Text('Mon', style: style);
        break;
      case 2:
        text =  Text('Tue', style: style);
        break;
      case 3:
        text =  Text('Wed', style: style);
        break;
      case 4:
        text =  Text('Thu', style: style);
        break;
      case 5:
        text =  Text('Fri', style: style);
        break;
      case 6:
        text =  Text('Sat', style: style);
        break;
      default:
        text =  Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y,
      List<Color> barColor,
      {
        bool isTouched = false,

        double width = 22,
        List<int> showTooltips = const [],
      }) {

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          gradient: LinearGradient(colors: barColor, begin: Alignment.topCenter, end: Alignment.bottomCenter ),
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.green)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: TColor.lightGray,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
          (i) {
        var color0 = TColor.secondaryColor1;

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color0,
                value: 33,
                title: '',
                radius: 55,
                titlePositionPercentageOffset: 0.55,
                badgeWidget: const Text(
                  "20,1",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ));
          case 1:
            return PieChartSectionData(
              color: Colors.white,
              value: 75,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
            );

          default:
            throw Error();
        }
      },
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,
  ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(colors: [
      TColor.primaryColor2.withOpacity(0.5),
      TColor.primaryColor1.withOpacity(0.5),
    ]),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 35),
      FlSpot(2, 70),
      FlSpot(3, 40),
      FlSpot(4, 80),
      FlSpot(5, 25),
      FlSpot(6, 70),
      FlSpot(7, 35),
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(colors: [
      TColor.secondaryColor2.withOpacity(0.5),
      TColor.secondaryColor1.withOpacity(0.5),
    ]),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
    ),
    spots: const [
      FlSpot(1, 80),
      FlSpot(2, 50),
      FlSpot(3, 90),
      FlSpot(4, 40),
      FlSpot(5, 80),
      FlSpot(6, 35),
      FlSpot(7, 60),
    ],
  );

  SideTitles get rightTitles => SideTitles(
    getTitlesWidget: rightTitleWidgets,
    showTitles: true,
    interval: 20,
    reservedSize: 40,
  );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: TColor.gray,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }
}