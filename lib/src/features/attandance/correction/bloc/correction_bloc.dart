// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:emgage_flutter/src/features/attandance/correction/model/correction_list_model.dart';
import 'package:emgage_flutter/src/models/employee/EmployeedetailModel.dart';
import 'package:emgage_flutter/src/utils/fetch_employee_detail.dart';
import 'package:emgage_flutter/src/utils/sharedpreferences_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constants/ColorCode.dart';
import '../../../../utils/common_functions.dart';
import '../api/api.dart';

part 'correction_event.dart';

part 'correction_state.dart';

class CorrectionBloc extends Bloc<CorrectionEvent, CorrectionState> {
  int page = 0;
  int size = 50;
  bool otherReasonVisible = false;
  int totalRequestCount = 0;
  int totalApprovedCount = 0;
  var correctionDate;
  String? employeeId;
  var companyId;
  String? requestType;
  String? onNextDay = "false";
  String? finalStatus = "Pending";
  var dataList;
  Map<String, String> body = {};

  Color? employeeErrorStatus,
      correctionDateErrorStatus,
      inTimeErrorStatus,
      outTimeErrorStatus,
      reasonErrorStatus,
      otherReasonErrorStatus;

  List<CorrectionlistModel> correctionList = [];

  CorrectionBloc() : super(CorrectionInitial()) {
    on<CorrectionEvent>((event, emit) {
      emit(CorrectionInitial());
    });

    on<LoadCorrectionEvent>((event, emit) async {
      if (!CommonFunction.isNullOrIsEmpty(event.body)) {
        body = event.body!;
      }
      if (event.isReset) {
        page = 0;
        correctionList.clear();
      }

      var dataList = await CorrectionApi.fetchCorrectionDataListApi(
          event.context,
          body,
          page,
          size,
          employeeId ??= await SharedpreferencesUtils.getEmployeeId());
      if (!CommonFunction.isNullOrIsEmpty(dataList)) {
        for (int i = 0; i < dataList.length; i++) {
          CorrectionlistModel correctionlistModel =
              CorrectionlistModel.fromJson(dataList[i]);

          if (dataList[i]["finalStatus"] == "Pending") totalApprovedCount += 1;

          if (FetchEmployeeDetail
                  .employeeDetail![(dataList[i]['employeeId'])] !=
              null) {
            employeedetailModel allEmployeeDetailModel = employeedetailModel();
            allEmployeeDetailModel = employeedetailModel.fromJson(
                FetchEmployeeDetail
                    .employeeDetail![(dataList[i]['employeeId'])]);
            correctionlistModel.firstName = allEmployeeDetailModel.firstName;
            correctionlistModel.lastName = allEmployeeDetailModel.lastName;
          }

          correctionlistModel.startDate =
              CommonFunction.isNullOrIsEmpty(dataList[i]['startDate'])
                  ? ""
                  : DateFormat("dd/MMM/yy").format(
                      DateTime.parse(dataList[i]['startDate'].toString()));

          correctionList.add(correctionlistModel);
        }
        totalRequestCount = dataList.length;

        emit(CorrectionLoadedState(
          totalRequestCount,
          totalApprovedCount,
          correctionList,
          page,
          size,
        ));
        page += 1;
      } else {
        ErrorState("No Data Found");
      }

      List<DropdownMenuEntry> employeeDropDownList =
          await CommonFunction.getChildEmployeeDropdownList();
      emit(FilterLoadedState(employeeDropDownList));
    });

    on<ShowOtherReasonFieldEvent>((event, emit) {
      otherReasonVisible = event.reasonType == "Other Reason" ? true : false;
      emit(ShowOtherReasonFieldState(otherReasonVisible));
    });

    on<SubmitCorrectionRequestEvent>((event, emit) async {
      employeeErrorStatus = CommonFunction.isNullOrIsEmpty(employeeId)
          ? ColorCode.errorColor
          : null;

      correctionDateErrorStatus =
          CommonFunction.isNullOrIsEmpty(correctionDate) &&
                  CommonFunction.isNullOrIsEmpty(
                      event.correctionDateTextEditingController)
              ? ColorCode.errorColor
              : null;

      inTimeErrorStatus =
          CommonFunction.isNullOrIsEmpty(event.inTimeTextEditingController) &&
                  CommonFunction.isNullOrIsEmpty(event.inTime)
              ? ColorCode.errorColor
              : null;

      outTimeErrorStatus =
          CommonFunction.isNullOrIsEmpty(event.outTimeTextEditingController) &&
                  CommonFunction.isNullOrIsEmpty(event.outTime)
              ? ColorCode.errorColor
              : null;

      reasonErrorStatus = CommonFunction.isNullOrIsEmpty(
                  event.reasonTypeTextEditingController) &&
              CommonFunction.isNullOrIsEmpty(event.resaonType)
          ? ColorCode.errorColor
          : null;

      otherReasonErrorStatus = (otherReasonVisible == true) &&
              (CommonFunction.isNullOrIsEmpty(
                  event.otherReasonTextEditingController))
          ? ColorCode.errorColor
          : null;

      if (employeeErrorStatus != ColorCode.errorColor &&
          correctionDateErrorStatus != ColorCode.errorColor &&
          inTimeErrorStatus != ColorCode.errorColor &&
          outTimeErrorStatus != ColorCode.errorColor &&
          reasonErrorStatus != ColorCode.errorColor &&
          otherReasonErrorStatus != ColorCode.errorColor) {
        companyId =
            (await SharedpreferencesUtils.getEmployeeDetailInfo())["companyId"];
        employeeId = (await SharedpreferencesUtils.getEmployeeId());
        if (event.inOutPunchBody['actualInTime'] != event.inTime &&
            event.inOutPunchBody['actualOutTime'] != event.outTime) {
          requestType = "In Out Punch Correction";
        } else if (event.inOutPunchBody['actualInTime'] != event.inTime &&
            event.inOutPunchBody['actualOutTime'] == event.outTime) {
          requestType = "In Punch Correction";
        } else if (event.inOutPunchBody['actualInTime'] == event.inTime &&
            event.inOutPunchBody['actualOutTime'] != event.outTime) {
          requestType = "Out Punch Correction";
        }

        if (event.inTime != null && event.outTime != null) {
          var intTimeData = DateFormat("HH:mm").parse(DateFormat("HH:mm")
              .format(DateFormat("hh:mm a").parse(event.inTime!)));
          var outTimeData = DateFormat("HH:mm").parse(DateFormat("HH:mm")
              .format(DateFormat("hh:mm a").parse(event.outTime!)));
          int startTimeInt = (intTimeData.hour * 60 + intTimeData.minute) * 60;
          int endTimeInt = (outTimeData.hour * 60 + outTimeData.minute) * 60;
          if (endTimeInt < startTimeInt) {
            onNextDay == "true";
          } else {
            onNextDay == "false";
          }
        }

        Map<String, dynamic> body = {};
        body["employeeId"] = employeeId;
        body["companyID"] = companyId;
        body["onNextDay"] = onNextDay;
        body["requestType"] = requestType;
        body["startDate"] = event.correctionDate;
        body["cancelReason"] = event.resaonType;
        body["inTime"] = event.inTime;
        body["outTime"] = event.outTime;
        body["finalStatus"] = finalStatus;
        var data = await CorrectionApi.setAttendanceCorrectionRequest(
            body, event.context, false);
        emit(SubmitCorrectionRequestState());
      } else {
        emit(ValidateFieldState(
            employeeErrorStatus,
            correctionDateErrorStatus,
            inTimeErrorStatus,
            outTimeErrorStatus,
            reasonErrorStatus,
            otherReasonErrorStatus));
      }
    });

    on<FetchPunchInOutTimeDataEvent>((event, emit) async {
      String? employeeIds = (await SharedpreferencesUtils.getEmployeeId());
      var data = await CorrectionApi.fetchPunchInOutTimeData(
          employeeIds, event.correctionDate, false);
      if (!CommonFunction.isNullOrIsEmpty(data)) {
        Map<String, dynamic> inOutPunchBody = {};
        inOutPunchBody["employeeId"] = data['employeeId'];
        inOutPunchBody["actualInTime"] = data["actualInTime"];
        inOutPunchBody["actualOutTime"] = data['actualOutTime'];
        inOutPunchBody["forDate"] = data['forDate'];
        inOutPunchBody["correctedInTime"] = data['correctedInTime'];
        inOutPunchBody["correctedOutTime"] = data['correctedOutTime'];

        var inTime = CommonFunction.isNullOrIsEmpty(data["actualInTime"])
            ? DateFormat('hh:mm a').format(DateFormat("yyyy-MM-dd hh:mm:ss")
                .parse(data['correctedInTime']))
            : DateFormat('hh:mm a').format(
                DateFormat("yyyy-MM-dd hh:mm:ss").parse(data["actualInTime"]));

        var outTime = CommonFunction.isNullOrIsEmpty(data['actualOutTime'])
            ? DateFormat('hh:mm a').format(DateFormat("yyyy-MM-dd hh:mm:ss")
                .parse(data['correctedOutTime']))
            : DateFormat('hh:mm a').format(
                DateFormat("yyyy-MM-dd hh:mm:ss").parse(data['actualOutTime']));

        var forDate = DateFormat("dd-MM-yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(data['forDate']));
        var correctionDate = (CommonFunction.isNullOrIsEmpty(forDate)
            ? null
            : DateFormat("yyyy-MM-dd")
                .format(DateFormat('dd-MM-yyyy').parse(forDate)))!;

        emit(FetchPunchInOutTimeDataState(
            inTime, outTime, correctionDate, inOutPunchBody));
      }
    });
  }

  Widget punchingRequestId(index) {
    if (dataList[index]['requestType'] == "In Punch Correction") {
      return Tooltip(
          message: "In Punch Correction",
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.teal.shade50,
              ),
              width: 30,
              child: const Center(
                  child: Text(
                "IN",
                style: TextStyle(color: Colors.black45),
              ))));
    } else if (dataList[index]['requestType'] == "In Out Punch Correction") {
      return Tooltip(
          message: "In Out Punch Correction",
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue.shade50,
              ),
              width: 50,
              child: const Center(
                  child: Text(
                "INOUT",
                style: TextStyle(color: Colors.black45),
              ))));
    } else if (dataList[index]['requestType'] == "Out Punch Correction") {
      return Tooltip(
          message: "Out Punch Correction",
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.orange.shade50,
              ),
              width: 40,
              child: const Center(
                  child: Text(
                "OUT",
                style: TextStyle(color: Colors.black45),
              ))));
    } else {
      return const Text("empty");
    }
  }
}
