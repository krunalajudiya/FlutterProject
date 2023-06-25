// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../../../../../commonWidgets/common_widgets.dart';
import '../../../../../constants/attandence/correction_constants.dart';
import '../../../../../utils/common_functions.dart';

showFilterDiloug(
    context, employeeDropDownList, setCorrectionFilterValue) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CorrectionFilter(employeeDropDownList, setCorrectionFilterValue);
      });
}

class CorrectionFilter extends StatelessWidget {
  CorrectionFilter(this.employeeDropDownList, this.setCorrectionFilterValue,
      {super.key});

  List<DropdownMenuEntry> employeeDropDownList;
  var setCorrectionFilterValue;
  var filterdData;

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController employeeNameTextController = TextEditingController();
  TextEditingController statusTextEditingController = TextEditingController();
  TextEditingController reasonTextEditingController = TextEditingController();

  StreamController<String> fromDateStreamController = StreamController();
  StreamController<String> toDateStreamController = StreamController();

  List<DropdownMenuEntry> reasonDropDownList = [
    const DropdownMenuEntry(value: 0, label: "In Out Punch Correction"),
    const DropdownMenuEntry(value: 1, label: "In Punch Correction"),
    const DropdownMenuEntry(value: 2, label: "Out Punch Correction")
  ];

  List<DropdownMenuEntry> statusDropDownList = [
    const DropdownMenuEntry(value: 0, label: "Approve"),
    const DropdownMenuEntry(value: 1, label: "Pending"),
    const DropdownMenuEntry(value: 2, label: "Reject"),
    const DropdownMenuEntry(value: 3, label: "Cancelled"),
  ];

  String? reasonTypeText;
  String? statusText;
  String? employeeText;
  String? fromDateText;
  String? toDateText;

