import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:emgage_flutter/src/utils/sharedpreferences_utils.dart';
import 'package:intl/intl.dart';
import 'package:equatable/equatable.dart';
import '../../../../constants/ColorCode.dart';
import '../../../../constants/constants.dart';
import '../api/api.dart';
import '../model/extra_working_model.dart';

part 'extra_working_event.dart';

part 'extra_working_state.dart';

class ExtraWorkingBloc extends Bloc<ExtraWorkingEvent, ExtraWorkingState> {
  int page = 0, size = 50;
  int totalRequestCount = 0, totalApprovedCount = 0;
  Map<String, dynamic> body = {};
  List<ExtraWorkingModel> extraWorkingModelList = [];
  bool filterdataLoad = true;

  ExtraWorkingBloc() : super(ExtraWorkingInitial()) {
    on<ExtraWokringLoadEvent>((event, emit) async {
      if (event.bottomLodaingView) {
        emit(LoadingState());
      }
      if (!CommonFunction.isNullOrIsEmpty(event.filterBody)) {
        body = event.filterBody!;
      }
      if (event.isReset) {
        page = 0;
        totalApprovedCount = 0;
        totalRequestCount = 0;
        extraWorkingModelList.clear();
      }

      String employeeId = await SharedpreferencesUtils.getEmployeeId();
      var data = await Api.extraWorkingListApi(
          event.context,
          event.showLoadingView,
          body,
          employeeId,
          Constants.typeOfList,
          page,
          size);
      if (!CommonFunction.isNullOrIsEmpty(data)) {
        var responseObj = data["responseObj"];
        totalRequestCount = data["count"];
        for (int i = 0; i < responseObj.length; i++) {
          responseObj[i]["workType"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["workType"])
                  ? ""
                  : responseObj[i]["workType"] == "OVER_TIME"
                      ? "Overtime"
                      : "Extra Working";
          responseObj[i]["startDate"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["startDate"])
                  ? ""
                  : CommonFunction.dateISOFormat(
                      responseObj[i]["startDate"], "dd-MM-yyyy");
          responseObj[i]["endDate"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["endDate"])
                  ? ""
                  : CommonFunction.dateFormat(
                      responseObj[i]["endDate"], "yyyy-MM-dd", "dd-MM-yyyy");
          responseObj[i]["inTime"] = CommonFunction.isNullOrIsEmpty(
                  responseObj[i]["inTime"])
              ? ""
              : CommonFunction.dateTime12To24Format(responseObj[i]["inTime"]);
          responseObj[i]["outTime"] = CommonFunction.isNullOrIsEmpty(
                  responseObj[i]["outTime"])
              ? ""
              : CommonFunction.dateTime12To24Format(responseObj[i]["outTime"]);
          responseObj[i]["totalWorked"] = CommonFunction.isNullOrIsEmpty(
                  responseObj[i]["totalWorked"])
              ? ""
              : CommonFunction.percentageToHours(responseObj[i]["totalWorked"]);
          responseObj[i]["totalWorkedDays"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["totalWorkedDays"])
                  ? ""
                  : CommonFunction.percentageToHours(
                      responseObj[i]["totalWorkedDays"]);
          responseObj[i]["extraWorkFinalStatusFinalOvertimeHours"] =
              CommonFunction.isNullOrIsEmpty(
                      responseObj[i]["extraWorkFinalStatusFinalOvertimeHours"])
                  ? ""
                  : CommonFunction.percentageToHours(
                      responseObj[i]["extraWorkFinalStatusFinalOvertimeHours"]);
          responseObj[i]["cancelReason"] =
              CommonFunction.isNullOrIsEmpty(responseObj[i]["cancelReason"])
                  ? ""
                  : responseObj[i]["cancelReason"];
          extraWorkingModelList.add(ExtraWorkingModel.fromJson(responseObj[i]));
          if (responseObj[i]["finalStatus"].toString().toUpperCase() ==
              "APPROVE") {
            totalApprovedCount += 1;
          }
        }
        emit(ExtraWokringLoadState(
            extraWorkingModelList, totalRequestCount, totalApprovedCount));
        page += 1;

        if (filterdataLoad) {
          List<DropdownMenuEntry> employeeDropdownMenuList =
              await CommonFunction.getChildEmployeeDropdownList();
          emit(FilterDataLoadState(employeeDropdownMenuList));
          filterdataLoad = false;
        }
      } else {
        emit(ExtraWokringLoadState(
            extraWorkingModelList, totalRequestCount, totalApprovedCount));
        emit(ErrorState(""));
      }
    });
    on<LoadInitialDataEvent>((event, emit) async {
      List<DropdownMenuEntry> employeeDropdownMenuList =
          await CommonFunction.getChildEmployeeDropdownList();
      Map<String, dynamic> userShiftData = {};
      String? employeeId;
      if (employeeDropdownMenuList.isEmpty) {
        employeeId = await SharedpreferencesUtils.getEmployeeId();
        userShiftData = await loadUserShiftData(
            DateFormat("yyyy-MM-dd")
                .format(DateFormat("dd-MM-yyyy").parse(event.date)),
            employeeId);
      }
      emit(LoadInitialDataState(
          userShiftData, employeeId, employeeDropdownMenuList));
    });
    on<ChangeValueEvent>((event, emit) async {
      Map<String, dynamic> userShiftData = await loadUserShiftData(
          DateFormat("yyyy-MM-dd")
              .format(DateFormat("dd-MM-yyyy").parse(event.date)),
          event.employeeId!);
      emit(ChangeValueState(userShiftData));
    });
    on<ResetEvent>((event, emit) {
      emit((ResetState()));
    });
    on<SubmitEvent>((event, emit) async {
      Map<String, dynamic> body = {};
      body["employeeId"] =
          event.employeeId ?? await SharedpreferencesUtils.getEmployeeId();
      body["companyId"] =
          (await SharedpreferencesUtils.getEmployeeDetailInfo())["companyId"];
      body["extraWorkDate"] =
          CommonFunction.dateFormat(event.date, "dd-MM-yyyy", "yyyy-MM-dd");
      body["timeWorkedFrom1"] =
          CommonFunction.dateFormat(event.workFromtime, "hh:mm a", "HH:mm");
      body["timeWorkedTo1"] =
          CommonFunction.dateFormat(event.workToTime, "hh:mm a", "HH:mm");
      body["extraWorkReason"] = event.reason;
      // body["finalStatus"]="";
      body["onNextDay"] = CommonFunction.nextDayFlag(
          event.workFromtime, event.workToTime, "hh:mm a");

      Color? employeeErrorStatus = event.employeeDropdownMenuList.isNotEmpty
          ? CommonFunction.isNullOrIsEmpty(event.employeeId)
              ? ColorCode.errorColor
              : null
          : null;
      Color? reasonErrorStatus = !CommonFunction.isNullOrIsEmpty(event.reason)
          ? null
          : ColorCode.errorColor;
      if (employeeErrorStatus != ColorCode.errorColor &&
          reasonErrorStatus != ColorCode.errorColor) {
        var data = await Api.extraWorkingRequestApi(event.context, true, body);
        if (!CommonFunction.isNullOrIsEmpty(data)) {
          if (data["code"] == 204) {
            CommonFunction.showToastMsg(data["message"]);
            emit(ValidateErrorState(employeeErrorStatus, reasonErrorStatus));
          } else {
            emit(SubmitState());
          }
        }
      } else {
        emit(ValidateErrorState(employeeErrorStatus, reasonErrorStatus));
      }
    });
  }
  loadUserShiftData(String date, String employeeId) async {
    Map<String, dynamic> userShiftData = {};
    var data = await Api.userShiftDataApi(null, false, date, employeeId);
    if (!CommonFunction.isNullOrIsEmpty(data)) {
      userShiftData["actualInTime"] =
          CommonFunction.isNullOrIsEmpty(data["actualInTime"])
              ? ""
              : CommonFunction.dateFormat(
                  data["actualInTime"], "yyyy-MM-dd hh:mm:ss", "hh:mm a");
      userShiftData["actualOutTime"] =
          CommonFunction.isNullOrIsEmpty(data["actualOutTime"])
              ? ""
              : CommonFunction.dateFormat(
                  data["actualOutTime"], "yyyy-MM-dd hh:mm:ss", "hh:mm a");
      userShiftData["hoursWorked"] =
          CommonFunction.isNullOrIsEmpty(data["hoursWorked"])
              ? ""
              : CommonFunction.convertMinutesToHours(data["hoursWorked"]);
      userShiftData["shiftTimeIn1"] = CommonFunction.isNullOrIsEmpty(
              data["shiftTimeIn1"])
          ? ""
          : CommonFunction.dateFormat(data["shiftTimeIn1"], "hh:mm", "hh:mm a");
      userShiftData["shiftTimeOut1"] =
          CommonFunction.isNullOrIsEmpty(data["shiftTimeOut1"])
              ? ""
              : CommonFunction.dateFormat(
                  data["shiftTimeOut1"], "hh:mm", "hh:mm a");
      userShiftData["shiftDuration1"] =
          CommonFunction.isNullOrIsEmpty(data["shiftDuration1"])
              ? ""
              : CommonFunction.dateFormat(
                  data["shiftDuration1"], "hh:mm:ss", "hh:mm");
    }
    return userShiftData;
  }
}
