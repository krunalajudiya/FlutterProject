import 'package:emgage_flutter/src/constants/separation/sepatation_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../constants/constants.dart';

showFilterDialogBox(
    context, List<DropdownMenuEntry> employeeDropdownMenuList) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialogBox(employeeDropdownMenuList);
      });
}

class FilterDialogBox extends StatelessWidget {
  FilterDialogBox(this.employeeDropdownMenuList, {super.key});

  List<DropdownMenuEntry> employeeDropdownMenuList;

  TextEditingController employeeTextEditingController = TextEditingController();
  TextEditingController separationTypeTextEditingController =
      TextEditingController();
  TextEditingController approvalStatusTextEditingController =
      TextEditingController();
  TextEditingController separationReasonTextEditingController =
      TextEditingController();
  TextEditingController clearanceStatusTextEditingController =
      TextEditingController();
  TextEditingController exitInterviewStatusTextEditingController =
      TextEditingController();
  TextEditingController separationStatusTextEditingController =
      TextEditingController();
  TextEditingController employeeStatusTextEditingController =
      TextEditingController();

  List<DropdownMenuEntry> separationTypeDropdownMenuList = [
    const DropdownMenuEntry(value: "END OF CONTRACT", label: "End Of Contract"),
    const DropdownMenuEntry(value: "RESIGNATION", label: "Resignation"),
    const DropdownMenuEntry(value: "RETIREMENT", label: "Retirement"),
    const DropdownMenuEntry(value: "TERMINATION", label: "Termination"),
  ];
  List<DropdownMenuEntry> approvalStatusDropdownMenuList = [
    const DropdownMenuEntry(value: "APPROVE", label: "Approve"),
    const DropdownMenuEntry(value: "PENDING", label: "Pending"),
    const DropdownMenuEntry(value: "REJECT", label: "Reject"),
    const DropdownMenuEntry(
        value: "REVOKED/PULL BACK", label: "Revoked/Pull Back"),
  ];

  List<DropdownMenuEntry> clearanceStatusDropdownMenuList = [
    const DropdownMenuEntry(value: "NOT INITIATED", label: "Not Initiated"),
    const DropdownMenuEntry(value: "NOT REQUIRED", label: "Not Required"),
    const DropdownMenuEntry(value: "POC CLEARANCE", label: "POC Clearance"),
    const DropdownMenuEntry(value: "HR CLEARANCE", label: "HR Clearance"),
    const DropdownMenuEntry(value: "COMPLETED", label: "Completed"),
  ];

  List<DropdownMenuEntry> exitInteviewStatusDropdownMenuList = [
    const DropdownMenuEntry(value: "INITIATED", label: "Initiated"),
    const DropdownMenuEntry(value: "NOT INITIATED", label: "Not Initiated"),
    const DropdownMenuEntry(value: "NOT REQUIRED", label: "Not Required"),
    const DropdownMenuEntry(value: "COMPLETED", label: "Completed"),
  ];

  List<DropdownMenuEntry> separationStatusDropdownMenuList = [
    const DropdownMenuEntry(value: "RESIGNED", label: "Resigned"),
    const DropdownMenuEntry(value: "APPROVED", label: "Approved"),
    const DropdownMenuEntry(value: "REJECTED", label: "Rejected"),
    const DropdownMenuEntry(value: "REVOKED", label: "Revoked"),
    const DropdownMenuEntry(value: "F&F PENDING", label: "F&F Pending"),
    const DropdownMenuEntry(value: "F&F PAID", label: "F&F Paid"),
    const DropdownMenuEntry(value: "F&F PROCESS", label: "F&F Process"),
  ];

  List<DropdownMenuEntry> employeeStatusDropdownMenuList = [
    const DropdownMenuEntry(value: "ACTIVE", label: "Active"),
    const DropdownMenuEntry(value: "INACTIVE", label: "InActive"),
    const DropdownMenuEntry(value: "FNF", label: "FNF"),
  ];

  List<String> employeeStatusList = ["Active", "InActive", "FNF"];

