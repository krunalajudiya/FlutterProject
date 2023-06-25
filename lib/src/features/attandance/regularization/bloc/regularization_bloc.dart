// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:emgage_flutter/src/models/employee/EmployeedetailModel.dart';
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:emgage_flutter/src/utils/fetch_employee_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/ColorCode.dart';
import '../../../../models/attandance/RegularizationcodeModel.dart';
import '../../../../utils/sharedpreferences_utils.dart';
import '../api/api.dart';
import '../model/regularization_list_model.dart';

part 'regularization_event.dart';

part 'regularization_state.dart';

class RegularizationBloc
    extends Bloc<RegularizationEvent, RegularizationState> {
  int page = 0;
  int size = 50;
  String? nextDayOut = "false";
  int totalRequestCount = 0;
  int totalPendingApprovedCount = 0;
  String? employeeId;
  var companyId;

  bool filterDataLoadFlag = true;

  bool otherReasonVisible = true;
  String dateLabelText = "From Date";
  bool toDateVisible = true;
  bool inTimeVisible = true;
  bool outTimeVisible = true;
  bool employeeFieldVisible = true;
  var dataList = [];
  var requestCodeDataList = [];

  Color? employeeErrorStatus,
      requestTypeErrorState,
      fromDateErrorState,
      toDateErrorState,
      inTimeErrorStatus,
      outTimeErrorStatus,
      reasonErrorStatus,
      otherReasonErrorStatus;

  Map<String, String> filterdData = {};
  List<RegularizationcodeModel> requestCodeList = [];

  List<RegularizationListModel> regularizationDataList = [];

  RegularizationBloc() : super(RegularizationInitial()) {
    on<RegularizationEvent>((event, emit) {
      emit(RegularizationInitial());
    });

    on<LoadRegularizationEvent>((event, emit) async {
      if (!CommonFunction.isNullOrIsEmpty(event.filterdData)) {
        filterdData = event.filterdData!;
      }

      if (event.isReset) {
        page = 0;
        regularizationDataList.clear();
      }

      dataList = await Api.fetchRegularizationDataListApi(
          event.context, filterdData, page, size);

      if (!CommonFunction.isNullOrIsEmpty(dataList)) {
        for (int i = 0; i < dataList.length; i++) {
          RegularizationListModel regularizationListModel =
              RegularizationListModel.fromJson(dataList[i]);
          if (dataList[i]["finalStatus"] == "Pending") {
            totalPendingApprovedCount += 1;
          }

          if (FetchEmployeeDetail
                  .employeeDetail![(dataList[i]['employeeId'])] !=
              null) {
            employeedetailModel allEmployeeDetailModel = employeedetailModel();
            allEmployeeDetailModel = employeedetailModel.fromJson(
                FetchEmployeeDetail
                    .employeeDetail![(dataList[i]['employeeId'])]);
            regularizationListModel.firstName =
                allEmployeeDetailModel.firstName;
            regularizationListModel.lastName = allEmployeeDetailModel.lastName;
          }
          regularizationDataList.add(regularizationListModel);
        }
        totalRequestCount = dataList.length;

        emit(RegularizationLoadedState(totalRequestCount,
            totalPendingApprovedCount, regularizationDataList, page, size));
        page += 1;
      } else {
        ErrorState("No Data Found");
      }

      if (filterDataLoadFlag) {
        filterDataLoadFlag = false;
        var data = await Api.fetchRegularizationCodeData(null, false);
        if (!CommonFunction.isNullOrIsEmpty(data)) {
          List<DropdownMenuEntry> employeeDropDownList =
              await CommonFunction.getChildEmployeeDropdownList();

          List<DropdownMenuEntry> regularizationCodeDropDownList = [];
          for (int i = 0; i < data.length; i++) {
            regularizationCodeDropDownList.add(DropdownMenuEntry(
                value: data[i]["regType"].toString(),
                label: data[i]["regType"].toString()));
          }
          regularizationCodeDropDownList.add(const DropdownMenuEntry(
              value: "Out Fence Punch In Request",
              label: "Out Fence Punch In Request"));
          regularizationCodeDropDownList.add(const DropdownMenuEntry(
              value: "Out Fence Punch In Request",
              label: "Out Fence Punch Out Request"));

          emit(LoadFilterContentState(
              employeeDropDownList, regularizationCodeDropDownList));
        }
      }
    });

    on<LoadRequestContentEvent>((event, emit) async {
      var data = await Api.fetchRegularizationCodeData(null, false);
      if (!CommonFunction.isNullOrIsEmpty(data)) {
        List<DropdownMenuEntry> employeeDropDownList =
            await CommonFunction.getChildEmployeeDropdownList();

        List<DropdownMenuEntry> regularizationCodeDropDownList = [];
        for (int i = 0; i < data.length; i++) {
          regularizationCodeDropDownList.add(
              DropdownMenuEntry(value: data[i], label: data[i]["regType"]));
        }
        emit(LoadRequestContentState(
            employeeDropDownList, regularizationCodeDropDownList));
      }
    });

    on<ShowRequestContentEvent>((event, emit) {
      dateLabelText = event.requestType == "Early Going Request" ||
              event.requestType == "Late Coming Request" ||
              event.requestType == "Time Off"
          ? "Selected Date"
          : "From Date";
      toDateVisible = event.requestType == "Late Coming Request" ||
              event.requestType == "Early Going Request" ||
              event.requestType == "Time Off"
          ? false
          : true;
      inTimeVisible = event.requestType == "Early Going Request" ? false : true;
      outTimeVisible =
          event.requestType == "Late Coming Request" ? false : true;
      emit(ShowRequestContentState(
          dateLabelText, inTimeVisible, outTimeVisible, toDateVisible));
    });
    on<ShowOtherReasonFieldEvent>((event, emit) {
      otherReasonVisible = event.reasonType == "Other Reason" ? true : false;
      emit(ShowOtherReasonFieldState(otherReasonVisible));
    });

    on<SubmitRegularizationRequestEvent>((event, emit) async {
      Map<String, dynamic> body = {};

      employeeErrorStatus = (event.employeeDropDownVisible == true) &&
              CommonFunction.isNullOrIsEmpty(employeeId)
          ? ColorCode.errorColor
          : null;

      requestTypeErrorState =
          CommonFunction.isNullOrIsEmpty(event.requestType) &&
                  CommonFunction.isNullOrIsEmpty(
                      event.requestTypeTextEditingController)
              ? ColorCode.errorColor
              : null;

      fromDateErrorState = CommonFunction.isNullOrIsEmpty(event.fromDate) &&
              CommonFunction.isNullOrIsEmpty(
                  event.fromDateTextEditingController)
          ? ColorCode.errorColor
          : null;

      toDateErrorState = (toDateVisible = true) &&
              (CommonFunction.isNullOrIsEmpty(event.toDate) &&
                  CommonFunction.isNullOrIsEmpty(
                      event.toDateTextEditingController))
          ? ColorCode.errorColor
          : null;

      inTimeErrorStatus = (inTimeVisible == true) &&
              (CommonFunction.isNullOrIsEmpty(event.inTime) &&
                  CommonFunction.isNullOrIsEmpty(
                      event.inTimeTextEditingController))
          ? ColorCode.errorColor
          : null;

      outTimeErrorStatus = (outTimeVisible == true) &&
              (CommonFunction.isNullOrIsEmpty(event.outTime) &&
                  CommonFunction.isNullOrIsEmpty(
                      event.outTimeTextEditingController))
          ? ColorCode.errorColor
          : null;

      reasonErrorStatus = CommonFunction.isNullOrIsEmpty(event.reasonType) &&
              CommonFunction.isNullOrIsEmpty(event.reasonTextEditingController)
          ? ColorCode.errorColor
          : null;

      otherReasonErrorStatus = (otherReasonVisible == true) &&
              CommonFunction.isNullOrIsEmpty(event.reasonType) &&
              (CommonFunction.isNullOrIsEmpty(
                  event.otherReasonTextEditingController))
          ? ColorCode.errorColor
          : null;

      if (employeeErrorStatus != ColorCode.errorColor &&
          requestTypeErrorState != ColorCode.errorColor &&
          fromDateErrorState != ColorCode.errorColor &&
          toDateErrorState != ColorCode.errorColor &&
          inTimeErrorStatus != ColorCode.errorColor &&
          outTimeErrorStatus != ColorCode.errorColor &&
          reasonErrorStatus != ColorCode.errorColor &&
          otherReasonErrorStatus != ColorCode.errorColor) {
        companyId =
            (await SharedpreferencesUtils.getEmployeeDetailInfo())["companyId"];
        employeeId = (await SharedpreferencesUtils.getEmployeeId());

        if (event.inTime != null && event.outTime != null) {
          var inttime = DateFormat("HH:mm").parse(DateFormat("HH:mm")
              .format(DateFormat("hh:mm a").parse(event.inTime!)));
          var outtime = DateFormat("HH:mm").parse(DateFormat("HH:mm")
              .format(DateFormat("hh:mm a").parse(event.outTime!)));
          int startTimeInt = (inttime.hour * 60 + inttime.minute) * 60;
          int endTimeInt = (outtime.hour * 60 + outtime.minute) * 60;
          if (endTimeInt < startTimeInt) {
            nextDayOut == "true";
          } else {
            nextDayOut == "false";
          }
        }
        var fromDate = CommonFunction.isNullOrIsEmpty(event.fromDate)
            ? ""
            : DateFormat("yyyy-MM-dd")
                .format(DateFormat("dd-MM-yyyy").parse(event.fromDate!));

        var toDate = CommonFunction.isNullOrIsEmpty(event.toDate)
            ? ""
            : DateFormat('yyyy-MM-dd')
                .format(DateFormat("dd-MM-yyyy").parse(event.toDate!));

        var punchInTime = CommonFunction.isNullOrIsEmpty(event.inTime)
            ? null
            : DateFormat("hh:mm:ss a")
                .format(DateFormat("hh:mm a").parse(event.inTime!));

        var punchOutTime = CommonFunction.isNullOrIsEmpty(event.outTime)
            ? null
            : DateFormat("hh:mm:ss a")
                .format(DateFormat("hh:mm a").parse(event.outTime!));

        body["employeeId"] = employeeId;
        body["companyId"] = companyId;
        body["requestTypeId"] = event.requestTypeId;
        body["oneDayOut"] = nextDayOut!;
        body["requestTypeName"] = event.requestType;
        body["fromDate"] = fromDate;
        body["toDate"] = toDate;
        body["inTime"] = punchInTime;
        body["outTime"] = punchOutTime;
        body["cancelReason"] = event.reasonType;

        var data = await Api.setAttendanceRegularizationRequest(
            body, event.context, false);
        emit(SubmitRegularizationRequestState());
      } else {
        emit(ValidateFieldsState(
            employeeErrorStatus,
            requestTypeErrorState,
            fromDateErrorState,
            toDateErrorState,
            inTimeErrorStatus,
            outTimeErrorStatus,
            reasonErrorStatus,
            otherReasonErrorStatus));
      }
    });
  }
}
