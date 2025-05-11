import 'package:device_info_plugin/device_info_plugin_platform_interface.dart';
import 'package:get/get.dart';

class ResolutionRatio {
  int width = 0;
  int height = 0;
  int dpi = 0;
}

class DeviceInfoController extends GetxController {
  RxString platform = "".obs;
  RxString manufacturer = "".obs;
  Rx<ResolutionRatio> resolutionRatio = Rx<ResolutionRatio>(ResolutionRatio());
  RxInt memoryTotal = 0.obs;
  RxInt memoryAvail = 0.obs;
  RxInt storageTotal = 0.obs;
  RxInt storageAvail = 0.obs;
  RxInt extStorageTotal = 0.obs;
  RxInt extStorageAvail = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await loadInfo();
  }

  loadInfo() async {
    platform.value = await DeviceInfoPluginPlatform.instance.getPlatformVersion() ?? "";
    manufacturer.value = await DeviceInfoPluginPlatform.instance.getManufacturer() ?? "";

    Map<String, dynamic> info = await DeviceInfoPluginPlatform.instance.getResolutionRatio() ?? {};
    ResolutionRatio nextResolutionRatio = ResolutionRatio();
    nextResolutionRatio.width = info["width"];
    nextResolutionRatio.height = info["height"];
    nextResolutionRatio.dpi = info["dpi"];
    resolutionRatio.value = nextResolutionRatio;

    memoryTotal.value = await DeviceInfoPluginPlatform.instance.getTotalMemorySize() ?? 0;
    memoryAvail.value = await DeviceInfoPluginPlatform.instance.getAvailMemorySize() ?? 0;

    storageTotal.value = await DeviceInfoPluginPlatform.instance.getStorageSize() ?? 0;
    storageAvail.value = await DeviceInfoPluginPlatform.instance.getAvailStorageSize() ?? 0;

    extStorageTotal.value = await DeviceInfoPluginPlatform.instance.getExtStorageSize() ?? 0;
    extStorageAvail.value = await DeviceInfoPluginPlatform.instance.getAvailExtStorageSize() ?? 0;
  }
}