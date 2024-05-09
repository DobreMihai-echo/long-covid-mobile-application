import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/gen/pigeon.dart',
  dartOptions: DartOptions(),
  kotlinOut:
  'android/app/src/main/kotlin/com/example/long_covid_android_ios_pigeons_garmin_connectiq/Pigeon.kt',
  kotlinOptions: KotlinOptions(
    package: 'com.example.long_covid_android_ios_pigeons_garmin_connectiq',
  ),
  // javaOut: 'android/app/src/main/java/io/flutter/plugins/Messages.java',
  // javaOptions: JavaOptions(),
  swiftOut: 'ios/Runner/Pigeon.swift',
  swiftOptions: SwiftOptions(),
  // objcHeaderOut: 'macos/Runner/messages.g.h',
  // objcSourceOut: 'macos/Runner/messages.g.m',
  // // Set this to a unique prefix for your plugin or application, per Objective-C naming conventions.
  // objcOptions: ObjcOptions(prefix: 'PGN'),
  // copyrightHeader: 'pigeons/copyright.txt',
  dartPackageName: 'long_covid_android_ios_pigeons_garmin_connectiq',
))
//
class HealthData {
  String? heartRate;
  String? calories;
}

@FlutterApi()
abstract class HealthUpdateApi {
  void updateHealthData(HealthData data);
}
