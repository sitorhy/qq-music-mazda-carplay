import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:device_info_plugin/device_info_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _manufacturer = 'Unknown';
  Map<String, dynamic> _resolutionInfo = {};
  int _availMemSize = 0;
  int _totalMemSize = 0;
  int _storageSize = 0;
  int _availStorageSize = 0;
  int _extStorageSize = 0;
  int _extAvailStorageSize = 0;

  final _deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = "";
    String manufacturer = "";
    Map<String, dynamic> resolutionInfo = {};
    int availMemSize = 0;
    int totalMemSize = 0;
    int storageSize = 0;
    int availStorageSize = 0;
    int extStorageSize = 0;
    int extAvailStorageSize = 0;

    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _deviceInfoPlugin.getPlatformVersion() ??
          'Unknown platform version';
      manufacturer =
          await _deviceInfoPlugin.getManufacturer() ?? 'Unknown manufacturer';
      resolutionInfo =
          await _deviceInfoPlugin.getResolutionRatio() ?? <String, dynamic>{};
      availMemSize = await _deviceInfoPlugin.getAvailMemorySize() ?? 0;
      totalMemSize = await _deviceInfoPlugin.getTotalMemorySize() ?? 0;
      storageSize = await _deviceInfoPlugin.getStorageSize() ?? 0;
      availStorageSize = await _deviceInfoPlugin.getAvailStorageSize() ?? 0;
      extStorageSize = await _deviceInfoPlugin.getExtStorageSize() ?? 0;
      extAvailStorageSize =
          await _deviceInfoPlugin.getAvailExtStorageSize() ?? 0;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _resolutionInfo = resolutionInfo;
      _availMemSize = availMemSize;
      _totalMemSize = totalMemSize;
      _storageSize = storageSize;
      _availStorageSize = availStorageSize;
      _extStorageSize = extStorageSize;
      _extAvailStorageSize = extAvailStorageSize;
      _manufacturer = manufacturer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion'),
              Text('Manufacturer: $_manufacturer'),
              Text('Resolution ratio: $_resolutionInfo'),
              // 可用内存 Bytes
              Text(
                'Avail memory size: ${(_availMemSize / 1024 / 1024 / 1024).ceil()}GB',
              ),
              Text(
                'Total memory size: ${(_totalMemSize / 1024 / 1024 / 1024).ceil()}GB',
              ),
              // 内置存储 Bytes
              Text(
                'Avail storage size: ${(_availStorageSize / 1024 / 1024 / 1024).ceil()}GB',
              ),
              Text(
                'Total storage size: ${(_storageSize / 1024 / 1024 / 1024).ceil()}GB',
              ),
              // 外置存储 Bytes
              Text(
                'Avail ext storage size: ${(_extAvailStorageSize / 1024 / 1024).ceil()}MB',
              ),
              Text(
                'Total ext storage size: ${(_extStorageSize / 1024 / 1024).ceil()}MB',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
