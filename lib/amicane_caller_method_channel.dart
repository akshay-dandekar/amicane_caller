import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'amicane_caller_platform_interface.dart';

/// An implementation of [AmicaneCallerPlatform] that uses method channels.
class MethodChannelAmicaneCaller extends AmicaneCallerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('amicane_caller');

  @override
  Future<String?> placeCall(String phone) async {
    final version =
        await methodChannel.invokeMethod<String>('placeCall', {"phone": phone});
    return version;
  }

  @override
  Future<String?> sendSMS(String phone, String message) async {
    final version = await methodChannel.invokeMethod<String>(
        'sendSms', {"phone": phone, "message": message});
    return version;
  }

  @override
  Future<String?> bringToForeground(String activityPkg, String activityName) async {
    final version = await methodChannel.invokeMethod<String>(
        'bringToForeground', {"activityPkg": activityPkg, "activityName": activityName});
    return version;
  }
}
