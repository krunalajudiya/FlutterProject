import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:emgage_flutter/src/utils/sharedpreferences_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../constants/constants.dart';
import '../constants/image_path.dart';
import 'fetch_employee_detail.dart';
import '../models/employee/EmployeedetailModel.dart';

class CommonFunction {
  static bool isNullOrIsEmpty(obj) {
    return obj == null || obj == "" || obj == "null";
  }

  static Widget setManagerDialog(reportingPerson1Id, reportingPerson2Id,
      rep1ApprovedStatus, rep2ApprovedStatus) {
    String reportingPerson1 = CommonFunction.isNullOrIsEmpty(
            FetchEmployeeDetail.getEmployeeDetail()![(reportingPerson2Id)])
        ? Constants.dataNotFound
        : ((employeedetailModel.fromJson(
                    FetchEmployeeDetail.employeeDetail![(reportingPerson1Id)]))
                .firstName)
            .toString();
    String reportingPerson2 = CommonFunction.isNullOrIsEmpty(
            FetchEmployeeDetail.getEmployeeDetail()![(reportingPerson2Id)])
        ? Constants.dataNotFound
        : ((employeedetailModel.fromJson(
                    FetchEmployeeDetail.employeeDetail![(reportingPerson2Id)]))
                .firstName)
            .toString();

    return Container(
      child: (reportingPerson1 != Constants.dataNotFound ||
                  reportingPerson2 != Constants.dataNotFound) &&
              reportingPerson1Id != reportingPerson2Id
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(reportingPerson1 == Constants.dataNotFound
                        ? "${"Manager".tr} - $Constants.dataNotFound"
                        : "${"Manager".tr} - $reportingPerson1"),
                    Visibility(
                      visible: reportingPerson1 != Constants.dataNotFound,
                      child: Image.asset(
                        width: 20,
                        ImagePath.manAnim,
                        color: approvalColor(rep1ApprovedStatus),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(reportingPerson2 == Constants.dataNotFound
                        ? "${"S.Manager".tr} - $Constants.dataNotFound"
                        : "${"S.Manager".tr} - $reportingPerson2"),
                    Visibility(
                      visible: reportingPerson2 != Constants.dataNotFound,
                      child: Image.asset(
                        width: 20,
                        ImagePath.manAnim,
                        color: approvalColor(rep2ApprovedStatus),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(reportingPerson1 == Constants.dataNotFound &&
                            reportingPerson2 == Constants.dataNotFound
                        ? "${"Manager".tr} - $Constants.dataNotFound"
                        : "${"Manager & S.Manager".tr} - $reportingPerson1"),
                    Visibility(
                      visible: reportingPerson1 != Constants.dataNotFound &&
                          reportingPerson2 != Constants.dataNotFound,
                      child: Image.asset(
                        width: 30,
                        ImagePath.manAnim,
                        color: approvalColor(rep1ApprovedStatus),
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }

  static Color approvalColor(String status) {
    return status.toUpperCase() == "REJECTED" ||
            status.toUpperCase() == "REJECTE"
        ? Colors.red
        : status.toUpperCase() == "APPROVED" ||
                status.toUpperCase() == "APPROVE"
            ? Colors.green
            : status.toUpperCase() == "PENDING"
                ? Colors.grey
                : Colors.grey;
  }

  static List<Map<String, String>> fetchActiveChildEmployee() {
    List<Map<String, String>> employeeChildData = [];
    (FetchEmployeeDetail.getEmployeeDetail())!.forEach((key, value) {
      employeedetailModel employee = employeedetailModel.fromJson(value);
      if (employee.eemployeeStatus == "Active" && employee.isChild == true) {
        Map<String, String> employeeData = {};
        employeeData[employee.employeeId.toString()] =
            "${CommonFunction.isNullOrIsEmpty(employee.employeeId) ? "" : employee.employeeId.toString()}-${CommonFunction.isNullOrIsEmpty(employee.firstName) ? "" : employee.firstName.toString()} ${CommonFunction.isNullOrIsEmpty(employee.lastName) ? "" : employee.lastName.toString()}";
        employeeChildData.add(employeeData);
      }
    });
    return employeeChildData;
  }

  static Future<int> getEmployeeRoleType() async {
    var isadmin = await SharedpreferencesUtils.getUserRollDetail();
    return !CommonFunction.isNullOrIsEmpty(isadmin)
        ? isadmin["roleType"]
        : null;
  }

  static void showToastMsg(String msgTxt) {
    Fluttertoast.showToast(
        msg: msgTxt,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red.shade600,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showSuccessToastMsg(String msgTxt) {
    Fluttertoast.showToast(
        msg: msgTxt,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green.shade600,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Future<List<DropdownMenuEntry>> getChildEmployeeDropdownList() async {
    List<DropdownMenuEntry> employeeChildData = [];
    var employeeType = await getEmployeeRoleType();
    if ((employeeType == 1 || employeeType == 3) &&
        !CommonFunction.isNullOrIsEmpty(
            FetchEmployeeDetail.getEmployeeDetail())) {
      (FetchEmployeeDetail.getEmployeeDetail())!.forEach((key, value) {
        employeedetailModel employee = employeedetailModel.fromJson(value);
        if (employee.eemployeeStatus == "Active" && employee.isChild == true) {
          employeeChildData.add(DropdownMenuEntry(
              value: employee.employeeId,
              label:
                  "${employee.employeeId!} - ${employee.firstName!} ${employee.lastName!}"));
        }
      });
      return employeeChildData;
    }
    return employeeChildData;
  }

  static Future<int> getDeviceSdkVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidinfo = await deviceInfo.androidInfo;
    return androidinfo.version.sdkInt;
  }

  static Future<bool> checkStoragePermission() async {
    if (await getDeviceSdkVersion() >= 30) {
      var status = await Permission.manageExternalStorage.status;
      if (status.isDenied) {
        await Permission.manageExternalStorage.request();
        return false;
      } else if (status.isGranted) {
        return true;
      }
    } else {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        await Permission.storage.request();
        return false;
      } else if (status.isGranted) {
        return true;
      }
    }
    return false;
  }

  static finalStatus(String status) {
    if (status.toUpperCase() == "REJECTE" ||
        status.toUpperCase() == "REJECTED") {
      return Tooltip(
          message: "Rejected",
          child: Image.asset(
            ImagePath.finalReject,
            height: 20,
          ));
    } else if (status.toUpperCase() == "APPROVE" ||
        status.toUpperCase() == "APPROVED") {
      return Tooltip(
          message: "Approved",
          child: Image.asset(
            ImagePath.finalApprove,
            color: Colors.green,
            height: 20,
          ));
    } else if (status.toUpperCase() == "CANCEL" ||
        status.toUpperCase() == "CANCELLED") {
      return Tooltip(
          message: "cancelled",
          child: Image.asset(
            ImagePath.finalCancle,
            height: 20,
          ));
    } else {
      return Tooltip(
          message: "Pending",
          child: Image.asset(
            ImagePath.finalPanding,
            height: 20,
          ));
    }
  }

  static Future<File?> uploadFile(fileType) async {
    const fileMaxSize = 5000;
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: fileType);
    if (result != null) {
      if (result.files.single.size <= fileMaxSize) {
        File file = File(result.files.single.path.toString());
        return file;
      } else {
        CommonFunction.showToastMsg(Constants.largeFileLabel);
        return null;
      }
    }
    return null;
  }

  static String getFileName(File file) {
    return file.path.split("/").last;
  }

  static String convertBase64(File file) {
    return base64Encode(file.readAsBytesSync());
  }

  static pageRouteOrReplace(context, pageName) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => pageName));
  }

  static pageRoute(context, pageName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => pageName));
  }

  static backPage(context, popDataParse) {
    Navigator.pop(context, popDataParse);
  }

  static String dateFormat(
      String date, String actualDateFormat, String returnDateFormat) {
    return DateFormat(returnDateFormat)
        .format(DateFormat(actualDateFormat).parse(date));
  }

  static String dateISOFormat(String date, String returnDateFormat) {
    return DateFormat(returnDateFormat).format(DateTime.parse(date).toLocal());
  }

  static String dateTime12To24Format(String date) {
    return DateFormat.Hm().format(DateFormat.jm().parse(date));
  }

  static String percentageToHours(value) {
    String hours = "";
    if (!isNullOrIsEmpty(value)) {
      String pointbefore = value.toString().split(".")[0];
      String? pointafter = value.toString().split(".")[1];
      if (isNullOrIsEmpty(pointafter)) {
        hours = "$pointbefore:00";
      } else {
        double decimalTime =
            double.parse(value.toString()) - double.parse(pointbefore);
        hours =
            "$pointbefore:${DateFormat("mm").format(DateFormat("mm").parse(((decimalTime * 60).round()).toString()))}";
      }
    }
    return hours;
  }

  static String convertMinutesToHours(String value) {
    double totalMinutes = double.parse(value);
    if (totalMinutes < 0) {
      totalMinutes = 0;
    }
    var hours = (totalMinutes ~/ 60).round().toString().padLeft(2, "0");
    var minute = (totalMinutes % 60).round().toString().padLeft(2, "0");
    return "$hours:$minute";
  }

  static bool nextDayFlag(String time1, String time2, String timeFormat) {
    var firstTime = DateFormat(timeFormat).parse(time1);
    var secondTime = DateFormat(timeFormat).parse(time2);
    if ((secondTime.hour * 60 + secondTime.minute) * 60 <
        (firstTime.hour * 60 + firstTime.minute) * 60) {
      return true;
    } else {
      return false;
    }
  }

  static String transformSecondToHHmmss(int timeSeconds) {
    int milliseconds = timeSeconds * 1000;
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }
}
