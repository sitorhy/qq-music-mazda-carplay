import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device_info_plugin_platform_interface.dart';

/// An implementation of [DeviceInfoPluginPlatform] that uses method channels.
class MethodChannelDeviceInfoPlugin extends DeviceInfoPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('device_info_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Map<String, dynamic>?> getResolutionRatio() async {
    final info = await methodChannel.invokeMethod<Map<Object?, Object?>>('getResolutionRatio');
    if (info == null) {
      return null;
    }
    return Map<String, dynamic>.from(info);
  }

  @override
  Future<int?> getAvailMemorySize() async {
    final size = await methodChannel.invokeMethod<int>('getAvailMemorySize');
    return size;
  }

  @override
  Future<int?> getTotalMemorySize() async {
    final size = await methodChannel.invokeMethod<int>('getTotalMemorySize');
    return size;
  }

  @override
  Future<int?> getStorageSize() async {
    final size = await methodChannel.invokeMethod<int>('getStorageSize');
    return size;
  }

  @override
  Future<int?> getAvailStorageSize() async {
    final size = await methodChannel.invokeMethod<int>('getAvailStorageSize');
    return size;
  }

  @override
  Future<int?> getExtStorageSize() async {
    final size = await methodChannel.invokeMethod<int>('getExtStorageSize');
    return size;
  }

  @override
  Future<int?> getAvailExtStorageSize() async {
    final size = await methodChannel.invokeMethod<int>('getAvailExtStorageSize');
    return size;
  }

  @override
  Future<String?> getManufacturer() async {
    final manufacturer = await methodChannel.invokeMethod<String>('getManufacturer');
    return manufacturer;
  }
}
