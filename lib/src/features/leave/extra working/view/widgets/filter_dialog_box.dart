import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../commonWidgets/common_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../utils/common_functions.dart';
import '../../../../../utils/sharedpreferences_utils.dart';

showFilterDialogBox(context, List<DropdownMenuEntry> employeeDropdownMenuList,
    filterData) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialogBox(employeeDropdownMenuList, filterData);
      });
}

class FilterDialogBox extends StatefulWidget {
  List<DropdownMenuEntry> employeeDropdownMenuList;
  var filterData;

  FilterDialogBox(this.employeeDropdownMenuList, this.filterData, {super.key});

  @override
  State<StatefulWidget> createState() => FilterDialogBoxState();
}

class FilterDialogBoxState extends State<FilterDialogBox> {
  String? employeeId;
  TextEditingController employeeTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();
  List<String> status = ["Approved", "Pending", "Rejected"];
  List<String> workType = ["Extra Working", "Overtime"];

  int? selectStatus;
  int? selectWorkType;

  @override
  void initState() {
    setPreInitializeData();
    super.initState();
  }

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
    return Column(
      children: [
        DropdownMenu(
          width: (MediaQuery.of(context).size.width) - 50,
          dropdownMenuEntries: widget.employeeDropdownMenuList,
          menuHeight: 200,
          enableFilter: true,
          controller: employeeTextEditingController,
          label: Text(Constants.employeeLabel.tr),
          initialSelection: employeeId,
          onSelected: (value) {
            employeeId = value;
          },
        ),
        CommonWidgets.verticalSpace(10),
        TextField(
            controller: dateTextEditingController,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_today),
              border: CommonWidgets.inputBoxBorderRadius(),
              labelText: Constants.dateLabel.tr,
            ),
            readOnly: true,
            onTap: () async {
              var pickDate =
                  await CommonWidgets.rangeDatePickDialog(context: context);
              if (!CommonFunction.isNullOrIsEmpty(pickDate)) {
                dateTextEditingController.text =
                    pickDate.toString().replaceAll("\n", "  To  ");
              }
            }),
        Row(
          children: CommonWidgets.checkboxList(
              valueList: status,
              selectValue: selectStatus,
              onTap: (value) {
                selectStatus = value;
                setState(() {});
              }),
        ),
        Row(
          children: CommonWidgets.checkboxList(
              valueList: workType,
              selectValue: selectWorkType,
              onTap: (value) {
                selectWorkType = value;
                setState(() {});
              }),
        )
      ],
    );
  }

  setPreInitializeData() {
    if (!CommonFunction.isNullOrIsEmpty(widget.filterData)) {
      employeeId =
          CommonFunction.isNullOrIsEmpty(widget.filterData["employeeId"])
              ? null
              : widget.filterData["employeeId"];
      selectWorkType =
          CommonFunction.isNullOrIsEmpty(widget.filterData["dynamicField"])
              ? null
              : widget.filterData["dynamicField"] == "OVER_TIME"
                  ? 1
                  : 0;
      selectStatus = CommonFunction.isNullOrIsEmpty(widget.filterData["status"])
          ? null
          : status
              .indexWhere((element) => widget.filterData["status"] == element);
      dateTextEditingController.text = !CommonFunction.isNullOrIsEmpty(
              widget.filterData["fromDate"])
          ? !CommonFunction.isNullOrIsEmpty(widget.filterData["toDate"])
              ? "${DateFormat('dd-MM-yyyy').format(DateFormat("yyyy-MM-dd").parse(widget.filterData["fromDate"]))}  To  ${DateFormat('dd-MM-yyyy').format(DateFormat("yyyy-MM-dd").parse(widget.filterData["toDate"]))}"
              : DateFormat('dd-MM-yyyy').format(
                  DateFormat("yyyy-MM-dd").parse(widget.filterData["fromDate"]))
          : "";
    }
  }

  submitData(context) async {
    Map<String, dynamic> filterBody = {};

    filterBody["employeeId"] = widget.employeeDropdownMenuList.isEmpty
        ? await SharedpreferencesUtils.getEmployeeId()
        : employeeId;
    filterBody["dynamicField"] = selectWorkType != null
        ? workType[selectWorkType!] == "Overtime"
            ? "OVER_TIME"
            : "EXTRA_WORKING"
        : null;
    filterBody["status"] = selectStatus != null ? status[selectStatus!] : null;
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

    CommonFunction.backPage(context, filterBody);
  }

  resetData(context) {
    Map<String, String> filterData = {};
    CommonFunction.backPage(context, filterData);
  }
}
