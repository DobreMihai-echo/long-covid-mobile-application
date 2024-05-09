// Autogenerated from Pigeon (v18.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

List<Object?> wrapResponse({Object? result, PlatformException? error, bool empty = false}) {
  if (empty) {
    return <Object?>[];
  }
  if (error == null) {
    return <Object?>[result];
  }
  return <Object?>[error.code, error.message, error.details];
}

class HealthData {
  HealthData({
    this.heartRate,
    this.calories,
  });

  String? heartRate;

  String? calories;

  Object encode() {
    return <Object?>[
      heartRate,
      calories,
    ];
  }

  static HealthData decode(Object result) {
    result as List<Object?>;
    return HealthData(
      heartRate: result[0] as String?,
      calories: result[1] as String?,
    );
  }
}

class _HealthUpdateApiCodec extends StandardMessageCodec {
  const _HealthUpdateApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is HealthData) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return HealthData.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class HealthUpdateApi {
  static const MessageCodec<Object?> pigeonChannelCodec = _HealthUpdateApiCodec();

  void updateHealthData(HealthData data);

  static void setUp(HealthUpdateApi? api, {BinaryMessenger? binaryMessenger, String messageChannelSuffix = '',}) {
    messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.long_covid_android_ios_pigeons_garmin_connectiq.HealthUpdateApi.updateHealthData$messageChannelSuffix', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.long_covid_android_ios_pigeons_garmin_connectiq.HealthUpdateApi.updateHealthData was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final HealthData? arg_data = (args[0] as HealthData?);
          assert(arg_data != null,
              'Argument for dev.flutter.pigeon.long_covid_android_ios_pigeons_garmin_connectiq.HealthUpdateApi.updateHealthData was null, expected non-null HealthData.');
          try {
            api.updateHealthData(arg_data!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}