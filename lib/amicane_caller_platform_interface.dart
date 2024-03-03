import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amicane_caller_method_channel.dart';

abstract class AmicaneCallerPlatform extends PlatformInterface {
  /// Constructs a AmicaneCallerPlatform.
  AmicaneCallerPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmicaneCallerPlatform _instance = MethodChannelAmicaneCaller();

  /// The default instance of [AmicaneCallerPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmicaneCaller].
  static AmicaneCallerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmicaneCallerPlatform] when
  /// they register themselves.
  static set instance(AmicaneCallerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> placeCall(String phone) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> sendSMS(String phone, String message) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
