// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:emgage_flutter/src/features/attandance/punching/api/api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/common_functions.dart';
import 'package:intl/intl.dart';
import '../../../../utils/fetch_employee_detail.dart';
import '../../../../utils/get_permission.dart';
import '../../../../utils/sharedpreferences_utils.dart';
import '../model/PunchingListModel.dart';

part 'punching_event.dart';

part 'punching_state.dart';

class PunchingBloc extends Bloc<PunchingEvent, PunchingState> {
  Position? currentPosition;
  var punchInOrOut = "PUNCH IN";
  var imageSrcData;
  var mobilePunchInImage;
  var mobilePunchOutImage;
  File? image;

  var elapsedTime;
  Timer? timer;

  PunchingBloc() : super(PunchingInitial()) {
    on<PunchingInitialEvent>((event, emit) {});

    on<PunchingLoadEvent>((event, emit) async {
      openCameraAndPunching();
      Map<String, dynamic> body = {};
      body['employeeId'] = await SharedpreferencesUtils.getEmployeeId();
      body['currentLatitude'] = currentPosition!.latitude;
      body['currentLongitude'] = currentPosition!.longitude;
      body['punchInOrOut'] = punchInOrOut;
      body['punchInOutImage'] = imageSrcData;

      var data = await Api.multiPunchingDataApi(event.context, body);

      if (!CommonFunction.isNullOrIsEmpty(data)) {
        if (data["code"] == 204) {
          CommonFunction.showToastMsg(data["message"]);
        } else {
          emit(PunchingActionState());
        }
      }
    });

    on<FetchDailyAttendanceDataEvent>((event, emit) async {
      var dailyAttendance,
          punchInTime,
          punchOutTime,
          outTimeText,
          employeeNameText,
          startClock;

      List userTrackerLocationDtoList = [];
      List<PunchingListModel> punchingListModel = [];

      final hasPermission = await GetPermission.checkLocationPermission();
      if (!hasPermission) return;
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        currentPosition = position;
      }).catchError((e) {});

      dailyAttendance = await Api.fetchDailyAttandanceDataApi(event.context);
      employeeNameText = await SharedpreferencesUtils.getEmployeeName();

      if (dailyAttendance != null) {
        userTrackerLocationDtoList =
            !CommonFunction.isNullOrIsEmpty(dailyAttendance)
                ? !CommonFunction.isNullOrIsEmpty(
                        dailyAttendance["userTrackerLocationDtoList"])
                    ? dailyAttendance["userTrackerLocationDtoList"]
                    : []
                : [];
      } else {
        await FetchEmployeeDetail.setEmployeeDetail();
      }

      if (!CommonFunction.isNullOrIsEmpty(userTrackerLocationDtoList) &&
          userTrackerLocationDtoList.isNotEmpty) {
        if (!CommonFunction.isNullOrIsEmpty(
            userTrackerLocationDtoList[0]["to"])) {
          punchInOrOut = "PUNCH IN";
        } else {
          punchInOrOut = "PUNCH OUT";
        }
      }

      mobilePunchInImage = dailyAttendance["mobilePunchInImage"];
      mobilePunchOutImage = dailyAttendance["mobilePunchOutImage"];

      punchInTime =
          dailyAttendance != null && dailyAttendance["actualInTime"] != null
              ? DateFormat('hh:mm a').format(DateFormat("yyyy-MM-dd hh:mm:ss")
                  .parse(dailyAttendance["actualInTime"]))
              : "00:00";

      punchOutTime =
          dailyAttendance != null && dailyAttendance["actualOutTime"] != null
              ? DateFormat('hh:mm a').format(DateFormat("yyyy-MM-dd hh:mm:ss")
                  .parse(dailyAttendance["actualOutTime"]))
              : "";

      outTimeText = CommonFunction.isNullOrIsEmpty(dailyAttendance) &&
              CommonFunction.isNullOrIsEmpty(["actualOutTime"])
          ? ''
          : "\nOut Time";

      int totalElapsedTime = !CommonFunction.isNullOrIsEmpty(dailyAttendance) &&
              !CommonFunction.isNullOrIsEmpty(dailyAttendance["totalSeconds"])
          ? dailyAttendance["totalSeconds"]
          : 0;

      startClock =
          !CommonFunction.isNullOrIsEmpty(dailyAttendance["startClock"])
              ? dailyAttendance["startClock"]
              : false;

      for (int i = 0; i < userTrackerLocationDtoList.length; i++) {
        punchingListModel.add(PunchingListModel(
          srNO: i.toString(),
          inTime: CommonFunction.isNullOrIsEmpty(
                  multiPunchingDataList(userTrackerLocationDtoList[i]["from"]))
              ? "--"
              : multiPunchingDataList(userTrackerLocationDtoList[i]["from"]),
          outTime: CommonFunction.isNullOrIsEmpty(
                  multiPunchingDataList(userTrackerLocationDtoList[i]["to"]))
              ? "--"
              : multiPunchingDataList(userTrackerLocationDtoList[i]["to"]),
          duration: !CommonFunction.isNullOrIsEmpty(
                      userTrackerLocationDtoList[i]["to"]) &&
                  !CommonFunction.isNullOrIsEmpty(
                      userTrackerLocationDtoList[i]["from"])
              ? duration(DateTime.parse(
                      userTrackerLocationDtoList[i]["to"]['dateString'])
                  .difference(DateTime.parse(
                      userTrackerLocationDtoList[i]["from"]['dateString'])))
              : "--",
        ));
      }
      emit(LoadDailyAttendanceDataState(
          dailyAttendance,
          punchInOrOut,
          imageSrcData,
          totalElapsedTime,
          mobilePunchInImage,
          mobilePunchOutImage,
          userTrackerLocationDtoList,
          punchInTime,
          punchOutTime,
          outTimeText,
          employeeNameText,
          currentPosition,
          punchingListModel,
          startClock));
      await FetchEmployeeDetail.setEmployeeDetail();
    });

    on<StartTimerEvent>((event, emit) async {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        elapsedTime++;
        emit(StartTimerState(elapsedTime));
      });
    });
  }

  multiPunchingDataList(userTracker) {
    return !CommonFunction.isNullOrIsEmpty(userTracker) &&
            !CommonFunction.isNullOrIsEmpty(userTracker['dateString'])
        ? DateFormat('hh:mm a').format(
            DateFormat("yyyy-MM-dd hh:mm:ss").parse(userTracker['dateString']))
        : " ";
  }

  Future pickImage(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 10);
      if (image == null) return;

      final imageTemporary = File(image.path);
      this.image = imageTemporary;

      final bytes = await image.readAsBytes();
      String base64Image = base64Encode(bytes);

      imageSrcData = "data:image/jpeg;base64,$base64Image";
    } on PlatformException catch (e) {
      return ErrorState(e.toString());
    }
  }

  openCameraAndPunching() {
    if (punchInOrOut == "PUNCH IN" && mobilePunchInImage > 0 ||
        (punchInOrOut == "PUNCH OUT" && mobilePunchOutImage > 0)) {
      pickImage(ImageSource.camera);
    }
  }

  String duration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
