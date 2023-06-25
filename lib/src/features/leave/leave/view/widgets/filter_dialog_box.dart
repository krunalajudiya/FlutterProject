import 'package:emgage_flutter/src/constants/leave/leave_constants.dart';
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../commonWidgets/common_widgets.dart';
import '../../../../../constants/constants.dart';

showFilterDialogBox(context, List<DropdownMenuEntry> employeeDropdownMenuList,
    List<DropdownMenuEntry> leaveCodeDropdownList, filterData) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialogBox(
            employeeDropdownMenuList, leaveCodeDropdownList, filterData);
      });
}

class FilterDialogBox extends StatelessWidget {
  FilterDialogBox(this.employeeDropdownMenuList, this.leaveCodeDropdownList,
      this.filterData,
      {super.key});

  List<DropdownMenuEntry> employeeDropdownMenuList;
  List<DropdownMenuEntry> leaveCodeDropdownList;
  var filterData;

  TextEditingController dateTextEditingController = TextEditingController();
  TextEditingController employeeTextEditingController = TextEditingController();
  TextEditingController leaveCodeTextEditingController =
      TextEditingController();
  TextEditingController statusTextEditingController = TextEditingController();

  List<DropdownMenuEntry> statusDropdownMenu = [
    DropdownMenuEntry(
        value: LeaveConstants.approvedLabel.toUpperCase(),
        label: LeaveConstants.approvedLabel),
    DropdownMenuEntry(
        value: LeaveConstants.pendingLabel.toUpperCase(),
        label: LeaveConstants.pendingLabel),
    DropdownMenuEntry(
        value: LeaveConstants.rejectedLabel.toUpperCase(),
        label: LeaveConstants.rejectedLabel)
  ];
  String? leaveCodeSelectText;
  String? statusSelectText;
  String? employeeSelectText;

  @override
  Widget build(BuildContext context) {
    return CommonWidgets.dialogBox(
        context: context,
        dialogLabel: Constants.filterLabel,
        dialogContent: dialogContent(context),
        submitOnTap: () => submitData(context),
        resetOnTap: () => resetData(context));
  }

  Widget dialogContent(context) {
    setPreInitializeData();
    return Column(
      children: [
        DropdownMenu(
          width: (MediaQuery.of(context).size.width) - 50,
          dropdownMenuEntries: employeeDropdownMenuList,
          menuHeight: 100,
          enableFilter: true,
          controller: employeeTextEditingController,
          label: Text(LeaveConstants.employeeLabel.tr),
          initialSelection: employeeSelectText,
          onSelected: (value) {
            employeeSelectText = value;
          },
        ),
        CommonWidgets.verticalSpace(10),
        Row(
          children: [
            Expanded(
              child: TextField(
                  controller: dateTextEditingController,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: CommonWidgets.inputBoxBorderRadius(),
                    labelText: LeaveConstants.dateLabel.tr,
                  ),
                  readOnly: true,
                  onTap: () async {
                    var pickDate = await CommonWidgets.rangeDatePickDialog(
                        context: context);
                    if (!CommonFunction.isNullOrIsEmpty(pickDate)) {
                      dateTextEditingController.text =
                          pickDate.toString().replaceAll("\n", "  To  ");
                    }
                  }),
            ),
            CommonWidgets.horizontalSpace(10),
            Expanded(
              child: DropdownMenu(
                width: (MediaQuery.of(context).size.width / 2) - 30,
                dropdownMenuEntries: leaveCodeDropdownList,
                label: Text(LeaveConstants.leaveCodeLabel.tr),
                menuHeight: 100,
                enableFilter: true,
                controller: leaveCodeTextEditingController,
                initialSelection: leaveCodeSelectText,
                onSelected: (value) {
                  leaveCodeSelectText = value;
                },
              ),
            ),
          ],
        ),
        CommonWidgets.verticalSpace(10),
        DropdownMenu(
          width: (MediaQuery.of(context).size.width) - 50,
          dropdownMenuEntries: statusDropdownMenu,
          label: Text(LeaveConstants.statusLabel.tr),
          enableSearch: false,
          enableFilter: true,
          controller: statusTextEditingController,
          initialSelection: statusSelectText,
          onSelected: (value) {
            statusSelectText = value;
          },
        ),
      ],
    );
  }

  setPreInitializeData() {
    if (filterData != null) {
      dateTextEditingController.text = !CommonFunction.isNullOrIsEmpty(
              filterData["fromDate"])
          ? !CommonFunction.isNullOrIsEmpty(filterData["toDate"])
              ? "${DateFormat('dd-MM-yyyy').format(DateFormat("yyyy-MM-dd").parse(filterData["fromDate"]))}  To  ${DateFormat('dd-MM-yyyy').format(DateFormat("yyyy-MM-dd").parse(filterData["toDate"]))}"
              : DateFormat('dd-MM-yyyy').format(
                  DateFormat("yyyy-MM-dd").parse(filterData["fromDate"]))
          : "";
      statusSelectText = !CommonFunction.isNullOrIsEmpty(filterData["status"])
          ? filterData["status"]
          : null;
      leaveCodeSelectText =
          !CommonFunction.isNullOrIsEmpty(filterData["dynamicField"])
              ? filterData["dynamicField"]
              : null;
      employeeSelectText =
          !CommonFunction.isNullOrIsEmpty(filterData["employeeId"])
              ? filterData["employeeId"]
              : null;
      filterData = null;
    }
  }

  submitData(context) {
    Map<String, String> filterBody = {};
    filterBody["employeeId"] = (!CommonFunction.isNullOrIsEmpty(
                employeeSelectText) &&
            !CommonFunction.isNullOrIsEmpty(employeeTextEditingController.text)
        ? employeeSelectText
        : "")!;
    filterBody["status"] = (!CommonFunction.isNullOrIsEmpty(statusSelectText) &&
            !CommonFunction.isNullOrIsEmpty(statusTextEditingController.text)
        ? statusSelectText!.compareTo(
                    statusTextEditingController.text.toUpperCase()) ==
                0
            ? statusSelectText
            : ""
        : "")!;
    filterBody["fromDate"] =
        CommonFunction.isNullOrIsEmpty(dateTextEditingController.text)
            ? ""
            : DateFormat("yyyy-MM-dd").format(DateFormat('dd-MM-yyyy')
                .parse(dateTextEditingController.text.split("  To  ")[0]));
    filterBody["toDate"] =
        CommonFunction.isNullOrIsEmpty(dateTextEditingController.text)
            ? ""
            : dateTextEditingController.text.split("  To  ").length > 1
                ? DateFormat("yyyy-MM-dd").format(DateFormat('dd-MM-yyyy')
                    .parse(dateTextEditingController.text.split("  To  ")[1]))
                : "";
    //order by (column of ordering)
    filterBody["dynamicField4"] = "";
    //order (asc,des)
    filterBody["dynamicField5"] = "";
    //leaveCode
    filterBody["dynamicField"] = (!CommonFunction.isNullOrIsEmpty(
                leaveCodeSelectText) &&
            !CommonFunction.isNullOrIsEmpty(leaveCodeTextEditingController.text)
        ? leaveCodeSelectText!.compareTo(
                    leaveCodeTextEditingController.text.toUpperCase()) ==
                0
            ? leaveCodeSelectText
            : ""
        : "")!;
    CommonFunction.backPage(context, filterBody);
  }

  resetData(context) {
    Map<String, String> filterData = {};
    CommonFunction.backPage(context, filterData);
  }
}
