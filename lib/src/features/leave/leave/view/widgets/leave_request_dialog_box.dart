import 'dart:async';
import 'package:emgage_flutter/src/constants/leave/leave_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../commonWidgets/common_widgets.dart';
import '../../../../../constants/ColorCode.dart';
import '../../../../../utils/common_functions.dart';
import '../../bloc/leave_bloc.dart';
import '../../model/extra_working_model.dart';
import '../../model/leave_code_user_model.dart';

showLeaveRequestDialogBox(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return LeaveRequestDialogBox();
      });
}

class LeaveRequestDialogBox extends StatelessWidget {
  TextEditingController employeeTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));
  List<DropdownMenuEntry> leaveCodeDropdownMenuList = [];
  bool otherReasonVisibilityFlag = false;
  int leaveDurationSelectType = 0;
  List<String> leaveDurationTypeList = [
    "Full".tr,
    "First Half".tr,
    "Second Half".tr
  ];
  String? employeeId;
  int leaveReasonSelecteType = 0;
  List<String> leaveReasonTypeList = [
    "For anniversary".tr,
    "For marriage".tr,
    "Other reason".tr,
    "For medical emergency".tr,
    "For personal reason".tr
  ];
  TextEditingController otherReasonTextEditingController =
      TextEditingController();
  TextEditingController leaveCodeTextEditingController =
      TextEditingController();
  List<DropdownMenuEntry> maternityTypeDropdownMenuList = [
    const DropdownMenuEntry(value: "DELIVERY", label: "Delivery"),
    const DropdownMenuEntry(value: "ADOPTION", label: "Adoption"),
    const DropdownMenuEntry(value: "MISCARRIAGE", label: "Miscarriage")
  ];
  String? maternityTypeDropdownSelectText;

  String? fileBase64, fileName;
  List<DropdownMenuEntry> extraWorkingDropdownMenuList = [];
  List<DropdownMenuEntry> employeeDropdownMenuList = [];

  final leaveBloc = LeaveBloc();
  Map<String, String> userLeaveDaysData = {};
  StreamController<bool> leaveReasonSelectStreamController = StreamController();
  List<ExtraWorkingModel> extraWorkingModelList = [];
  List<LeaveCodeUserModel> leaveCodeUserModelList = [];
  bool fileUploadShowFlag = false;
  bool fileUploadMandatoryFlag = false;
  bool extraWorkingDropdownShowFlag = false;
  bool maternityTypeDropdownShowFlag = false;
  LeaveCodeUserModel? leaveCodeUserModel;
  ExtraWorkingModel? extraWorkingModel;
  TextEditingController paternityMaternityTextEditingController =
      TextEditingController();
  TextEditingController extraWorkingTextEditingController =
      TextEditingController();

  var reasonText;
  Color? employeeErrorStatus,
      leaveCodeErrorStatus,
      paternityMaternityErrorStatus,
      extraWorkingErrorStatus,
      fileUploadErrorStatus;

  LeaveRequestDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonWidgets.dialogBox(
        context: context,
        dialogLabel: LeaveConstants.leaveRequestLabel,
        dialogContent: dialogContent(context),
        submitOnTap: () {
          leaveBloc.add(SubmitEvent(
              context,
              leaveReasonSelecteType,
              leaveReasonTypeList,
              employeeDropdownMenuList,
              employeeId,
              leaveCodeUserModel,
              leaveCodeTextEditingController.text,
              maternityTypeDropdownShowFlag,
              maternityTypeDropdownSelectText,
              paternityMaternityTextEditingController.text,
              extraWorkingDropdownShowFlag,
              extraWorkingModel,
              extraWorkingTextEditingController.text,
              otherReasonVisibilityFlag,
              otherReasonTextEditingController.text,
              fileUploadShowFlag,
              fileUploadMandatoryFlag,
              fileBase64,
              fileName,
              leaveDurationSelectType,
              userLeaveDaysData,
              dateTextEditingController.text));
        },
        resetOnTap: () {
          leaveBloc.add(ResetValueEvent(employeeDropdownMenuList,
              employeeId ?? "", dateTextEditingController.text));
        });
  }

  Widget dialogContent(context) {
    return BlocProvider(
      create: (context) => leaveBloc
        ..add(LoadInitialDataEvent(context, dateTextEditingController.text)),
      child: BlocConsumer<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state is LoadInitialDataState) {
            employeeId = state.employeeId;
            leaveCodeDropdownMenuList = state.leaveCodeDropdownMenuList;
            extraWorkingDropdownMenuList = state.extraWorkingDropdownMenuList;
            userLeaveDaysData = state.userLeaveDaysData;
            leaveCodeUserModelList = state.leaveCodeUserModelList;
            extraWorkingModelList = state.extraWorkingModelList;
          } else if (state is EmployeeListState) {
            employeeDropdownMenuList = state.employeeDropdownMenuList;
          } else if (state is HalfDayLeaveCalculationState) {
            userLeaveDaysData = state.userLeaveDaysData;
          } else if (state is LeaveCodeSelectState) {
            fileUploadShowFlag = state.fileUploadShowFlag;
            fileUploadMandatoryFlag = state.fileUploadMandatoryFlag;
            extraWorkingDropdownShowFlag = state.extraWorkingDropdownShowFlag;
            maternityTypeDropdownShowFlag = state.maternityTypeDropdownShowFlag;
          } else if (state is SelectDateState) {
            fileUploadShowFlag = state.fileUploadShowFlag;
            fileUploadMandatoryFlag = state.fileUploadMandatoryFlag;
            userLeaveDaysData = state.userLeaveDaysData;
          } else if (state is FileUploadState) {
            fileName = state.fileName;
            fileBase64 = state.fileBase64;
          } else if (state is ValidateErrorState) {
            reasonText = state.reasonText;
            employeeErrorStatus = state.employeeErrorStatus;
            leaveCodeErrorStatus = state.leaveCodeErrorStatus;
            paternityMaternityErrorStatus = state.paternityMaternityErrorStatus;
            extraWorkingErrorStatus = state.extraWorkingErrorStatus;
            fileUploadErrorStatus = state.fileUploadErrorStatus;
          } else if (state is SubmitState) {
            CommonFunction.backPage(context, true);
          } else if (state is ResetValueState) {
            userLeaveDaysData = state.userLeaveDaysData;
            if (employeeDropdownMenuList.isNotEmpty) employeeId = null;
            dateTextEditingController.text =
                DateFormat("dd-MM-yyyy").format(DateTime.now());
            employeeTextEditingController.clear();
            leaveCodeTextEditingController.clear();
            otherReasonTextEditingController.clear();
            extraWorkingTextEditingController.clear();
            paternityMaternityTextEditingController.clear();
            fileUploadShowFlag = false;
            fileUploadMandatoryFlag = false;
            extraWorkingDropdownShowFlag = false;
            maternityTypeDropdownShowFlag = false;
            leaveCodeUserModel = null;
            extraWorkingModel = null;
            leaveDurationSelectType = 0;
            leaveReasonSelecteType = 0;
            otherReasonVisibilityFlag = false;
            fileBase64 = null;
            fileName = null;
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: employeeDropdownMenuList.isNotEmpty,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 5),
                  child: DropdownMenu(
                    width: MediaQuery.of(context).size.width - 40,
                    dropdownMenuEntries: employeeDropdownMenuList,
                    controller: employeeTextEditingController,
                    menuHeight: 100,
                    enableFilter: true,
                    label: Text(
                      LeaveConstants.employeeLabel.tr,
                      style: TextStyle(
                          color:
                              employeeErrorStatus ?? ColorCode.fieldBoxColor),
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: employeeErrorStatus ??
                                  ColorCode.fieldBoxFoucsColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: employeeErrorStatus ??
                                  ColorCode.fieldBoxColor),
                        )),
                    onSelected: (value) async {
                      employeeId = value;
                      leaveBloc.add(SelectEmployeeIdEvent(
                          value, dateTextEditingController.text));
                    },
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(right: 2),
                      child: TextField(
                        minLines: 2,
                        maxLines: 2,
                        controller: dateTextEditingController,
                        readOnly: true,
                        onTap: () async {
                          var date = await CommonWidgets.rangeDatePickDialog(
                              context: context);
                          if (date != null) {
                            dateTextEditingController.text = date;
                            if (employeeId != null) {
                              leaveBloc.add(SelectDateEvent(
                                  leaveCodeUserModel, date, employeeId!));
                            }
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 6),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4)),
                            prefixIcon:
                                const Icon(Icons.calendar_today_rounded),
                            labelText: LeaveConstants.dateLabel.tr),
                      ),
                    ),
                  ),
                  CommonWidgets.horizontalSpace(5),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownMenu(
                          width: (MediaQuery.of(context).size.width / 2) - 30,
                          dropdownMenuEntries: leaveCodeDropdownMenuList,
                          menuHeight: 100,
                          enableFilter: true,
                          label: Text(
                            LeaveConstants.leaveCodeLabel.tr,
                            style: CommonWidgets.dropdownMenuErrorTextStyle(
                                leaveCodeErrorStatus),
                          ),
                          controller: leaveCodeTextEditingController,
                          inputDecorationTheme:
                              CommonWidgets.dropdownMenuErrorDecoration(
                                  leaveCodeErrorStatus),
                          onSelected: (value) {
                            leaveCodeUserModel = leaveCodeUserModelList[value];
                            leaveBloc.add(LeaveCodeSelectEvent(
                                leaveCodeUserModelList[value],
                                userLeaveDaysData));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: maternityTypeDropdownShowFlag,
                child: DropdownMenu(
                  width: MediaQuery.of(context).size.width - 50,
                  dropdownMenuEntries: maternityTypeDropdownMenuList,
                  menuHeight: 100,
                  controller: paternityMaternityTextEditingController,
                  enableFilter: true,
                  inputDecorationTheme:
                      CommonWidgets.dropdownMenuErrorDecoration(
                          paternityMaternityErrorStatus),
                  onSelected: (value) {
                    maternityTypeDropdownSelectText = value;
                  },
                  label: Text(
                    CommonFunction.isNullOrIsEmpty(leaveCodeUserModel)
                        ? ""
                        : leaveCodeUserModel!.leaveSubType == "PATERNITY"
                            ? "Paternity Type"
                            : leaveCodeUserModel!.leaveSubType == "MATERNITY"
                                ? "Maternity Type"
                                : "",
                    style: CommonWidgets.dropdownMenuErrorTextStyle(
                        paternityMaternityErrorStatus),
                  ),
                ),
              ),
              Visibility(
                visible: extraWorkingDropdownShowFlag,
                child: DropdownMenu(
                  width: MediaQuery.of(context).size.width - 50,
                  dropdownMenuEntries: extraWorkingDropdownMenuList,
                  menuHeight: 100,
                  controller: extraWorkingTextEditingController,
                  enableFilter: true,
                  label: Text(
                    LeaveConstants.extraWorkingDateLabel.tr,
                    style: CommonWidgets.dropdownMenuErrorTextStyle(
                        extraWorkingErrorStatus),
                  ),
                  inputDecorationTheme:
                      CommonWidgets.dropdownMenuErrorDecoration(
                          extraWorkingErrorStatus),
                  onSelected: (value) {
                    extraWorkingModel = extraWorkingModelList[value];
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            // color:Colors.blue.shade50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(LeaveConstants.workingLabel.tr),
                                Text(userLeaveDaysData["workingDays"] ?? "0")
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(LeaveConstants.weekOffLabel.tr),
                                Text(userLeaveDaysData["weekoffDays"] ?? "0")
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(LeaveConstants.holidayLabel.tr),
                                Text(userLeaveDaysData["holiday"] ?? "0")
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(LeaveConstants.totalDayLabel.tr),
                                Text(userLeaveDaysData["totalDays"] ?? "0")
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(LeaveConstants.actualLeaveLabel.tr),
                                Text(userLeaveDaysData["actualDays"] ?? "0")
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: leaveDurationTypeChoiceChip(leaveDurationTypeList),
              ),
              CommonWidgets.horizontalSpace(10),
              StreamBuilder<bool>(
                  stream: leaveReasonSelectStreamController.stream,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ChoiceChip(
                                elevation: 2,
                                label: Text(leaveReasonTypeList[0]),
                                selected: leaveReasonSelecteType == 0,
                                labelPadding: const EdgeInsets.all(0),
                                onSelected: (value) {
                                  leaveReasonSelecteType = 0;
                                  leaveReasonSelectStreamController.add(false);
                                  otherReasonVisibilityFlag = false;
                                },
                              ),
                              ChoiceChip(
                                  elevation: 2,
                                  label: Text(leaveReasonTypeList[1]),
                                  selected: leaveReasonSelecteType == 1,
                                  labelPadding: const EdgeInsets.all(0),
                                  onSelected: (value) {
                                    leaveReasonSelecteType = 1;
                                    leaveReasonSelectStreamController
                                        .add(false);
                                    otherReasonVisibilityFlag = false;
                                  }),
                              ChoiceChip(
                                  elevation: 2,
                                  label: Text(leaveReasonTypeList[2]),
                                  selected: leaveReasonSelecteType == 2,
                                  labelPadding: const EdgeInsets.all(0),
                                  onSelected: (value) {
                                    leaveReasonSelecteType = 2;
                                    leaveReasonSelectStreamController.add(true);
                                    otherReasonVisibilityFlag = true;
                                  })
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ChoiceChip(
                                  elevation: 2,
                                  label: Text(leaveReasonTypeList[3]),
                                  selected: leaveReasonSelecteType == 3,
                                  labelPadding: const EdgeInsets.all(0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onSelected: (value) {
                                    leaveReasonSelecteType = 3;
                                    leaveReasonSelectStreamController
                                        .add(false);
                                    otherReasonVisibilityFlag = false;
                                  }),
                              ChoiceChip(
                                  elevation: 2,
                                  label: Text(leaveReasonTypeList[4]),
                                  selected: leaveReasonSelecteType == 4,
                                  labelPadding: const EdgeInsets.all(0),
                                  onSelected: (value) {
                                    leaveReasonSelecteType = 4;
                                    leaveReasonSelectStreamController
                                        .add(false);
                                    otherReasonVisibilityFlag = false;
                                  }),
                            ]),
                        Visibility(
                          visible: otherReasonVisibilityFlag,
                          child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: otherReasonTextEditingController,
                              onChanged: (value) {},
                              decoration:
                                  CommonWidgets.textFieldErrorDecoration(
                                      reasonText.runtimeType == String
                                          ? null
                                          : reasonText,
                                      LeaveConstants.otherReasonLabel),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              CommonWidgets.horizontalSpace(10),
              Visibility(
                visible: fileUploadShowFlag,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (() {
                        leaveBloc.add(FileUploadEvent());
                      }),
                      child: Icon(
                          size: 50,
                          color: fileUploadErrorStatus ??
                              ColorCode.fieldBoxFoucsColor,
                          Icons.cloud_upload_outlined),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> leaveDurationTypeChoiceChip(leaveDurationTypeList) {
    List<Widget> choiceChip = [];
    for (int i = 0; i < leaveDurationTypeList.length; i++) {
      choiceChip.add(Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ChoiceChip(
          elevation: 2,
          label: Text(leaveDurationTypeList[i]),
          selected: dateTextEditingController.text.split("\n").length != 1
              ? 0 == i
              : leaveDurationSelectType == i,
          onSelected: (bool value) async {
            if (dateTextEditingController.text.split("\n").length == 1 &&
                CommonFunction.isNullOrIsEmpty(employeeId)) {
              leaveDurationSelectType = i;
              leaveBloc.add(HalfDayLeaveCalculationEvent(
                  dateTextEditingController.text,
                  leaveDurationSelectType,
                  employeeId!));
            }
          },
        ),
      ));
    }
    return choiceChip;
  }
}