  int? employeeStatusSelectType;

  @override
  Widget build(BuildContext context) {
    return CommonWidgets.dialogBox(
        context: context,
        dialogLabel: Constants.filterLabel,
        dialogContent: dialogContent(context),
        submitOnTap: () {},
        resetOnTap: () {});
  }

  Widget dialogContent(context) {
    return Column(
      children: [
        DropdownMenu(
          width: MediaQuery.of(context).size.width - 50,
          dropdownMenuEntries: employeeDropdownMenuList,
          label: Text(SeparationConstants.employeeLabel.tr),
          menuHeight: 100,
          enableFilter: true,
          controller: employeeTextEditingController,
          // initialSelection: ,
          onSelected: (value) {},
        ),
        CommonWidgets.verticalSpace(10),
        Row(
          children: [
            DropdownMenu(
              width: (MediaQuery.of(context).size.width / 2) - 30,
              dropdownMenuEntries: separationTypeDropdownMenuList,
              label: Text(SeparationConstants.separationTypeLabel.tr),
              menuHeight: 100,
              enableFilter: true,
              controller: separationTypeTextEditingController,
              // initialSelection: ,
              onSelected: (value) {},
            ),
            CommonWidgets.horizontalSpace(5),
            DropdownMenu(
              width: (MediaQuery.of(context).size.width / 2) - 25,
              dropdownMenuEntries: approvalStatusDropdownMenuList,
              label: Text(SeparationConstants.approvalStatusLabel.tr),
              menuHeight: 100,
              enableFilter: true,
              controller: approvalStatusTextEditingController,
              // initialSelection: ,
              onSelected: (value) {},
            ),
          ],
        ),
        CommonWidgets.verticalSpace(10),
        DropdownMenu(
          width: MediaQuery.of(context).size.width - 50,
          dropdownMenuEntries: const [],
          label: Text(SeparationConstants.separationReasonLabel.tr),
          menuHeight: 100,
          enableFilter: true,
          // controller: approvalStatusTextEditingController,
          // initialSelection: ,
          onSelected: (value) {},
        ),
        CommonWidgets.verticalSpace(10),
        Row(
          children: [
            DropdownMenu(
              width: (MediaQuery.of(context).size.width / 2) - 30,
              dropdownMenuEntries: clearanceStatusDropdownMenuList,
              label: Text(SeparationConstants.clearanceStatusLabel.tr),
              menuHeight: 100,
              enableFilter: true,
              controller: clearanceStatusTextEditingController,
              // initialSelection: ,
              onSelected: (value) {},
            ),
            CommonWidgets.horizontalSpace(5),
            DropdownMenu(
              width: (MediaQuery.of(context).size.width / 2) - 30,
              dropdownMenuEntries: exitInteviewStatusDropdownMenuList,
              label: Text(SeparationConstants.exitInterviewStatusLabel.tr),
              menuHeight: 100,
              enableFilter: true,
              controller: exitInterviewStatusTextEditingController,
              // initialSelection: ,
              onSelected: (value) {},
            ),
          ],
        ),
        CommonWidgets.verticalSpace(10),
        DropdownMenu(
          width: (MediaQuery.of(context).size.width / 2) - 30,
          dropdownMenuEntries: separationStatusDropdownMenuList,
          label: Text(SeparationConstants.seprationStatusLabel.tr),
          menuHeight: 100,
          enableFilter: true,
          controller: separationReasonTextEditingController,
          // initialSelection: ,
          onSelected: (value) {},
        ),
        Row(
          children: employeeStatusCheckbox(employeeStatusList),
        )
      ],
    );
  }

  List<Widget> employeeStatusCheckbox(List<String> employeeStatusList) {
    List<Widget> checkboxList = [];
    for (int i = 0; i < employeeStatusList.length; i++) {
      checkboxList.add(Checkbox(
          value: employeeStatusSelectType == i,
          onChanged: (value) {
            employeeStatusSelectType = i;
          }));
      checkboxList.add(Text(employeeStatusList[i]));
    }
    return checkboxList;
  }
}