  dialogContent(BuildContext context) {
    correctionFilterRetriveData();
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
                      Text(
                        CorrectionConstants.filterHeadingLable,
                        textAlign: TextAlign.left,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))
                    ],
                  )),
                  CommonWidgets.verticalSpace(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 20,
                          child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: StreamBuilder<String>(
                                  stream: fromDateStreamController.stream,
                                  builder: (context, snapshot) {
                                    return TextField(
                                      controller: fromDateController,
                                      decoration: InputDecoration(
                                          suffixIcon:
                                              const Icon(Icons.calendar_today),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelText: "From Date"),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          fromDateController.text =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(pickedDate);
                                          fromDateStreamController.add("");
                                        }
                                      },
                                    );
                                  }))),
                      CommonWidgets.horizontalSpace(10),
                      Expanded(
                          flex: 20,
                          child: SizedBox(
                            width: 100,
                            child: StreamBuilder<String>(
                              stream: toDateStreamController.stream,
                              builder: (context, snapshot) {
                                return TextField(
                                  controller: toDateController,
                                  decoration: InputDecoration(
                                      suffixIcon:
                                          const Icon(Icons.calendar_today),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText: "To date"),
                                  readOnly: true,
                                  onTap: () async {
                                    var pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (pickedDate != null) {
                                      toDateController.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
                                    }
                                  },
                                );
                              },
                            ),
                          )),
                    ],
                  ),
                  CommonWidgets.verticalSpace(15),
                  DropdownMenu(
                    controller: reasonTextEditingController,
                    width: MediaQuery.of(context).size.width - 50,
                    dropdownMenuEntries: reasonDropDownList,
                    label: const Text("Request Type"),
                    onSelected: (value) {
                      reasonTypeText = reasonDropDownList[value].label;
                    },
                  ),
                  CommonWidgets.verticalSpace(15),
                  DropdownMenu(
                    controller: statusTextEditingController,
                    width: MediaQuery.of(context).size.width - 50,
                    dropdownMenuEntries: statusDropDownList,
                    label: const Text("Status"),
                    onSelected: (value) {
                      statusText = statusDropDownList[value].label;
                    },
                  ),
                  Visibility(
                      visible: employeeDropDownList.isNotEmpty,
                      child: CommonWidgets.verticalSpace(15)),
                  Visibility(
                      visible: employeeDropDownList.isNotEmpty,
                      child: DropdownMenu(
                        controller: employeeNameTextController,
                        width: MediaQuery.of(context).size.width - 50,
                        dropdownMenuEntries: employeeDropDownList,
                        label: const Text("Employee"),
                        menuHeight: 100,
                        onSelected: (value) {
                          employeeText = value.toString();
                        },
                      )),
                  CommonWidgets.verticalSpace(15),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                resetFilter(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.grey.shade400),
                              child: const Text("Reset"))),
                      CommonWidgets.horizontalSpace(10),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                filterDataStrings(context);
                              },
                              child: const Text("Submit")))
                    ],
                  )
                ],
              ),
            )),
      ],
    );
  }

  void filterDataStrings(context) {
    Map<String, String> filterBody = {};
    var fromDate = fromDateController.text;
    var toDate = toDateController.text;
    fromDateText = CommonFunction.isNullOrIsEmpty(fromDate)
        ? ""
        : DateFormat("yyyy-MM-dd")
            .format(DateFormat("dd-MM-yyyy").parse(fromDate));

    toDateText = CommonFunction.isNullOrIsEmpty(toDate)
        ? ""
        : DateFormat("yyyy-MM-dd")
            .format(DateFormat("dd-MM-yyyy").parse(toDate));

    filterBody["status"] =
        (CommonFunction.isNullOrIsEmpty(statusText) ? "" : statusText)!;
    filterBody["dynamicField"] =
        (CommonFunction.isNullOrIsEmpty(reasonTypeText) ? "" : reasonTypeText)!;
    filterBody["fromDate"] =
        (CommonFunction.isNullOrIsEmpty(fromDateText) ? "" : fromDateText)!;
    filterBody["toDate"] =
        (CommonFunction.isNullOrIsEmpty(toDateText) ? "" : toDateText)!;
    filterBody["employeeId"] =
        (CommonFunction.isNullOrIsEmpty(employeeText) ? "" : employeeText)!;
    Navigator.pop(context, filterBody);
  }

  resetFilter(context) {
    Map<String, String> filterBody = {};
    filterBody["status"] = "";
    filterBody["dynamicField"] = "";
    filterBody["fromDate"] = "";
    filterBody["toDate"] = "";
    filterBody["employeeId"] = "";
    // Navigator.of(context).pop("");
    Navigator.pop(context, filterBody);
  }

  void correctionFilterRetriveData() {
    if (!CommonFunction.isNullOrIsEmpty(setCorrectionFilterValue)) {
      String retriveFromDate = setCorrectionFilterValue["fromDate"];
      var fromDateText = CommonFunction.isNullOrIsEmpty(retriveFromDate)
          ? ""
          : DateFormat("dd-MM-yyyy")
              .format(DateFormat("yyyy-MM-dd").parse(retriveFromDate));
      fromDateController = TextEditingController(text: fromDateText);

      String retriveToDate = setCorrectionFilterValue["toDate"];
      var toDateText = CommonFunction.isNullOrIsEmpty(retriveToDate)
          ? ""
          : DateFormat("dd-MM-yyyy")
              .format(DateFormat("yyyy-MM-dd").parse(retriveToDate));

      toDateController = TextEditingController(text: toDateText);

      String retriveReason = setCorrectionFilterValue["dynamicField"];
      reasonTextEditingController = TextEditingController(text: retriveReason);

      String retriveStatus = setCorrectionFilterValue["status"];
      statusTextEditingController = TextEditingController(text: retriveStatus);

      String retriveEmployeeData = setCorrectionFilterValue["employeeId"];
      employeeNameTextController =
          TextEditingController(text: retriveEmployeeData);
    }
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
