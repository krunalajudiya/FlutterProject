// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:emgage_flutter/src/constants/attandence/regularization_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../commonWidgets/common_widgets.dart';
import '../../../../../models/employee/EmployeedetailModel.dart';
import '../../../../../utils/common_functions.dart';
import '../../../../../utils/fetch_employee_detail.dart';
import '../../model/regularization_list_model.dart';

showRegularizationUserDetailDialog(context, regularizationListModel) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return RegularizationUserDetailDiloug(regularizationListModel);
      });
}

class RegularizationUserDetailDiloug extends StatelessWidget {
  RegularizationListModel regularizationListModel;

  RegularizationUserDetailDiloug(this.regularizationListModel, {super.key});

  dialogContent(BuildContext context) {
    var startEndDate = CommonFunction.isNullOrIsEmpty(
                regularizationListModel.startDate) ||
            CommonFunction.isNullOrIsEmpty(regularizationListModel.endDate)
        ? CommonFunction.isNullOrIsEmpty(regularizationListModel.startDate) &&
                CommonFunction.isNullOrIsEmpty(regularizationListModel.endDate)
            ? ""
            : CommonFunction.isNullOrIsEmpty(regularizationListModel.startDate)
                ? DateFormat("dd/MMM")
                    .format(DateTime.parse(regularizationListModel.endDate!))
                : DateFormat("dd/MMM")
                    .format(DateTime.parse(regularizationListModel.startDate!))
        : (DateFormat("dd/MMM").format(
                        DateTime.parse(regularizationListModel.startDate!)))
                    .compareTo(DateFormat("dd/MMM").format(
                        DateTime.parse(regularizationListModel.endDate!))) ==
                0
            ? DateFormat("dd/MMM/yy")
                .format(DateTime.parse(regularizationListModel.startDate!))
            : ("${DateFormat("dd/MMM").format(DateTime.parse(regularizationListModel.startDate!))} - ${DateFormat("dd/MMM").format(DateTime.parse(regularizationListModel.endDate!))}"); // regularization from date and To date concatenating and conversion

    var inOutTime = (CommonFunction.isNullOrIsEmpty(
                regularizationListModel.inTime)
            ? ""
            : DateFormat("hh:mm").format(DateFormat("hh:mm:ss a")
                .parse(regularizationListModel.inTime!))) +
        (CommonFunction.isNullOrIsEmpty(regularizationListModel.outTime) ||
                CommonFunction.isNullOrIsEmpty(regularizationListModel.inTime)
            ? ""
            : " - ") +
        (CommonFunction.isNullOrIsEmpty(regularizationListModel.outTime)
            ? ""
            : DateFormat("hh:mm").format(DateFormat("hh:mm:ss a").parse(
                regularizationListModel
                    .outTime!))); // punch in and punch out time concatenating and formatting from hh:mm:ss a to hh:mm

    employeedetailModel employeeModel = employeedetailModel.fromJson(
        FetchEmployeeDetail
            .employeeDetail![regularizationListModel.employeeId]);

    return Stack(
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
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ]),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${employeeModel.employeeId!} - ${employeeModel.firstName} ${employeeModel.lastName}")
                          ],
                        ),
                        const Divider(color: Colors.black45),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                    RegularizationConstants.reasonTypeLable)),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  regularizationListModel.requestType!,
                                  // regularization Request type (Work From Home , On Tour , Client Site etc....)
                                  maxLines: 1,
                                  softWrap: false,
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ],
                        ),
                        CommonWidgets.verticalSpace(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child:
                                    Text(RegularizationConstants.reasonLable)),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  regularizationListModel.cancelReason!,
                                  // Reason for regularization request
                                  maxLines: 1,
                                  softWrap: false,
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ],
                        ),
                        CommonWidgets.verticalSpace(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(RegularizationConstants.dateLable)),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  startEndDate, // Regularization request date
                                  maxLines: 1,
                                  softWrap: false,
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ],
                        ),
                        CommonWidgets.verticalSpace(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                    RegularizationConstants.inOutTimeLable)),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  inOutTime, //punch in and out time
                                  maxLines: 1,
                                  softWrap: false,
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ],
                        ),
                        CommonWidgets.verticalSpace(5),
                        const Divider(color: Colors.black54),
                        CommonFunction.setManagerDialog(
                            employeeModel.reportingPerson,
                            employeeModel.reportingPerson1,
                            regularizationListModel.rep1Status,
                            regularizationListModel.rep2Status),
                        //reporting parson's Approving status
                        CommonWidgets.verticalSpace(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(RegularizationConstants.cancelReasonLable),
                            Text(RegularizationConstants
                                .cancelReasonNotGivenLable)
                            // manager cancel reason
                          ],
                        ),
                        CommonWidgets.verticalSpace(5),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    child: SizedBox(
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
                            "Approve",
                            style: TextStyle(color: Colors.black, fontSize: 11),
                          ),
                          icon: const Icon(
                            Icons.thumb_up,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      CommonWidgets.horizontalSpace(4),
                      Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: Colors.indigo,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                            ),
                            label: const Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 11),
                            ),
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                      ),
                      CommonWidgets.horizontalSpace(4),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          label: const Text(
                            "Reject",
                            style: TextStyle(color: Colors.black, fontSize: 11),
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
                ))
              ],
            )),
        const Positioned(
          height: 70,
          top: 10,
          left: 20,
          right: 20,
          child: Align(
            child: ClipRect(
                child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/other_image/man.png'),
            )),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
