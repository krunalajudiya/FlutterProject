import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:emgage_flutter/src/constants/common%20widgets/common_widgets_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

import '../constants/ColorCode.dart';
import '../constants/constants.dart';
import '../constants/image_path.dart';
import '../utils/common_functions.dart';

class CommonWidgets {
  static InputDecoration inputBoxDecoration(String labelText) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      labelText: labelText,
    );
  }

  static OutlineInputBorder inputBoxBorderRadius() {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(5));
  }

  static SizedBox verticalSpace(double height) {
    return SizedBox(
      height: height,
    );
  }

  static SizedBox horizontalSpace(double width) {
    return SizedBox(
      width: width,
    );
  }

  static ButtonStyle loginButtonStyle() {
    return ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40));
  }

  static TextStyle headerTextStyle() {
    return const TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400);
  }

  static TextStyle listLabelTextStyle() {
    return const TextStyle(
        color: Colors.black, fontSize: 15, fontWeight: FontWeight.w300);
  }

  static TextOverflow textOverFlowEllipsis() {
    return TextOverflow.ellipsis;
  }

  static Widget emptyAnimationWidget() {
    return Center(
      child: Lottie.asset(
          width: double.infinity,
          height: double.infinity,
          ImagePath.emptyBoxAnimation),
    );
  }

  static Widget totalReqAndPendingAppro(
      String totalRequestCount, String totalApprovalCount) {
    return Wrap(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: Colors.greenAccent,
            ),
            child: Text(
                CommonWidgetsConstants.totalRequestLabel.tr +
                    totalRequestCount.toString(),
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: const Color(0xFFc1e1c1),
            ),
            child: Text(
              CommonWidgetsConstants.pendingApprovalLabel.tr +
                  totalApprovalCount.toString(),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    ]);
  }

  static Widget finalStatusRGG(String status) {
    if (status.toUpperCase() == "REJECT" ||
        status.toUpperCase() == "REJECTED") {
      return Tooltip(
          message: "Rejected",
          child: Image.asset(
            ImagePath.finalReject,
            height: 20,
          ));
    } else if (status.toUpperCase() == "APPROVE" ||
        status.toUpperCase() == "APPROVED") {
      return Tooltip(
          message: "Approved",
          child: Image.asset(
            ImagePath.finalApprove,
            color: Colors.green,
            height: 20,
          ));
    } else if (status.toUpperCase() == "CANCEL" ||
        status.toUpperCase() == "CANCELLED") {
      return Tooltip(
          message: "Rejected",
          child: Image.asset(
            ImagePath.finalReject,
            height: 20,
          ));
    } else {
      return Tooltip(
          message: "Pending",
          child: Image.asset(
            ImagePath.finalPanding,
            height: 20,
          ));
    }
  }

  static Widget listViewTile(
      {required context,
      required String imagePath,
      required String employeeName,
      required String centerFirstText,
      required String rep1Status,
      required String rep2Status,
      required Widget finalStatus,
      required String rightFirstText,
      required String rightSecondText}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      child: CommonFunction.isNullOrIsEmpty(imagePath)
                          ? Image.asset(ImagePath.profileMan)
                          : FadeInImage.assetNetwork(
                              height: 60,
                              placeholder: ImagePath.profileMan,
                              image: imagePath,
                              imageErrorBuilder: ((context, error, stacktrace) {
                                return Image.asset(ImagePath.profileMan);
                              }))),
                  SizedBox(
                      width: 60,
                      child: Text(
                        employeeName,
                        overflow: CommonWidgets.textOverFlowEllipsis(),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  centerFirstText,
                  overflow: CommonWidgets.textOverFlowEllipsis(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      width: 30,
                      height: 20,
                      ImagePath.manAnim,
                      color: CommonFunction.approvalColor(rep1Status),
                    ),
                    Image.asset(
                      width: 30,
                      height: 20,
                      ImagePath.manAnim,
                      color: CommonFunction.approvalColor(rep2Status),
                    ),
                    finalStatus,
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text(rightFirstText), Text(rightSecondText)],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Future<String?> rangeDatePickDialog(
      {context,
      bool rangeOrSingle = true,
      DateTime? firstDate,
      DateTime? lastDate,
      DateTime? currentDate}) async {
    List<DateTime?>? pickdate = await showCalendarDatePicker2Dialog(
      context: context,
      dialogSize: const Size(325, 400),
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDate: firstDate,
        lastDate: lastDate,
        currentDate: currentDate,
        calendarType: rangeOrSingle
            ? CalendarDatePicker2Type.range
            : CalendarDatePicker2Type.single,
      ),
    );
    return pickdate != null
        ? pickdate.length == 1
            ? DateFormat("dd-MM-yyyy").format(pickdate[0]!)
            : "${DateFormat("dd-MM-yyyy").format(pickdate[0]!)}\n${DateFormat("dd-MM-yyyy").format(pickdate[1]!)}"
        : null;
  }

  static singleDatePickDialog() {}

  static Widget dialogBox(
      {required context,
      required String dialogLabel,
      required Widget dialogContent,
      required Function() submitOnTap,
      required Function() resetOnTap}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.only(left: 10, right: 10),
      child: Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dialogLabel.tr,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => CommonFunction.backPage(context, null),
                        icon: const Icon(Icons.close))
                  ],
                ),
                CommonWidgets.verticalSpace(10),
                dialogContent,
                CommonWidgets.verticalSpace(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: resetOnTap,
                          child: Text(CommonWidgetsConstants.resetLabel.tr)),
                    ),
                    CommonWidgets.horizontalSpace(10),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: submitOnTap,
                          child: Text(CommonWidgetsConstants.submitLabel.tr)),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  static InputDecoration textFieldErrorDecoration(
      Color? errorStatus, String labelText) {
    return InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorStatus ?? ColorCode.fieldBoxColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: errorStatus ?? ColorCode.fieldBoxFoucsColor),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        labelStyle: TextStyle(color: errorStatus ?? ColorCode.fieldBoxColor),
        labelText: labelText.tr);
  }

  static InputDecorationTheme dropdownMenuErrorDecoration(Color? errorStatus) {
    return InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide:
              BorderSide(color: errorStatus ?? ColorCode.fieldBoxFoucsColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorStatus ?? ColorCode.fieldBoxColor),
        ));
  }

  static TextStyle dropdownMenuErrorTextStyle(Color? errorStatus) {
    return TextStyle(color: errorStatus ?? ColorCode.fieldBoxColor);
  }

  static List<Widget> checkboxList(
      {required List<String> valueList,
      required int? selectValue,
      required Function(int selectTapValue) onTap}) {
    List<Widget> checkboxList = [];
    for (int i = 0; i < valueList.length; i++) {
      checkboxList.add(Checkbox(
          value: selectValue == i,
          side: const BorderSide(width: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          visualDensity: const VisualDensity(horizontal: 2.0, vertical: 2.0),
          onChanged: (value) {
            onTap(i);
          }));
      checkboxList.add(Text(valueList[i]));
    }
    return checkboxList;
  }

  static Widget employeeDropDown(
      {required context,
      required List<DropdownMenuEntry> employeeDropdownMenuList,
      required TextEditingController employeeTextEditingController,
      Object? initialSelection,
      Color? employeeErrorStatus,
      required Function(String value) onSelect}) {
    return DropdownMenu(
      width: (MediaQuery.of(context).size.width) - 50,
      dropdownMenuEntries: employeeDropdownMenuList,
      menuHeight: 200,
      enableFilter: true,
      controller: employeeTextEditingController,
      initialSelection: initialSelection,
      label: Text(
        Constants.employeeLabel.tr,
        style: TextStyle(color: employeeErrorStatus ?? ColorCode.fieldBoxColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: employeeErrorStatus ?? ColorCode.fieldBoxFoucsColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: employeeErrorStatus ?? ColorCode.fieldBoxColor),
          )),
      onSelected: (value) {
        onSelect(value);
      },
    );
  }

  static Widget dateTextBox(TextEditingController dateTextEditingController,
      bool smallTextBox, Function() onTap) {
    return TextField(
        controller: dateTextEditingController,
        minLines: smallTextBox ? 2 : null,
        maxLines: smallTextBox ? 2 : null,
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.calendar_today),
            border: inputBoxBorderRadius(),
            labelText: Constants.dateLabel.tr,
            contentPadding: smallTextBox
                ? const EdgeInsets.symmetric(horizontal: 7, vertical: 6)
                : null),
        readOnly: true,
        onTap: onTap);
  }

  static Widget timeTextBox(TextEditingController timeTextEditingController,
      String label, Function() onTap) {
    return TextField(
        controller: timeTextEditingController,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.access_time_rounded),
          border: inputBoxBorderRadius(),
          labelText: label.tr,
        ),
        readOnly: true,
        onTap: onTap);
  }

  static Widget informationShowDialog({
    required String employeeId,
    required String employeeFirstName,
    required String employeeLastName,
    String? startDate,
    String? endDate,
    String? leaveCode,
    String? requestedDate,
    String? reason,
    String? reportingPerson1,
    String? reportingPerson2,
    String? rep1Status,
    String? rep2Status,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 20, top: 30 + 20, right: 20, bottom: 20),
                  margin: const EdgeInsets.only(top: 45),
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "$employeeId - $employeeFirstName $employeeLastName")
                        ],
                      ),
                      const Divider(color: Colors.black54),
                      Visibility(
                        visible: !CommonFunction.isNullOrIsEmpty(startDate) &&
                            !CommonFunction.isNullOrIsEmpty(endDate),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1, child: Text(Constants.dateLabel.tr)),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        maxLines: 1,
                                        softWrap: false,
                                        textAlign: TextAlign.right,
                                        overflow: textOverFlowEllipsis(),
                                        !CommonFunction.isNullOrIsEmpty(
                                                    startDate) &&
                                                !CommonFunction.isNullOrIsEmpty(
                                                    endDate)
                                            ? startDate == endDate
                                                ? startDate.toString()
                                                : "$startDate - $endDate"
                                            : ""))),
                          ],
                        ),
                      ),
                      verticalSpace(5),
                      Visibility(
                        visible: !CommonFunction.isNullOrIsEmpty(leaveCode),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                    CommonWidgetsConstants.leaveCodeLabel.tr)),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        maxLines: 1,
                                        softWrap: false,
                                        textAlign: TextAlign.right,
                                        overflow: textOverFlowEllipsis(),
                                        CommonFunction.isNullOrIsEmpty(
                                                leaveCode)
                                            ? ""
                                            : leaveCode!)))
                          ],
                        ),
                      ),
                      verticalSpace(5),
                      Visibility(
                        visible: !CommonFunction.isNullOrIsEmpty(requestedDate),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(CommonWidgetsConstants
                                    .requestDateLabel.tr)),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        maxLines: 1,
                                        softWrap: false,
                                        textAlign: TextAlign.right,
                                        overflow: textOverFlowEllipsis(),
                                        CommonFunction.isNullOrIsEmpty(
                                                requestedDate)
                                            ? ""
                                            : requestedDate!)))
                          ],
                        ),
                      ),
                      verticalSpace(5),
                      Visibility(
                        visible: !CommonFunction.isNullOrIsEmpty(reason),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                    CommonWidgetsConstants.reasonLabel.tr)),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        maxLines: 1,
                                        softWrap: false,
                                        textAlign: TextAlign.right,
                                        overflow: textOverFlowEllipsis(),
                                        CommonFunction.isNullOrIsEmpty(reason)
                                            ? ""
                                            : reason!)))
                          ],
                        ),
                      ),
                      verticalSpace(5),
                      const Divider(color: Colors.black54),
                      CommonFunction.setManagerDialog(reportingPerson1,
                          reportingPerson2, rep1Status, rep2Status),
                      verticalSpace(5),
                    ],
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.indigo,
                              elevation: 10,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20)))),
                          label: const Text(
                            CommonWidgetsConstants.approveLabel,
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          icon: const Icon(
                            Icons.thumb_up,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      horizontalSpace(4),
                      Visibility(
                        visible: true,
                        child: Expanded(
                          child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shadowColor: Colors.indigo,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                              label: Text(
                                CommonWidgetsConstants.cancelLabel.tr,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                        ),
                      ),
                      horizontalSpace(4),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          label: Text(
                            CommonWidgetsConstants.rejectLabel.tr,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          icon: const Icon(
                            Icons.thumb_down,
                            color: Colors.red,
                          ),
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.indigo,
                              elevation: 10,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20)))),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Positioned(
            height: 70,
            top: 10,
            left: 20,
            right: 20,
            child: Align(
              child: ClipRect(
                  child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(ImagePath.profileMan),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
