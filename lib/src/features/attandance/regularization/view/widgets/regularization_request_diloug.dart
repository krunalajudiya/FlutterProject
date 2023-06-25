import 'package:emgage_flutter/src/commonWidgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../constants/ColorCode.dart';
import '../../../../../constants/attandence/attendance_constants.dart';
import '../../bloc/regularization_bloc.dart';

showRequestDiloug(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return RegularizationRequest();
      });
}

class RegularizationRequest extends StatelessWidget {
  String dateLableText = "From Date";
  bool toDateVisible = true;
  bool inTimeVisible = true;
  bool outTimeVisible = true;
  bool otherReasonVisible = false;
  bool employeeFieldVisible = true;
  var requestTypeId;
  var requestType;
  var reasonType;

  Color? employeeErrorStatus,
      requestTypeErrorState,
      fromDateErrorState,
      toDateErrorState,
      inTimeErrorStatus,
      outTimeErrorStatus,
      reasonErrorStatus,
      otherReasonErrorStatus;

  //EMPLOYEE NAME TEXT CONTROLLER
  TextEditingController eNameTextController = TextEditingController();

  //REGULARIZATION REQUEST TYPE TEXT CONTROLLER
  TextEditingController requestTypeController = TextEditingController();

  //FROM DATE REQUEST TYPE TEXT CONTROLLER
  TextEditingController fromDateTextController = TextEditingController();

  //TO DATE REQUEST TYPE TEXT CONTROLLER
  TextEditingController toDateTextController = TextEditingController();

  //IN TIME REQUEST TYPE TEXT CONTROLLER
  TextEditingController inTimeTextController = TextEditingController();

  //OUT TIME REQUEST TYPE TEXT CONTROLLER
  TextEditingController outTimeTextController = TextEditingController();

  //REASON TYPE TEXT CONTROLLER
  TextEditingController reasonTypeTextController = TextEditingController();

  ////OTHER REASON TEXT CONTROLLER
  TextEditingController otherReasonTextController = TextEditingController();

  List<DropdownMenuEntry> requestReasonDropDownList = [
    const DropdownMenuEntry(value: "At client Site", label: "At client Site"),
    const DropdownMenuEntry(value: "Early going", label: "Early going"),
    const DropdownMenuEntry(
        value: "For personal reason", label: "For personal reason"),
    const DropdownMenuEntry(value: "Late coming", label: "Late coming"),
    const DropdownMenuEntry(
        value: "Out for official work", label: "Out for official work"),
    const DropdownMenuEntry(value: "Other Reason", label: "Other Reason"),
  ];

  List<DropdownMenuEntry> employeeDropDownList = [];
  List<DropdownMenuEntry> regularizationCodeDropDownList = [];

  RegularizationBloc regularizationBloc = RegularizationBloc();

  RegularizationRequest({super.key});

