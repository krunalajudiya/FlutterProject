import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_widget/home_widget.dart';

class Widgetsfunction {
  static void msgtoast(String msgTxt) {
    Fluttertoast.showToast(
        msg: msgTxt,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Future<void> backgroundCallback(Uri? uri) async {
    if (uri?.host == 'innerbtnclick') {
      await HomeWidget.getWidgetData<int>('punch', defaultValue: 0)
          .then((value) async {
        if (value == 0) {
          await HomeWidget.saveWidgetData<int>('punch', 1);
          await HomeWidget.updateWidget(
              //this must the class name used in .Kt
              name: 'AppWidget',
              iOSName: 'AppWidget');
          msgtoast("punch in");
        } else if (value == 1) {
          await HomeWidget.saveWidgetData<int>('punch', 0);
          await HomeWidget.saveWidgetData<int>('progress', 0);
          await HomeWidget.updateWidget(
              //this must the class name used in .Kt
              name: 'AppWidget',
              iOSName: 'AppWidget');
        }
        msgtoast("Punch Out");
      });
    }
  }
}
