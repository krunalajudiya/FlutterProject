import 'dart:async';

import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../../commonWidgets/common_widgets.dart';
import '../../../../../constants/leave/leave_constants.dart';
import '../../bloc/extra_working_bloc.dart';

showExtraWorkingRequestDialogBox(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExtraWorkingRequestDialogBox();
      });
}

class ExtraWorkingRequestDialogBox extends StatelessWidget {
  TextEditingController employeeTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController(
      text: DateFormat("dd-MM-yyyy")
          .format(DateTime.now().subtract(const Duration(days: 1))));
  TextEditingController timeFromTextEditingController =
      TextEditingController(text: DateFormat("hh:mm a").format(DateTime.now()));
  TextEditingController timeToTextEditingController =
      TextEditingController(text: DateFormat("hh:mm a").format(DateTime.now()));
  TextEditingController otherReasonTextEditingController =
      TextEditingController();
  TextEditingController reasonTextEditingController = TextEditingController();
  List<DropdownMenuEntry> employeeDropdownMenuList = [];
  List<DropdownMenuEntry> reasonDropdownMenuList = [
    const DropdownMenuEntry(
        value: "WORKED ON OFFDAYS", label: "Worked On Offdays"),
    const DropdownMenuEntry(value: "OTHER REASON", label: "Other Reason")
  ];
  String? employeeId;
  bool otherReasonVisibilityFlag = false;
  var reasonText;
  Color? reasonErrorStatus, employeeErrorStatus;
  Map<String, dynamic> userShiftData = {};
  ExtraWorkingBloc extraWorkingBloc = ExtraWorkingBloc();
  StreamController<bool> otherReasonStreamController = StreamController();
  StreamController<bool> nextDayStreamController = StreamController();
  bool nextDayVisbilityFlag = false;

  ExtraWorkingRequestDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonWidgets.dialogBox(
        context: context,
        dialogLabel: LeaveConstants.extraWorkingLabel,
        dialogContent: dialogContent(context),
        submitOnTap: () {
          extraWorkingBloc.add(SubmitEvent(
              context,
              employeeId,
              timeFromTextEditingController.text,
              timeToTextEditingController.text,
              dateTextEditingController.text,
              otherReasonVisibilityFlag
                  ? otherReasonTextEditingController.text
                  : reasonText,
              otherReasonVisibilityFlag,
              employeeDropdownMenuList));
        },
        resetOnTap: () => extraWorkingBloc.add(ResetEvent()));
  }

  Widget dialogContent(context) {
    return BlocProvider(
      create: (context) => extraWorkingBloc
        ..add(LoadInitialDataEvent(dateTextEditingController.text)),
      child: BlocConsumer<ExtraWorkingBloc, ExtraWorkingState>(
        listener: (context, state) {
          if (state is LoadInitialDataState) {
            employeeDropdownMenuList = state.employeeDropdownMenuList;
            userShiftData = state.userShiftData;
            if (userShiftData.isNotEmpty) {
              timeFromTextEditingController.text =
                  CommonFunction.isNullOrIsEmpty(userShiftData["actualInTime"])
                      ? DateFormat("hh:mm a").format(DateTime.now())
                      : userShiftData["actualInTime"];
              timeToTextEditingController.text =
                  CommonFunction.isNullOrIsEmpty(userShiftData["actualOutTime"])
                      ? DateFormat("hh:mm a").format(DateTime.now())
                      : userShiftData["actualOutTime"];
            }
          } else if (state is ChangeValueState) {
            userShiftData = state.userShiftData;
            timeFromTextEditingController.text =
                CommonFunction.isNullOrIsEmpty(userShiftData["actualInTime"])
                    ? DateFormat("hh:mm a").format(DateTime.now())
                    : userShiftData["actualInTime"];
            timeToTextEditingController.text =
                CommonFunction.isNullOrIsEmpty(userShiftData["actualOutTime"])
                    ? DateFormat("hh:mm a").format(DateTime.now())
                    : userShiftData["actualOutTime"];
          } else if (state is ValidateErrorState) {
            reasonErrorStatus = state.reasonErrorStatus;
            employeeErrorStatus = state.employeeErrorStatus;
          } else if (state is SubmitState) {
            CommonFunction.backPage(context, null);
          } else if (state is ResetState) {
            employeeId = null;
            employeeTextEditingController.clear();
            timeFromTextEditingController.text =
                DateFormat("hh:mm a").format(DateTime.now());
            timeToTextEditingController.text =
                DateFormat("hh:mm a").format(DateTime.now());
            dateTextEditingController.text = DateFormat("dd-MM-yyyy")
                .format(DateTime.now().subtract(const Duration(days: 1)));
            reasonErrorStatus = null;
            employeeErrorStatus = null;
            reasonTextEditingController.clear();
            reasonTextEditingController.clear();
            reasonText = null;
            otherReasonVisibilityFlag = false;
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                  visible: userShiftData.isNotEmpty
                      ? CommonFunction.isNullOrIsEmpty(
                              userShiftData["shiftTimeIn1"])
                          ? false
                          : true
                      : false,
                  child: Text(
                      "Shift Time : ${userShiftData.isNotEmpty ? userShiftData["shiftTimeIn1"].toString() : ""} To ${userShiftData.isNotEmpty ? userShiftData["shiftTimeOut1"].toString() : ""} (${userShiftData["shiftDuration1"]} Hours)")),
              CommonWidgets.verticalSpace(2),
              Visibility(
                visible: userShiftData.isNotEmpty
                    ? CommonFunction.isNullOrIsEmpty(
                            userShiftData["actualInTime"].toString())
                        ? false
                        : true
                    : false,
                child: Text(
                    "Actual in - Out Time : ${userShiftData.isNotEmpty ? userShiftData["actualInTime"].toString() : ""} - ${userShiftData.isNotEmpty ? userShiftData["actualOutTime"].toString() : ""} (${userShiftData["hoursWorked"]} Hours)"),
              ),
              Visibility(
                visible: userShiftData.isNotEmpty
                    ? CommonFunction.isNullOrIsEmpty(
                            userShiftData["nonWorkingType"].toString())
                        ? false
                        : true
                    : false,
                child: const Text("Off Day"),
              ),
              CommonWidgets.verticalSpace(5),
              Visibility(
                visible: employeeDropdownMenuList.isNotEmpty,
                child: Column(
                  children: [
                    CommonWidgets.employeeDropDown(
                        context: context,
                        employeeDropdownMenuList: employeeDropdownMenuList,
                        employeeTextEditingController:
                            employeeTextEditingController,
                        employeeErrorStatus: employeeErrorStatus,
                        onSelect: (value) {
                          employeeId = value;
                          extraWorkingBloc.add(ChangeValueEvent(
                              dateTextEditingController.text, employeeId));
                        }),
                    CommonWidgets.verticalSpace(10),
                  ],
                ),
              ),
              StreamBuilder<bool>(
                  stream: nextDayStreamController.stream,
                  builder: (context, snapshot) {
                    return Visibility(
                        visible: snapshot.data ?? false,
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            alignment: Alignment.centerRight,
                            child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue.shade100,
                                ),
                                child: Text(LeaveConstants.nextDayLabel.tr))));
                  }),
              Row(
                children: [
                  Expanded(
                      child: CommonWidgets.timeTextBox(
                          timeFromTextEditingController,
                          LeaveConstants.extraWorkedFromLabel, () async {
                    var fromTime = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (fromTime != null) {
                      timeFromTextEditingController.text =
                          fromTime.format(context);
                    }
                  })),
                  CommonWidgets.horizontalSpace(5),
                  Expanded(
                      child: CommonWidgets.timeTextBox(
                          timeToTextEditingController,
                          LeaveConstants.extraWorkedToLabel, () async {
                    var toTime = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (toTime != null) {
                      timeToTextEditingController.text = toTime.format(context);
                      if (CommonFunction.nextDayFlag(
                          timeFromTextEditingController.text,
                          timeToTextEditingController.text,
                          "hh:mm a")) {
                        nextDayStreamController.add(true);
                      } else {
                        nextDayStreamController.add(false);
                      }
                    }
                  }))
                ],
              ),
              CommonWidgets.verticalSpace(10),
              Row(
                children: [
                  Expanded(
                    child: CommonWidgets.dateTextBox(
                        dateTextEditingController, false, () async {
                      var date = await CommonWidgets.rangeDatePickDialog(
                          context: context,
                          rangeOrSingle: false,
                          lastDate:
                              DateTime.now().subtract(const Duration(days: 1)),
                          currentDate:
                              DateTime.now().subtract(const Duration(days: 1)));
                      if (date != null) {
                        dateTextEditingController.text = date;
                        if (employeeId != null) {
                          extraWorkingBloc
                              .add(ChangeValueEvent(date, employeeId));
                        }
                      }
                    }),
                  ),
                  CommonWidgets.horizontalSpace(5),
                  Expanded(
                      child: DropdownMenu(
                    width: (MediaQuery.of(context).size.width / 2) - 25,
                    dropdownMenuEntries: reasonDropdownMenuList,
                    menuHeight: 200,
                    controller: reasonTextEditingController,
                    label: Text(
                      LeaveConstants.reasonLabel.tr,
                      style: CommonWidgets.dropdownMenuErrorTextStyle(
                          otherReasonVisibilityFlag ? null : reasonErrorStatus),
                    ),
                    inputDecorationTheme:
                        CommonWidgets.dropdownMenuErrorDecoration(
                            otherReasonVisibilityFlag
                                ? null
                                : reasonErrorStatus),
                    onSelected: (value) {
                      if (value == "OTHER REASON") {
                        otherReasonVisibilityFlag = true;
                        otherReasonStreamController.add(true);
                      } else {
                        otherReasonVisibilityFlag = false;
                        otherReasonStreamController.add(false);
                        reasonText = value;
                      }
                    },
                  ))
                ],
              ),
              StreamBuilder<bool>(
                  stream: otherReasonStreamController.stream,
                  builder: (context, snapshot) {
                    return Visibility(
                      visible: otherReasonVisibilityFlag,
                      child: Column(
                        children: [
                          CommonWidgets.verticalSpace(5),
                          TextField(
                              controller: otherReasonTextEditingController,
                              decoration:
                                  CommonWidgets.textFieldErrorDecoration(
                                      otherReasonVisibilityFlag
                                          ? reasonErrorStatus
                                          : null,
                                      LeaveConstants.otherReasonLabel)),
                        ],
                      ),
                    );
                  }),
            ],
          );
        },
      ),
    );
  }
}