  dialogContent(BuildContext context) {
    return BlocProvider(
      create: (context) => regularizationBloc..add(LoadRequestContentEvent()),
      child: BlocConsumer<RegularizationBloc, RegularizationState>(
        listener: (context, state) {
          if (state is LoadRequestContentState) {
            employeeDropDownList = state.employeeDropDownList;
            regularizationCodeDropDownList =
                state.regularizationCodeDropDownList;
          } else if (state is ShowRequestContentState) {
            dateLableText = state.dateText;
            inTimeVisible = state.inTimeVisible;
            outTimeVisible = state.outTimeVisible;
            toDateVisible = state.toDateVisible;
          } else if (state is ShowOtherReasonFieldState) {
            otherReasonVisible = state.otherReasonVisible;
          } else if (state is ValidateFieldsState) {
            employeeErrorStatus = state.employeeErrorStatus;
            requestTypeErrorState = state.requestTypeErrorState;
            fromDateErrorState = state.fromDateErrorState;
            toDateErrorState = state.toDateErrorState;
            inTimeErrorStatus = state.inTimeErrorStatus;
            outTimeErrorStatus = state.outTimeErrorStatus;
            reasonErrorStatus = state.reasonErrorStatus;
            otherReasonErrorStatus = state.otherReasonErrorStatus;
          } else if (state is SubmitRegularizationRequestState) {
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
                          Text(AttendanceConstants
                              .regularizationRequestHeadingLable.tr),
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
                      )),
                      CommonWidgets.verticalSpace(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                              visible: employeeDropDownList.isNotEmpty
                                  ? employeeFieldVisible = true
                                  : employeeFieldVisible = false,
                              child: Flexible(
                                  flex: 6,
                                  child: SizedBox(
                                      child: DropdownMenu(
                                    controller: eNameTextController,
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        30,
                                    dropdownMenuEntries: employeeDropDownList,
                                    label: Text(
                                        AttendanceConstants.employeeLable.tr,
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
                                                    ColorCode.fieldBoxColor))),
                                    enableFilter: true,
                                    menuHeight: 240,
                                  )))),
                          Visibility(
                              visible: employeeDropDownList.isNotEmpty
                                  ? employeeFieldVisible = true
                                  : employeeFieldVisible = false,
                              child: CommonWidgets.horizontalSpace(5)),
                          Flexible(
                              flex: 6,
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: DropdownMenu(
                                    controller: requestTypeController,
                                    width: employeeFieldVisible == true
                                        ? (MediaQuery.of(context).size.width /
                                                2) -
                                            30
                                        : (MediaQuery.of(context).size.width -
                                            45),
                                    label: Text(
                                        AttendanceConstants
                                            .regularizationRequestTypeLable.tr,
                                        style: TextStyle(
                                            color: requestTypeErrorState ??
                                                ColorCode.fieldBoxColor)),
                                    inputDecorationTheme: InputDecorationTheme(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: requestTypeErrorState ??
                                                    ColorCode
                                                        .fieldBoxFoucsColor)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: requestTypeErrorState ??
                                                    ColorCode.fieldBoxColor))),
                                    enableFilter: true,
                                    enableSearch: true,
                                    menuHeight: 240,
                                    dropdownMenuEntries:
                                        regularizationCodeDropDownList,
                                    onSelected: (value) {
                                      requestTypeId = value['id'];
                                      requestType = value['regType'];
                                      regularizationBloc.add(
                                          ShowRequestContentEvent(requestType));
                                    },
                                  )))
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
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: TextField(
                                        controller: fromDateTextController,
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2101));
                                          if (pickedDate != null) {
                                            String formattedDate =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(pickedDate);

                                            fromDateTextController.text =
                                                formattedDate;
                                          } else {}
                                        },
                                        decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              Icons.calendar_today,
                                              color: fromDateErrorState ??
                                                  ColorCode.fieldBoxColor,
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                    color: fromDateErrorState ??
                                                        ColorCode
                                                            .fieldBoxFoucsColor)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: fromDateErrorState ??
                                                        ColorCode
                                                            .fieldBoxColor)),
                                            labelText: dateLableText.tr,
                                            labelStyle: TextStyle(
                                                color: fromDateErrorState ??
                                                    ColorCode
                                                        .fieldBoxColor))))),
                            Flexible(
                                flex: 20,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Visibility(
                                      child: TextField(
                                    enabled: toDateVisible,
                                    controller: toDateTextController,
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101));

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(pickedDate);

                                        toDateTextController.text =
                                            formattedDate;
                                      } else {}
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.calendar_today,
                                          color: toDateErrorState ??
                                              ColorCode.fieldBoxColor,
                                        ),
                                        labelText:
                                            AttendanceConstants.toDateLable.tr,
                                        labelStyle: TextStyle(
                                            color: toDateErrorState ??
                                                ColorCode.fieldBoxColor),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: toDateErrorState ??
                                                    ColorCode.fieldBoxColor)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: toDateErrorState ??
                                                    ColorCode.fieldBoxColor))),
                                  )),
                                )),
                          ]),
                      CommonWidgets.verticalSpace(10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 20,
                                child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    // width: 100,
                                    child: TextField(
                                      controller: inTimeTextController,
                                      enabled: inTimeVisible,
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(
                                            Icons.access_time,
                                            color: inTimeErrorStatus ??
                                                ColorCode.fieldBoxColor,
                                          ),
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
                                              .regularizationInTimeLable.tr,
                                          labelStyle: TextStyle(
                                              color: inTimeErrorStatus ??
                                                  ColorCode.fieldBoxColor)),
                                      readOnly: true,
                                      onTap: () async {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                                builder:
                                                    (context, childWidget) {
                                                  return MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
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
                                          DateTime parsedTime = DateFormat.Hm()
                                              .parse("$hour:$min");

                                          String formattedTime =
                                              DateFormat('hh:mm a')
                                                  .format(parsedTime);

                                          inTimeTextController.text =
                                              formattedTime;
                                        } else {}
                                      },
                                    ))),
                            Flexible(
                                flex: 20,
                                child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    // width: 100,
                                    child: TextField(
                                        enabled: outTimeVisible,
                                        controller: outTimeTextController,
                                        decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              Icons.access_time,
                                              color: outTimeErrorStatus ??
                                                  ColorCode.fieldBoxColor,
                                            ),
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
                                                        ColorCode
                                                            .fieldBoxColor)),
                                            labelText: AttendanceConstants
                                                .outTimeLable.tr,
                                            labelStyle: TextStyle(
                                                color: outTimeErrorStatus ??
                                                    ColorCode.fieldBoxColor)),
                                        readOnly: true,
                                        onTap: () async {
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                                  builder:
                                                      (context, childWidget) {
                                                    return MediaQuery(
                                                        data: MediaQuery.of(
                                                                context)
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
                                                DateFormat.Hm()
                                                    .parse("$hour:$min");

                                            String formattedTime =
                                                DateFormat('hh:mm a')
                                                    .format(parsedTime);

                                            outTimeTextController.text =
                                                formattedTime;
                                            // });
                                          } else {}
                                        })))
                          ]),
                      CommonWidgets.verticalSpace(10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 2,
                                child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: DropdownMenu(
                                      dropdownMenuEntries:
                                          requestReasonDropDownList,
                                      width: MediaQuery.of(context).size.width -
                                          245,
                                      enableFilter: false,
                                      onSelected: (value) {
                                        // otherResaonEnabled =
                                        // value == "Other Reason" ? true : false;
                                        reasonType = value;
                                        regularizationBloc.add(
                                            ShowOtherReasonFieldEvent(
                                                reasonType));
                                        //
                                        // setState(() {});
                                      },
                                      controller: reasonTypeTextController,
                                      label: Text(
                                        AttendanceConstants
                                            .regularizationReasonLable.tr,
                                        style: TextStyle(
                                            color: reasonErrorStatus ??
                                                ColorCode.fieldBoxColor),
                                      ),
                                      inputDecorationTheme: InputDecorationTheme(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: reasonErrorStatus ??
                                                      ColorCode
                                                          .fieldBoxFoucsColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: reasonErrorStatus ??
                                                      ColorCode
                                                          .fieldBoxColor))),
                                    ))),
                            CommonWidgets.horizontalSpace(5),
                            Flexible(
                                flex: 2,
                                child: Visibility(
                                    visible: otherReasonVisible,
                                    child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: TextField(
                                          controller: otherReasonTextController,
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
                                                  .otherReasonLable.tr,
                                              labelStyle: TextStyle(
                                                  color:
                                                      otherReasonErrorStatus ??
                                                          ColorCode
                                                              .fieldBoxColor)),
                                        )))),
                          ]),
                      CommonWidgets.verticalSpace(10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      eNameTextController.clear();
                                      requestTypeController.clear();
                                      fromDateTextController.clear();
                                      toDateTextController.clear();
                                      inTimeTextController.clear();
                                      outTimeTextController.clear();
                                      reasonTypeTextController.clear();
                                      otherReasonTextController.clear();
                                    },
                                    child: Text(AttendanceConstants
                                        .resetButtonLable.tr))),
                            CommonWidgets.horizontalSpace(10),
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      regularizationBloc.add(
                                          SubmitRegularizationRequestEvent(
                                              employeeFieldVisible,
                                              eNameTextController.text,
                                              requestTypeController.text,
                                              fromDateTextController.text,
                                              toDateTextController.text,
                                              inTimeTextController.text,
                                              outTimeTextController.text,
                                              reasonTypeTextController.text,
                                              otherReasonTextController.text,
                                              fromDateTextController.text,
                                              toDateTextController.text,
                                              inTimeTextController.text,
                                              outTimeTextController.text,
                                              requestType,
                                              requestTypeId,
                                              reasonType));
                                    },
                                    child: Text(AttendanceConstants
                                        .submitButtonLable.tr)))
                          ])
                    ],
                  )))
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
