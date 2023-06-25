// ignore_for_file: depend_on_referenced_packages
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../commonWidgets/common_widgets.dart';
import '../../../../../constants/ColorCode.dart';
import '../../../../../constants/attandence/attendance_constants.dart';
import '../../bloc/correction_bloc.dart';

showRequestDiloug(context, employeeDropDownList) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CorrectionRequest(employeeDropDownList);
      });
}

class CorrectionRequest extends StatelessWidget {
  CorrectionRequest(this.employeeDropDownList, {super.key});

  List<DropdownMenuEntry> employeeDropDownList;

  bool otherResaonVisible = false;
  Color? employeeErrorStatus,
      correctionDateErrorStatus,
      inTimeErrorStatus,
      outTimeErrorStatus,
      reasonErrorStatus,
      otherReasonErrorStatus;

  var reasonType;

  var companyId;
  var correctionInTime;
  var correctionOutTime;
  var employeeId;
  var empId;
  var inTime;
  var outTime;
  var actualInTime;
  var actualOutTime;
  var requestType;
  String? onNextDay = "false";
  Map<String, dynamic> punchingDataBody = {};

  DateTime? correctionDate = DateTime.now();

  var date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  TextEditingController eNameTextController = TextEditingController();

  //CORRECTION DAT TEXT CONTROLLER
  TextEditingController correctionDateController = TextEditingController();

  //CORRECTION REASON TYPE TEXT CONTROLLER
  TextEditingController reasonTypeController = TextEditingController();

  //OTHER REASON TEXT CONTROLLER
  TextEditingController otherReasonController = TextEditingController();

  //TIME TEXT CONTROLLER
  TextEditingController inTimeController = TextEditingController();
  TextEditingController outTimeController = TextEditingController();

  List<DropdownMenuEntry> requestTypeDropDownList = [
    const DropdownMenuEntry(
        value: "In Out Punch Correction", label: "In Out Punch Correction"),
    const DropdownMenuEntry(
        value: "In Punch Correction", label: "In Punch Correction"),
    const DropdownMenuEntry(
        value: "Out Punch Correction", label: "Out Punch Correction"),
    const DropdownMenuEntry(value: "Wrong Punching", label: "Wrong Punching"),
    const DropdownMenuEntry(value: "Other Reason", label: "Other Reason")
  ];

