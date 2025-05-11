import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_info_plugin_method_channel.dart';

abstract class DeviceInfoPluginPlatform extends PlatformInterface {
  /// Constructs a DeviceInfoPluginPlatform.
  DeviceInfoPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceInfoPluginPlatform _instance = MethodChannelDeviceInfoPlugin();

  /// The default instance of [DeviceInfoPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceInfoPlugin].
  static DeviceInfoPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceInfoPluginPlatform] when
  /// they register themselves.
  static set instance(DeviceInfoPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getResolutionRatio() {
    throw UnimplementedError('resolutionRatio() has not been implemented.');
  }

  Future<int?> getAvailMemorySize() {
    throw UnimplementedError('getAvailMemorySize() has not been implemented.');
  }

  Future<int?> getTotalMemorySize() {
    throw UnimplementedError('getTotalMemorySize() has not been implemented.');
  }

  Future<int?> getStorageSize() {
    throw UnimplementedError('getStorageSize() has not been implemented.');
  }

  Future<int?> getAvailStorageSize() {
    throw UnimplementedError('getAvailStorageSize() has not been implemented.');
  }

  Future<int?> getExtStorageSize() {
    throw UnimplementedError('getExtStorageSize() has not been implemented.');
  }

  Future<int?> getAvailExtStorageSize() {
    throw UnimplementedError('getAvailExtStorageSize() has not been implemented.');
  }

  Future<String?> getManufacturer() {
    throw UnimplementedError('getManufacturer() has not been implemented.');
  }
}
