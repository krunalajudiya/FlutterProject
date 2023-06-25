import 'dart:async';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart' as da;

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(ForgroundTaskHandler());
}

class ForgroundTaskHandler extends TaskHandler {
  SendPort? _sendPort;

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
      foregroundTaskOptions: const ForegroundTaskOptions(interval: 5000),
      callback: sendData,
    );
    // await sendData();

    sendPort?.send(timestamp);
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {}

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed >> $id');
  }

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }

  sendData() async {
    Map<String, String> latLong = {};
    try {
      if (await checkLocationPermission()) {
        Position? position = await getLoaction();
        if (position != null) {
          latLong["name"] = position.latitude.toString();
          latLong["price"] = position.longitude.toString();
          latLong["description"] = DateTime.now().toString();
          // latLong["latitude"] = position.latitude;
          // latLong["longitude"] = position.longitude;
          print(position.latitude.toString());

          da.FormData bodydata = da.FormData.fromMap(latLong);

          var data = await da.Dio().postUri(
              Uri.parse(
                  "http://192.168.29.156/android_connect/create_product.php"),
              data: bodydata);
          print(data);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkLocationPermission() async {
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      return false;
    } else {
      return true;
    }
  }

  Future<Position?> getLoaction() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    } else {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
  }
}
