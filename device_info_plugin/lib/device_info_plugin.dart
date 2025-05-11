
import 'device_info_plugin_platform_interface.dart';

class DeviceInfoPlugin {
  Future<String?> getPlatformVersion() {
    return DeviceInfoPluginPlatform.instance.getPlatformVersion();
  }

  Future<Map<String, dynamic>?> getResolutionRatio() {
    return DeviceInfoPluginPlatform.instance.getResolutionRatio();
  }

  Future<int?> getAvailMemorySize() {
    return DeviceInfoPluginPlatform.instance.getAvailMemorySize();
  }

  Future<int?> getTotalMemorySize() {
    return DeviceInfoPluginPlatform.instance.getTotalMemorySize();
  }

  Future<int?> getStorageSize() {
    return DeviceInfoPluginPlatform.instance.getStorageSize();
  }

  Future<int?> getAvailStorageSize() {
    return DeviceInfoPluginPlatform.instance.getAvailStorageSize();
  }

  Future<int?> getExtStorageSize() {
    return DeviceInfoPluginPlatform.instance.getExtStorageSize();
  }

  Future<int?> getAvailExtStorageSize() {
    return DeviceInfoPluginPlatform.instance.getAvailExtStorageSize();
  }

  Future<String?> getManufacturer() {
    return DeviceInfoPluginPlatform.instance.getManufacturer();
  }
}