  dialogContent(BuildContext context) {
    inTime = CommonFunction.isNullOrIsEmpty(inTimeController.text)
        ? null
        : DateFormat('hh:mm a')
            .format(DateFormat('hh:mm a').parse(inTimeController.text));
    outTime = CommonFunction.isNullOrIsEmpty(outTimeController.text)
        ? null
        : DateFormat('hh:mm a')
            .format(DateFormat('hh:mm a').parse(outTimeController.text));

    CorrectionBloc correctionBloc = CorrectionBloc();

    return BlocProvider(
      create: (context) => correctionBloc,
      child: BlocConsumer<CorrectionBloc, CorrectionState>(
        listener: (context, state) {
          if (state is FetchPunchInOutTimeDataState) {
            inTimeController.text = state.inTime;
            outTimeController.text = state.outTime;
            punchingDataBody = state.inOutPunchBody;
          } else if (state is ShowOtherReasonFieldState) {
            otherResaonVisible = state.otherReasonVisible;
          } else if (state is ValidateFieldState) {
            employeeErrorStatus = state.employeeErrorStatus;
            correctionDateErrorStatus = state.correctionDateErrorStatus;
            inTimeErrorStatus = state.inTimeErrorStatus;
            outTimeErrorStatus = state.outTimeErrorStatus;
            reasonErrorStatus = state.reasonErrorStatus;
            otherReasonErrorStatus = state.otherReasonErrorStatus;
          } else if (state is SubmitCorrectionRequestState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AttendanceConstants.requestHeadingLable.tr),
                            Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.red.shade300),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 15,
                                    )))
                          ],
                        ),
                      ),
                      CommonWidgets.verticalSpace(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                              visible: employeeDropDownList.isNotEmpty,
                              child: Flexible(
                                  flex: 20,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: DropdownMenu(
                                      onSelected: (value) {
                                        empId = value;
                                      },
                                      controller: eNameTextController,
                                      width: MediaQuery.of(context).size.width -
                                          245,
                                      dropdownMenuEntries: employeeDropDownList,
                                      enableFilter: false,
                                      menuHeight: 240,
                                      label: Text("Active Employee",
                                          style: TextStyle(
                                              color: employeeErrorStatus ??
                                                  ColorCode.fieldBoxColor)),
                                      inputDecorationTheme: InputDecorationTheme(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: employeeErrorStatus ??
                                                      ColorCode
                                                          .fieldBoxFoucsColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: employeeErrorStatus ??
                                                      ColorCode
                                                          .fieldBoxColor))),
                                    ),
                                  ))),
                          CommonWidgets.horizontalSpace(5),
                          Flexible(
                              flex: 20,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: TextField(
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101));
                                    if (pickedDate != null) {
                                      correctionDateController.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
                                      correctionDate = pickedDate;
                                      date = DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                      correctionBloc.add(
                                          FetchPunchInOutTimeDataEvent(
                                              correctionDate));
                                    }
                                  },
                                  controller: correctionDateController,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.calendar_today,
                                        color: correctionDateErrorStatus ??
                                            ColorCode.fieldBoxFoucsColor,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  correctionDateErrorStatus ??
                                                      ColorCode
                                                          .fieldBoxFoucsColor)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color:
                                                  correctionDateErrorStatus ??
                                                      ColorCode
                                                          .fieldBoxFoucsColor)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  correctionDateErrorStatus ??
                                                      ColorCode.fieldBoxColor)),
                                      labelText: AttendanceConstants
                                          .correctionDateLable.tr,
                                      labelStyle: TextStyle(
                                          color: correctionDateErrorStatus ??
                                              ColorCode.fieldBoxFoucsColor)),
                                ),
                              )),
                        ],
                      ),
                      CommonWidgets.verticalSpace(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 20,
                              child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 13, 0),
                                  child: TextField(
                                    controller: inTimeController,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.watch_later_outlined,
                                          color: inTimeErrorStatus ??
                                              ColorCode.fieldBoxFoucsColor,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: inTimeErrorStatus ??
                                                    ColorCode
                                                        .fieldBoxFoucsColor)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: inTimeErrorStatus ??
                                                    ColorCode
                                                        .fieldBoxFoucsColor)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: inTimeErrorStatus ??
                                                    ColorCode.fieldBoxColor)),
                                        labelText: AttendanceConstants
                                            .correctionInTimeLable.tr,
                                        labelStyle: TextStyle(
                                            color: inTimeErrorStatus ??
                                                ColorCode.fieldBoxColor)),
                                    readOnly: true,
                                    onTap: () async {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                              builder: (context, childWidget) {
                                                return MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                      alwaysUse24HourFormat:
                                                          false,
                                                    ),
                                                    child: childWidget!);
                                              },
                                              context: context,
                                              initialTime: TimeOfDay.now());
                                      if (pickedTime != null) {
                                        final hour = pickedTime.hour
                                            .toString()
                                            .padLeft(2, "0");
                                        final min = pickedTime.minute
                                            .toString()
                                            .padLeft(2, "0");
                                        DateTime parsedTime =
                                            DateFormat.Hm().parse("$hour:$min");
                                        inTimeController.text =
                                            DateFormat('hh:mm a')
                                                .format(parsedTime);
                                        correctionInTime = DateFormat('hh:mm a')
                                            .format(parsedTime);
                                      }
                                    },
                                  ))),
                          CommonWidgets.horizontalSpace(10),
                          Flexible(
                              flex: 20,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: TextField(
                                  controller: outTimeController,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.watch_later_outlined,
                                        color: outTimeErrorStatus ??
                                            ColorCode.fieldBoxFoucsColor,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: outTimeErrorStatus ??
                                                  ColorCode
                                                      .fieldBoxFoucsColor)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: outTimeErrorStatus ??
                                                  ColorCode
                                                      .fieldBoxFoucsColor)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: outTimeErrorStatus ??
                                                  ColorCode.fieldBoxColor)),
                                      labelText: AttendanceConstants
                                          .correctionOutTimeLable.tr,
                                      labelStyle: TextStyle(
                                        color: outTimeErrorStatus ??
                                            ColorCode.fieldBoxColor,
                                      )),
                                  readOnly: true,
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                            builder: (context, childWidget) {
                                              return MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          alwaysUse24HourFormat:
                                                              false),
                                                  child: childWidget!);
                                            },
                                            context: context,
                                            initialTime: TimeOfDay.now());
                                    if (pickedTime != null) {
                                      final hour = pickedTime.hour
                                          .toString()
                                          .padLeft(2, "0");
                                      final min = pickedTime.minute
                                          .toString()
                                          .padLeft(2, "0");
                                      DateTime parsedTime =
                                          DateFormat.Hm().parse("$hour:$min");

                                      outTimeController.text =
                                          DateFormat('hh:mm a')
                                              .format(parsedTime);
                                      correctionOutTime = DateFormat("hh:mm A")
                                          .format(parsedTime);

                                      if (inTime != null && outTime != null) {
                                        var inttime = DateFormat("HH:mm").parse(
                                            DateFormat("HH:mm").format(
                                                DateFormat("hh:mm a")
                                                    .parse(inTime)));
                                        var outtime = DateFormat("HH:mm").parse(
                                            DateFormat("HH:mm").format(
                                                DateFormat("hh:mm a")
                                                    .parse(outTime)));
                                        int startTimeInt = (inttime.hour * 60 +
                                                inttime.minute) *
                                            60;
                                        int endTimeInt = (outtime.hour * 60 +
                                                outtime.minute) *
                                            60;
                                        if (endTimeInt < startTimeInt) {
                                          onNextDay == "true";
                                        } else {
                                          onNextDay == "false";
                                        }
                                      }
                                    }
                                  },
                                ),
                              )),
                        ],
                      ),
                      CommonWidgets.verticalSpace(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 20,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: DropdownMenu(
                                  onSelected: (value) {
                                    reasonType = value;
                                    correctionBloc.add(
                                        ShowOtherReasonFieldEvent(reasonType));
                                  },
                                  controller: reasonTypeController,
                                  label: Text(
                                      AttendanceConstants.requestTypeLable.tr,
                                      style: TextStyle(
                                          color: reasonErrorStatus ??
                                              ColorCode.fieldBoxColor)),
                                  inputDecorationTheme: InputDecorationTheme(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: reasonErrorStatus ??
                                                ColorCode.fieldBoxFoucsColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: reasonErrorStatus ??
                                                  ColorCode.fieldBoxColor))),
                                  width:
                                      MediaQuery.of(context).size.width - 245,
                                  dropdownMenuEntries: requestTypeDropDownList,
                                ),
                              )),
                          Flexible(
                              flex: 20,
                              child: Visibility(
                                  visible: otherResaonVisible,
                                  child: Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(5, 0, 8, 0),
                                      child: TextField(
                                          controller: otherReasonController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: otherReasonErrorStatus ??
                                                          ColorCode
                                                              .fieldBoxFoucsColor)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: otherReasonErrorStatus ??
                                                          ColorCode
                                                              .fieldBoxColor)),
                                              labelText: AttendanceConstants
                                                  .correctionReasonTypeLable.tr,
                                              labelStyle: TextStyle(
                                                color: otherReasonErrorStatus ??
                                                    ColorCode.fieldBoxColor,
                                              ))))))
                        ],
                      ),
                      CommonWidgets.verticalSpace(10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      eNameTextController.clear();
                                      correctionDateController.clear();
                                      inTimeController.clear();
                                      outTimeController.clear();
                                      reasonTypeController.clear();
                                      otherReasonController.clear();
                                    },
                                    child: Text(AttendanceConstants
                                        .resetButtonLable.tr))),
                            CommonWidgets.horizontalSpace(10),
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      correctionBloc.add(
                                          SubmitCorrectionRequestEvent(
                                              eNameTextController.text,
                                              correctionDateController.text,
                                              inTimeController.text,
                                              outTimeController.text,
                                              reasonTypeController.text,
                                              otherReasonController.text,
                                              date,
                                              otherResaonVisible == true
                                                  ? otherReasonController.text
                                                  : reasonTypeController.text,
                                              inTimeController.text,
                                              outTimeController.text,
                                              punchingDataBody));
                                    },
                                    child: Text(AttendanceConstants
                                        .submitButtonLable.tr)))
                          ])
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0.0,
      insetPadding: const EdgeInsets.only(left: 10, right: 10),
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }
}
