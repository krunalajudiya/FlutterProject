import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:emgage_flutter/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../commonWidgets/loadingview.dart';
import '../constants/urls.dart';
import 'sharedpreferences_utils.dart';

class FetchUtils {
  static Future callAPIGET(
      {required String url, context, loadingDialog = true}) async {
    try {
      if (loadingDialog) Loading.loadingDialog(context);
      var response = await Dio().getUri(await updateUrl(url),
          options: Options(headers: await getHeaders()));
      Map returnMap = await getReturnMap(url, response, context);
      if (loadingDialog) Navigator.pop(context);
      return returnMap;
    } on DioError catch (e) {
      if (DioErrorType.badResponse == e.type) {
        getReturnMap(url, e.response, context);
      } else if (DioErrorType.unknown == e.type) {}

      if (loadingDialog) Navigator.pop(context);
      return null;
    }
  }

  static Future callAPIPOST(
      {required String url,
      required Map<String, dynamic> body,
      context,
      loadingDialog = true}) async {
    try {
      if (loadingDialog) Loading.loadingDialog(context);
      var response = await Dio().postUri(await updateUrl(url),
          data: body, options: Options(headers: await getHeaders()));
      Map returnMap = await getReturnMap(url, response, context);
      if (loadingDialog) Navigator.pop(context);
      return returnMap;
    } on DioError catch (e) {
      if (DioErrorType.badResponse == e.type) {
        return await getReturnMap(url, e.response, context);
      } else if (DioErrorType.unknown == e.type) {}
      if (loadingDialog) Navigator.pop(context);
      return null;
    }
  }

  static Future<Map<String, String>?> getHeaders() async {
    Map<String, String> map = <String, String>{};
    map["Accept"] = "application/json";
    map["DEVICE"] = Constants.device;
    map["app-version"] = Constants.appVersion;
    map["Access-Control-Allow-Origin"] = Constants.accessControlAllowOrigin;
    map["Content-type"] = Constants.contentType;
    map["isSecure"] = Constants.isSecure;
    var token = await SharedpreferencesUtils.getTokenInfo();
    if (token != "null") {
      map["Authorization"] = token!;
    }
    return map;
  }

  static Future<Uri> updateUrl(String url) async {
    String? val = await SharedpreferencesUtils.getServerNoInfo();
    if (val != "null" && Urls.updateUrl == true) {
      return Uri.parse(url.replaceAll("api", "api${val!}"));
    } else {
      return Uri.parse(url);
    }
  }

  static Future<Map> getReturnMap(String url, response, context) async {
    Map returnMap = HashMap();
    returnMap["statusCode"] = response.statusCode;
    if (response.statusCode == 400 || response.statusCode == 500) {
    } else if (url != Urls.validateUserUrl &&
        (response.statusCode == 401 || response.statusCode == 405)) {
      returnMap["body"] = (response.data);
      String toastMsg = response.data["message"].toString();
      await SharedpreferencesUtils.logoutUser(context);
      Fluttertoast.showToast(
          msg: toastMsg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (response.statusCode == 200) {
      returnMap["body"] = (response.data);
    } else if (url == Urls.validateUserUrl &&
        (response.statusCode == 400 ||
            response.statusCode == 401 ||
            response.statusCode == 404 ||
            response.statusCode == 500 ||
            response.statusCode == 403)) {
      returnMap["body"] = (response.data);
    }
    return returnMap;
  }
}
