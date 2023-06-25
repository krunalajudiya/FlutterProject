import 'dart:convert';

import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../constants/urls.dart';
import '../utils/sharedpreferences_utils.dart';
import '../utils/fetch_utils.dart';

class Widgetspunchin {
  static const PUNCH_DATA_KEY = "punch_data";
  static const CLICK_PUNCH_BUTTON = "punch_btn_click";

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

  static Future puchincallback(Uri? uri) async {
    print(uri);
    if (uri?.host == "refresh_data") {
      await Refresh_data();
    }
    if (uri?.host == "punchin_btn_click") {
      print("punch");
    }
  }

  static Future Refresh_data() async {
    try {
      var response = await FetchUtils.callAPIGET(
          url: Urls.fetchDailyAttendanceData +
              await SharedpreferencesUtils.getEmployeeId(),
          context: null,
          loadingDialog: false);
      if (response["statusCode"] == 200) {
        var data = response["body"];
        var responseObj = data["responseObj"];
        Map<String, String> dataMap = {};

        dataMap["actualInTime"] =
            !CommonFunction.isNullOrIsEmpty(responseObj["actualInTime"])
                ? (DateFormat("h:mm a").format(DateFormat("yyyy-MM-dd hh:mm:ss")
                        .parse(responseObj["actualInTime"].toString())))
                    .toString()
                : "";
        dataMap["actualOutTime"] =
            !CommonFunction.isNullOrIsEmpty(responseObj["actualOutTime"])
                ? (DateFormat("h:mm a").format(DateFormat("yyyy-MM-dd hh:mm:ss")
                        .parse(responseObj["actualOutTime"].toString())))
                    .toString()
                : "";
        dataMap["startClock"] = responseObj["startClock"].toString();
        dataMap["totalSeconds"] = responseObj["totalSeconds"].toString();
        dataMap["punch_status"] = !CommonFunction.isNullOrIsEmpty(
                    responseObj["userTrackerLocationDtoList"]) &&
                responseObj["userTrackerLocationDtoList"].length > 0
            ? !CommonFunction.isNullOrIsEmpty(
                    responseObj["userTrackerLocationDtoList"][0]["to"])
                ? "PUNCH IN"
                : "PUNCH OUT"
            : "";
        print(dataMap);
        await HomeWidget.saveWidgetData(PUNCH_DATA_KEY, jsonEncode(dataMap));
        await HomeWidget.updateWidget(
            name: "PunchWidget", iOSName: "PunchWidget");
      } else {}
    } catch (e) {
      print(e);
    }
  }

  static Future call_punchinout_api() async {
    Position? position = await getlocation();
    if (position != null) {
      String? dataStore =
          await HomeWidget.getWidgetData(PUNCH_DATA_KEY, defaultValue: "");

      Map<String, String> body = {};
      body["employeeId"] = await SharedpreferencesUtils.getEmployeeId();
      body["punchInOrOut"] = !CommonFunction.isNullOrIsEmpty(dataStore)
          ? !CommonFunction.isNullOrIsEmpty(
                  jsonDecode(dataStore!)["punch_status"])
              ? (jsonDecode(dataStore)["punch_status"]).toString()
              : "PUNCH IN"
          : "PUNCH IN";
      body["currentLatitude"] = position.latitude.toString();
      body["currentLongitude"] = position.longitude.toString();

      print(body);

      var response = await FetchUtils.callAPIPOST(
          url: Urls.punchInOut,
          body: body,
          context: null,
          loadingDialog: false);
      if (response["statusCode"] == 200) {
        var data = response["body"];
        var responseObj = data["responseObj"];
        Map<String, String> dataMap = {};

        dataMap["actualInTime"] =
            !CommonFunction.isNullOrIsEmpty(responseObj["actualInTime"])
                ? (DateFormat("h:mm a").format(DateFormat("yyyy-MM-dd hh:mm:ss")
                        .parse(responseObj["actualInTime"].toString())))
                    .toString()
                : "";
        dataMap["actualOutTime"] =
            !CommonFunction.isNullOrIsEmpty(responseObj["actualOutTime"])
                ? (DateFormat("h:mm a").format(DateFormat("yyyy-MM-dd hh:mm:ss")
                        .parse(responseObj["actualOutTime"].toString())))
                    .toString()
                : "";
        dataMap["startClock"] = responseObj["startClock"].toString();
        dataMap["totalSeconds"] = responseObj["totalSeconds"].toString();
        dataMap["punch_status"] = !CommonFunction.isNullOrIsEmpty(
                    responseObj["userTrackerLocationDtoList"]) &&
                responseObj["userTrackerLocationDtoList"].length > 0
            ? !CommonFunction.isNullOrIsEmpty(
                    responseObj["userTrackerLocationDtoList"][0]["to"])
                ? "PUNCH IN"
                : "PUNCH OUT"
            : "";
        print("Punch request");
        await HomeWidget.saveWidgetData(PUNCH_DATA_KEY, jsonEncode(dataMap));
        await HomeWidget.saveWidgetData(CLICK_PUNCH_BUTTON, 1);
        await HomeWidget.updateWidget(
            name: "PunchWidget", iOSName: "PunchWidget");
      } else {
        msgtoast("Something Went Wrong");
      }
    }
  }

  static Future getlocation() async {
    try {
      if (await Geolocator.checkPermission() == LocationPermission.denied) {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          if (!await Geolocator.isLocationServiceEnabled()) {
            Geolocator.openLocationSettings();
            return null;
          } else {
            return await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
          }
        }
      } else {
        if (!await Geolocator.isLocationServiceEnabled()) {
          Geolocator.openLocationSettings();
          return null;
        } else {
          return await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
        }
      }
    } catch (e) {}
  }
}

class app extends StatelessWidget {
  const app({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "dd",
      // home: punchInOut(),
    );
  }
}
