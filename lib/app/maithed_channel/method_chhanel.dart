import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelApp extends StatefulWidget {
  const MethodChannelApp({Key? key}) : super(key: key);

  @override
  State<MethodChannelApp> createState() => _MethodChannelAppState();
}

class _MethodChannelAppState extends State<MethodChannelApp> {
  static const platform = MethodChannel("methodChannel");

  String deviceType = "device not found";
  String _batteryLevel = 'Unknown battery level.';

  @override
  void initState() {
    checkDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Battery  Level"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              deviceType,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              _batteryLevel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void checkDevice() {
    setState(() {
      if (kIsWeb) {
        deviceType = "web";
      } else {
        if (Platform.isAndroid) {
          deviceType = "Android";
          _getBatteryLevelAndroidDevice();
        } else if (Platform.isIOS) {
          deviceType = "iOS";
        }
      }
    });
  }

  Future<void> _getBatteryLevelAndroidDevice() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }
}
