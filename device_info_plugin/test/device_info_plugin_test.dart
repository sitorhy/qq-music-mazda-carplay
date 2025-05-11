import 'package:flutter_test/flutter_test.dart';
import 'package:device_info_plugin/device_info_plugin.dart';
import 'package:device_info_plugin/device_info_plugin_platform_interface.dart';
import 'package:device_info_plugin/device_info_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeviceInfoPluginPlatform
    with MockPlatformInterfaceMixin
    implements DeviceInfoPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DeviceInfoPluginPlatform initialPlatform = DeviceInfoPluginPlatform.instance;

  test('$MethodChannelDeviceInfoPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDeviceInfoPlugin>());
  });

  test('getPlatformVersion', () async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    MockDeviceInfoPluginPlatform fakePlatform = MockDeviceInfoPluginPlatform();
    DeviceInfoPluginPlatform.instance = fakePlatform;

    expect(await deviceInfoPlugin.getPlatformVersion(), '42');
  });
}
