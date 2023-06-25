import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/common widgets/common_widgets_constants.dart';
import '../constants/image_path.dart';
import '../utils/common_functions.dart';
import 'common_widgets.dart';

class CommonInformationDialog {
  static showInformationDialogBox(
      {required context,
      required String employeeId,
      required String employeeFirstName,
      required String employeeLastName,
      String? reportingPerson1,
      String? reportingPerson2,
      String? rep1Status,
      String? rep2Status,
      Map<String, String?>? value}) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return InformationDialog(
              employeeId,
              employeeFirstName,
              employeeLastName,
              reportingPerson1,
              reportingPerson2,
              rep1Status,
              rep2Status,
              value);
        });
  }
}

class InformationDialog extends StatelessWidget {
  String? employeeId,
      employeeFirstName,
      employeeLastName,
      reportingPerson1,
      reportingPerson2,
      rep1Status,
      rep2Status;
  Map<String, String?>? value;
  InformationDialog(
      this.employeeId,
      this.employeeFirstName,
      this.employeeLastName,
      this.reportingPerson1,
      this.reportingPerson2,
      this.rep1Status,
      this.rep2Status,
      this.value,
      {super.key});

  @override
  Widget build(BuildContext context) {
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
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "$employeeId - $employeeFirstName $employeeLastName")
                        ],
                      ),
                      const Divider(color: Colors.black54),
                      CommonWidgets.verticalSpace(5),
                      Column(children: generateText(value!)),
                      const Divider(color: Colors.black54),
                      CommonFunction.setManagerDialog(reportingPerson1,
                          reportingPerson2, rep1Status, rep2Status),
                      CommonWidgets.verticalSpace(5),
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
                      CommonWidgets.horizontalSpace(4),
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
                      CommonWidgets.horizontalSpace(4),
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

  static List<Widget> generateText(Map<String, String?> value) {
    List<Widget> widgetList = [];
    value.forEach((key, value) {
      widgetList.add(Visibility(
        visible: !CommonFunction.isNullOrIsEmpty(value),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1, child: Text(key.tr)),
            Expanded(
                flex: 2,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                        CommonFunction.isNullOrIsEmpty(value)
                            ? ""
                            : value.toString(),
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.right,
                        overflow: CommonWidgets.textOverFlowEllipsis())))
          ],
        ),
      ));
      widgetList.add(CommonWidgets.verticalSpace(5));
    });
    return widgetList;
  }
}
