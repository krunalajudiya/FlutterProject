import 'dart:convert';

import 'package:emgage_flutter/src/features/login/view/employee_signin.dart';
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferencesUtils {
  static const companyInfoKey = "company_info";
  static const employeeDetialKey = "employeedetail_info";
  static const serverNoKey = "server_no";
  static const tokenKey = "token";
  static const userCredentials = "user_credentials";
  // static const allEmployeeDetialKey = "all_employee_detail";
  static const userRole = "user_role";
  static const languageTypeKey = "language_type";

  static setCompanyInfo(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(companyInfoKey, data);
  }

  static Future<String> getCompanyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(companyInfoKey).toString();
    return data;
  }

  static Future<bool> removeCompanyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    bool data = await prefs.remove(companyInfoKey);
    return data;
  }

  static setEmployeeDetailInfo(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(employeeDetialKey, data);
  }

  static Future<dynamic> getEmployeeDetailInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.get(employeeDetialKey).toString();
    if (data == "null") {
      return data;
    }
    final obj = jsonDecode(prefs.get(employeeDetialKey).toString());
    return obj;
  }

  static Future<String> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonDecode(prefs.get(employeeDetialKey).toString());
    return data["employeeId"].toString();
  }

  static Future<String> getEmployeeName() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonDecode(prefs.get(employeeDetialKey).toString());
    return "${data["firstName"]} ${data["lastName"]}";
  }

  static setServerNoInfo(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(serverNoKey, data);
  }

  static Future<String?> getServerNoInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(serverNoKey).toString();
    return data;
  }

  static setTokenInfo(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, data);
  }

  static Future<String?> getTokenInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(tokenKey).toString();
    return data;
  }

  static logoutUser(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(serverNoKey);
    await prefs.remove(employeeDetialKey);
    await prefs.remove(userRole);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => EmployeeSignin()),
        (Route route) => false);
  }

  static setUserCredentials(String detail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userCredentials, detail);
  }

  static Future<String?> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(userCredentials);
    return data;
  }

  static Future<bool> removeCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final data = await prefs.remove(userCredentials);
    return data;
  }

  // static setAllEmployeeDetail(String data) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(allEmployeeDetialKey, data);
  // }
  //
  // static Future getAllEmployeeDetail() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final data = prefs.getString(allEmployeeDetialKey);
  //   return jsonDecode(data.toString());
  // }

  static setUserRollDetail(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userRole, data);
  }

  static Future getUserRollDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(userRole);
    return !CommonFunction.isNullOrIsEmpty(data) ? jsonDecode(data!) : "";
  }

  static setLanguageDetail(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageTypeKey, data);
  }

  static Future getLanguageDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(languageTypeKey);
    return data;
  }
}
