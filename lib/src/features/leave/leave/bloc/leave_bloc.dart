import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emgage_flutter/src/utils/sharedpreferences_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constants/ColorCode.dart';
import '../../../../constants/constants.dart';
import '../../../../utils/common_functions.dart';
import '../api/api.dart';
import '../model/extra_working_model.dart';
import '../model/leave_code_user_model.dart';
import '../model/leave_model.dart';

part 'leave_event.dart';

part 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  String? employeeId;
  int page = 0, size = 50;
  int totalRequestCount = 0;
  int totalApprovedCount = 0;
  List<LeaveModel> leaveModelList = [];
  bool filterDataLoad = true;
  Map<String, String> body = {};
  List<LeaveCodeUserModel> leaveCodeUserModelList = [];
  List<DropdownMenuEntry> leaveCodeDropdownMenuList = [];
  List<ExtraWorkingModel> extraWorkingModelList = [];
  List<DropdownMenuEntry> extraWorkingDropdownMenuList = [];
  Map<String, String> userLeaveDaysData = {};
  bool otherReasonVisibilityFlag = false;

  LeaveBloc() : super(LeaveInitial()) {
    on<LoadLeaveRequestListEvent>((event, emit) async {
      if (event.bottomLodaingView) {
        emit(LoadingState());
      }
      if (!CommonFunction.isNullOrIsEmpty(event.filterBody)) {
        body = event.filterBody!;
      }
      if (event.isReset) {
        page = 0;
        totalApprovedCount = 0;
        leaveModelList.clear();
      }

      employeeId = employeeId ?? await SharedpreferencesUtils.getEmployeeId();
      var data = await Api.getLeaveRequestListApi(event.context, employeeId!,
          Constants.typeOfList, page, size, body, event.showLoadingView);
      if (!CommonFunction.isNullOrIsEmpty(data)) {
        var responseObj = data["responseObj"];
        totalRequestCount = data["count"];
        for (int i = 0; i < responseObj.length; i++) {
          if (responseObj[i]["finalStatus"] == "Pending") {
            totalApprovedCount += 1;
          }

          responseObj[i]["leaveCode"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["leaveCode"])
                  ? ""
                  : responseObj[i]["leaveCode"];
          responseObj[i]["rep1Status"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["rep1Status"])
                  ? ""
                  : responseObj[i]["rep1Status"];
          responseObj[i]["rep2Status"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["rep2Status"])
                  ? ""
                  : responseObj[i]["rep2Status"];
          responseObj[i]["finalStatus"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["finalStatus"])
                  ? ""
                  : responseObj[i]["finalStatus"];
          responseObj[i]["typeDuration"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["typeDuration"])
                  ? ""
                  : responseObj[i]["typeDuration"];
          responseObj[i]["startDate"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["startDate"])
                  ? ""
                  : DateFormat("dd-MMM")
                      .format(DateFormat("yyyy-MM-dd")
                          .parse(responseObj[i]["startDate"]))
                      .replaceAll(("-"), "/");
          responseObj[i]["endDate"] = CommonFunction.isNullOrIsEmpty(
                  responseObj[i]["endDate"])
              ? ""
              : DateFormat("dd-MMM")
                  .format(
                      DateFormat("yyyy-MM-dd").parse(responseObj[i]["endDate"]))
                  .replaceAll(("-"), "/");
          leaveModelList.add(LeaveModel.fromJson(responseObj[i]));
        }
        emit(LoadLeaveRequestListState(
            totalRequestCount, totalApprovedCount, leaveModelList));
        page += 1;

        if (filterDataLoad) {
          filterDataLoad = false;
          List<DropdownMenuEntry> leaveCodeDropdownList = [];
          List<DropdownMenuEntry> employeeDropdownList =
              await CommonFunction.getChildEmployeeDropdownList();
          var data = await Api.filterLeaveCodeDataApi(event.context, false);
          if (!CommonFunction.isNullOrIsEmpty(data)) {
            data.forEach((value) {
              if (value["leaveCodeStatus"] == "ACTIVE") {
                leaveCodeDropdownList.add(DropdownMenuEntry(
                    value: value["leaveCodeName"],
                    label: value["leaveCodeName"]));
              }
            });
            emit(FilterDataLoadState(
                employeeDropdownList, leaveCodeDropdownList));
          }
        }
      }
    });
    on<LoadInitialDataEvent>((event, emit) async {
      List<DropdownMenuEntry> employeeList =
          await CommonFunction.getChildEmployeeDropdownList();
      if (employeeList.isNotEmpty) {
        emit(EmployeeListState(employeeList));
      } else {
        String employeeId = await SharedpreferencesUtils.getEmployeeId();
        await fetchLeaveCodeUserData(employeeId);
        await fetchExtraWorkingData(employeeId);
        userLeaveDaysData =
            await fetchUserLeaveDaysData(employeeId, event.date);
        emit(LoadInitialDataState(
            employeeId,
            leaveCodeDropdownMenuList,
            extraWorkingDropdownMenuList,
            userLeaveDaysData,
            leaveCodeUserModelList,
            extraWorkingModelList));
      }
    });

    on<SelectEmployeeIdEvent>((event, emit) async {
      await fetchLeaveCodeUserData(event.employeeId);
      await fetchExtraWorkingData(event.employeeId);
      userLeaveDaysData =
          await fetchUserLeaveDaysData(event.employeeId, event.date);
      emit(LoadInitialDataState(
          event.employeeId,
          leaveCodeDropdownMenuList,
          extraWorkingDropdownMenuList,
          userLeaveDaysData,
          leaveCodeUserModelList,
          extraWorkingModelList));
    });

    on<HalfDayLeaveCalculationEvent>((event, emit) async {
      String employeeId = event.employeeId;
      userLeaveDaysData = await halfDayLeaveDaysCalculation(
          employeeId, event.date, event.leaveDurationSelectType);
      emit(HalfDayLeaveCalculationState(userLeaveDaysData));
    });
    on<LeaveCodeSelectEvent>((event, emit) {
      bool fileUploadShowFlag = false;
      bool fileUploadMandatoryFlag = false;
      bool extraWorkingDropdownShowFlag = false;
      bool maternityTypeDropdownShowFlag = false;
      if (event.leaveCodeUserModelSelectValue.docUpload == "OPTIONAL") {
        fileUploadShowFlag = true;
        fileUploadMandatoryFlag = false;
      } else if (event.leaveCodeUserModelSelectValue.docUpload == "MANDATORY") {
        fileUploadShowFlag = true;
        if (int.parse(userLeaveDaysData["totalDays"]!) >=
            event.leaveCodeUserModelSelectValue.docUploadReqDays) {
          fileUploadMandatoryFlag = true;
          // fileupload_error_status = ColorCode.ERROR_COLOR;
        }
      } else {
        // fileupload_error_status = Colors.blue;
        fileUploadMandatoryFlag = false;
        fileUploadShowFlag = false;
      }
      if (event.leaveCodeUserModelSelectValue.leaveSubType == "MATERNITY" ||
          event.leaveCodeUserModelSelectValue.leaveSubType == "PATERNITY") {
        maternityTypeDropdownShowFlag = true;
        extraWorkingDropdownShowFlag = false;
      } else if (event.leaveCodeUserModelSelectValue.leaveSubType ==
          "COMPENSATORY_OFF") {
        extraWorkingDropdownShowFlag = true;
        maternityTypeDropdownShowFlag = false;
      }
      emit(LeaveCodeSelectState(fileUploadShowFlag, fileUploadMandatoryFlag,
          extraWorkingDropdownShowFlag, maternityTypeDropdownShowFlag));
    });

    on<SelectDateEvent>((event, emit) async {
      bool fileUploadShowFlag = false;
      bool fileUploadMandatoryFlag = false;
      Map<String, String> userLeaveDaysData = {};
      userLeaveDaysData =
          await fetchUserLeaveDaysData(event.employeeId, event.date);
      if (event.leaveCodeUserModelSelectValue != null) {
        if (event.leaveCodeUserModelSelectValue!.docUpload == "OPTIONAL") {
          fileUploadShowFlag = true;
          fileUploadMandatoryFlag = false;
        } else if (event.leaveCodeUserModelSelectValue!.docUpload ==
            "MANDATORY") {
          fileUploadShowFlag = true;
          if (int.parse(userLeaveDaysData["totalDays"]!) >=
              event.leaveCodeUserModelSelectValue!.docUploadReqDays) {
            fileUploadMandatoryFlag = true;
          }
        } else {
          fileUploadMandatoryFlag = false;
          fileUploadShowFlag = false;
        }
      }
      emit(SelectDateState(
          fileUploadShowFlag, fileUploadMandatoryFlag, userLeaveDaysData));
    });
    on<SubmitEvent>((event, emit) async {
      var reasonText = event.leaveReasonSelecteType == 2
          ? !CommonFunction.isNullOrIsEmpty(event.otherReasonText)
              ? event.otherReasonText
              : ColorCode.errorColor
          : event.leaveReasonTypeList[event.leaveReasonSelecteType];

      Color? employeeErrorStatus = event.employeeDropdownMenu.isNotEmpty &&
              CommonFunction.isNullOrIsEmpty(event.selectedEmployeeId)
          ? ColorCode.errorColor
          : null;

      Color? leaveCodeErrorStatus =
          CommonFunction.isNullOrIsEmpty(event.leaveCodeUserModel) ||
                  CommonFunction.isNullOrIsEmpty(event.leaveCodeText) ||
                  event.leaveCodeUserModel!.leaveCodeName != event.leaveCodeText
              ? ColorCode.errorColor
              : null;

      Color? paternityMaternityErrorStatus =
          event.maternityTypeDropdownShowFlag &&
                  CommonFunction.isNullOrIsEmpty(
                      event.maternityTypeDropdownSelectText) &&
                  event.paternityMaternityText !=
                      event.maternityTypeDropdownSelectText
              ? ColorCode.errorColor
              : null;

      Color? extraWorkingErrorStatus = event.extraWorkingDropdownShowFlag &&
              CommonFunction.isNullOrIsEmpty(event.extraWorkingModel) &&
              CommonFunction.isNullOrIsEmpty(event.extraWorkingText)
          ? ColorCode.errorColor
          : null;

      Color? fileUploadErrorStatus = event.fileUploadShowFlag &&
              event.fileUploadMandatoryFlag &&
              CommonFunction.isNullOrIsEmpty(event.fileContent)
          ? ColorCode.errorColor
          : null;

      if (employeeErrorStatus != ColorCode.errorColor &&
          leaveCodeErrorStatus != ColorCode.errorColor &&
          paternityMaternityErrorStatus != ColorCode.errorColor &&
          extraWorkingErrorStatus != ColorCode.errorColor &&
          reasonText != ColorCode.errorColor &&
          fileUploadErrorStatus != ColorCode.errorColor) {
        Map<String, dynamic> body = {};
        body["employeeId"] = event.selectedEmployeeId ??
            await SharedpreferencesUtils.getEmployeeId();
        body["leaveCode"] = event.leaveCodeUserModel!.leaveCodeName;
        body["leaveCodeId"] = event.leaveCodeUserModel!.leaveId.toString();
        body["leaveDurationString"] = event.leaveDurationSelectType == 0
            ? "FULL"
            : event.leaveDurationSelectType == 1
                ? "FIRST HALF"
                : "SECOND HALF";
        body["leaveDuration"] =
            event.leaveDurationSelectType == 0 ? "1" : "0.5";
        body["noOfDays"] = event.userLeaveDaysData.isNotEmpty
            ? userLeaveDaysData["totalDays"]
            : null;
        body["extraWorkingDate"] =
            !CommonFunction.isNullOrIsEmpty(event.extraWorkingModel)
                ? event.extraWorkingModel!.extraWorkingDate
                : null;
        body["extraWorkingId"] =
            !CommonFunction.isNullOrIsEmpty(event.extraWorkingModel)
                ? event.extraWorkingModel!.id
                : null;
        body["parentalSubType"] = event.maternityTypeDropdownShowFlag &&
                !CommonFunction.isNullOrIsEmpty(
                    event.maternityTypeDropdownSelectText)
            ? event.maternityTypeDropdownSelectText
            : null;
        body["fromDate"] = !CommonFunction.isNullOrIsEmpty(event.date)
            ? DateFormat("yyyy-MM-dd").format(
                DateFormat("dd-MM-yyyy").parse(event.date.split("\n")[0]))
            : null;
        body["toDate"] = !CommonFunction.isNullOrIsEmpty(event.date)
            ? event.date.split("\n").length > 1
                ? DateFormat("yyyy-MM-dd").format(
                    DateFormat("dd-MM-yyyy").parse(event.date.split("\n")[1]))
                : DateFormat("yyyy-MM-dd").format(
                    DateFormat("dd-MM-yyyy").parse(event.date.split("\n")[0]))
            : "";
        body["cancelReason"] = reasonText;
        body["fileContent"] =
            event.fileUploadMandatoryFlag ? event.fileContent : null;
        body["fileName"] =
            event.fileUploadMandatoryFlag ? event.fileName : null;
        body["isAdmin"] =
            await CommonFunction.getEmployeeRoleType() == 2 ? "false" : "true";

        var data = await Api.leaveRequestApi(event.context, body, true);
        if (!CommonFunction.isNullOrIsEmpty(data)) {
          if (data["code"] == 200) {
            CommonFunction.showToastMsg(data["message"]);
            emit(SubmitState());
          } else if (data["code"] == 204) {
            CommonFunction.showToastMsg(data["message"]);
          }
        }
      } else {
        emit(ValidateErrorState(
            reasonText,
            employeeErrorStatus,
            leaveCodeErrorStatus,
            paternityMaternityErrorStatus,
            extraWorkingErrorStatus,
            fileUploadErrorStatus));
      }
    });

    on<FileUploadEvent>((event, emit) async {
      if (await CommonFunction.checkStoragePermission()) {
        final fileType = [
          "jpg",
          "png",
          "jpeg",
          "pdf",
          "doc",
          "docx",
          "xls",
          "xlsx"
        ];
        File? file = await CommonFunction.uploadFile(fileType);
        if (file != null) {
          String fileName = CommonFunction.getFileName(file);
          String fileBase64 = CommonFunction.convertBase64(file);
          emit(FileUploadState(fileName, fileBase64));
        }
      }
    });

    on<ResetValueEvent>((event, emit) async {
      Map<String, String> userLeaveDaysData = {};
      if (event.employeeDropdownMenuList.isEmpty) {
        userLeaveDaysData =
            await fetchUserLeaveDaysData(event.employeeId, event.date);
      }
      emit(ResetValueState(userLeaveDaysData));
    });
  }

  fetchLeaveCodeUserData(employeeId) async {
    var leaveCodeData =
        await Api.getLeaveCodeUserDataApi(null, body, false, employeeId);
    if (!CommonFunction.isNullOrIsEmpty(leaveCodeData)) {
      leaveCodeUserModelList.clear();
      leaveCodeDropdownMenuList.clear();
      for (int i = 0; i < leaveCodeData.length; i++) {
        Map<String, dynamic> dataModel = {};
        dataModel["leaveId"] = leaveCodeData[i]["leaveCodeMaster"]["id"];
        dataModel["leaveCodeName"] =
            leaveCodeData[i]["leaveCodeMaster"]["leaveCodeName"];
        dataModel["leaveType"] =
            leaveCodeData[i]["leaveCodeMaster"]["leaveType"];
        dataModel["leaveSubType"] =
            leaveCodeData[i]["leaveCodeMaster"]["leaveSubType"];
        dataModel["docUpload"] = leaveCodeData[i]["docUpload"];
        dataModel["docUploadReqDays"] = leaveCodeData[i]["docUploadReqDays"];
        dataModel["remainingLeaveBalance"] =
            leaveCodeData[i]["remainingLeaveBalance"];
        dataModel["approvedLeaves"] = leaveCodeData[i]["approvedLeaves"];
        dataModel["appliedLeaves"] = leaveCodeData[i]["appliedLeaves"];
        dataModel["leavePolicyId"] = leaveCodeData[i]["id"];
        dataModel["showInLeaveRequestBalance"] =
            leaveCodeData[i]["showInLeaveRequestBalance"];
        leaveCodeUserModelList.add(LeaveCodeUserModel.fromJson(dataModel));
        leaveCodeDropdownMenuList.add(DropdownMenuEntry(
            value: i,
            label: leaveCodeData[i]["leaveCodeMaster"]["leaveCodeName"]));
      }
    }
  }

  fetchExtraWorkingData(employeeId) async {
    var data = await Api.getExtraWorkingDataApi(null, body, false, employeeId);
    if (!CommonFunction.isNullOrIsEmpty(data)) {
      for (int i = 0; i < data.length; i++) {
        extraWorkingModelList.add(ExtraWorkingModel.fromJson(data[i]));
        extraWorkingDropdownMenuList.add(
            DropdownMenuEntry(value: i, label: data[i]["extraWorkingDate"]));
      }
    }
  }

  fetchUserLeaveDaysData(employeeId, date) async {
    Map<String, String> body = {};
    body["employeeId"] = employeeId;
    body["fromDate"] = !CommonFunction.isNullOrIsEmpty(date)
        ? DateFormat("yyyy-MM-dd")
            .format(DateFormat("dd-MM-yyyy").parse(date.split("\n")[0]))
        : "";
    body["toDate"] = !CommonFunction.isNullOrIsEmpty(date)
        ? date.split("\n").length > 1
            ? DateFormat("yyyy-MM-dd")
                .format(DateFormat("dd-MM-yyyy").parse(date.split("\n")[1]))
            : DateFormat("yyyy-MM-dd")
                .format(DateFormat("dd-MM-yyyy").parse(date.split("\n")[0]))
        : "";
    Map<String, String> userLeaveDaysData = {};
    var data = await Api.getUserLeaveDaysDataApi(null, body, false);
    if (!CommonFunction.isNullOrIsEmpty(data)) {
      userLeaveDaysData["totalDays"] =
          !CommonFunction.isNullOrIsEmpty(data["totalDays"])
              ? data["totalDays"]
                  .toString()
                  .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "")
              : "0";
      userLeaveDaysData["actualDays"] =
          !CommonFunction.isNullOrIsEmpty(data["actualDays"])
              ? data["actualDays"]
                  .toString()
                  .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "")
              : "0";
      userLeaveDaysData["weekoffDays"] =
          !CommonFunction.isNullOrIsEmpty(data["weekOffDays"])
              ? data["weekOffDays"]
                  .toString()
                  .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "")
              : "0";
      userLeaveDaysData["holiday"] =
          !CommonFunction.isNullOrIsEmpty(data["holidayDays"])
              ? data["holidayDays"]
                  .toString()
                  .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "")
              : "0";
      userLeaveDaysData["workingDays"] =
          !CommonFunction.isNullOrIsEmpty(data["weekDays"])
              ? data["weekDays"]
                  .toString()
                  .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "")
              : "0";
      return userLeaveDaysData;
    }
    return userLeaveDaysData;
  }

  halfDayLeaveDaysCalculation(employeeId, date, leaveDurationSelectType) async {
    leaveDurationSelectType =
        date.split("\n").length != 1 ? 0 : leaveDurationSelectType;
    Map<String, String> userLeaveDaysData = {};
    userLeaveDaysData = await fetchUserLeaveDaysData(employeeId, date);
    if (userLeaveDaysData.isNotEmpty) {
      if (!CommonFunction.isNullOrIsEmpty(employeeId) &&
          (leaveDurationSelectType == 1 || leaveDurationSelectType == 2)) {
        if (userLeaveDaysData["weekoffDays"] == "0") {
          userLeaveDaysData["totalDays"] = "0.5";
          userLeaveDaysData["actualDays"] = "0.5";
          userLeaveDaysData["workingDays"] = "0.5";
        } else {
          userLeaveDaysData["totalDays"] = "0.5";
        }
      } else if (!CommonFunction.isNullOrIsEmpty(employeeId) &&
          leaveDurationSelectType == 0) {}
      return userLeaveDaysData;
    } else {
      return userLeaveDaysData;
    }
  }
}
