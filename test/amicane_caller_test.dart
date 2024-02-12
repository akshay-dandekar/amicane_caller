import 'package:flutter_test/flutter_test.dart';
import 'package:amicane_caller/amicane_caller.dart';
import 'package:amicane_caller/amicane_caller_platform_interface.dart';
import 'package:amicane_caller/amicane_caller_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAmicaneCallerPlatform
    with MockPlatformInterfaceMixin
    implements AmicaneCallerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AmicaneCallerPlatform initialPlatform = AmicaneCallerPlatform.instance;

  test('$MethodChannelAmicaneCaller is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAmicaneCaller>());
  });

  test('getPlatformVersion', () async {
    AmicaneCaller amicaneCallerPlugin = AmicaneCaller();
    MockAmicaneCallerPlatform fakePlatform = MockAmicaneCallerPlatform();
    AmicaneCallerPlatform.instance = fakePlatform;

    expect(await amicaneCallerPlugin.getPlatformVersion(), '42');
  });
}
