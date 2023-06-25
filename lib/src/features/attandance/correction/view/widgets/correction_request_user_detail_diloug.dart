// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:emgage_flutter/src/commonWidgets/common_widgets.dart';
import 'package:flutter/material.dart';
import '../../../../../constants/attandence/correction_constants.dart';
import '../../../../../models/employee/EmployeedetailModel.dart';
import '../../../../../utils/common_functions.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/fetch_employee_detail.dart';
import '../../model/correction_list_model.dart';

showUserDetailDialog(context, correctionModelList) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CorrectionUserDetailDiloug(correctionModelList);
      });
}

class CorrectionUserDetailDiloug extends StatelessWidget {
  CorrectionlistModel correctionModelList;

  CorrectionUserDetailDiloug(this.correctionModelList, {super.key});

  dialogContent(BuildContext context) {
    var startDate = correctionModelList.startDate!; // Correction date

    var inOutTime = (CommonFunction.isNullOrIsEmpty(correctionModelList.inTime)
            ? ""
            : DateFormat("HH:mm").format(
                DateFormat("hh:mm a").parse(correctionModelList.inTime!))) +
        (CommonFunction.isNullOrIsEmpty(correctionModelList.outTime) ||
                CommonFunction.isNullOrIsEmpty(correctionModelList.inTime)
            ? ""
            : " - ") +
        (CommonFunction.isNullOrIsEmpty(correctionModelList.outTime)
            ? ""
            : DateFormat("HH:mm").format(DateFormat("hh:mm a").parse(
                correctionModelList
                    .outTime))); // punch in punch out time formatting from hh:mm a to HH:mm
    // and concatenate punch in and punch out in One

    employeedetailModel employeeModel = employeedetailModel.fromJson(
        FetchEmployeeDetail.employeeDetail![correctionModelList
            .employeeId]); // Fetching employee from employee model

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
                                child:
                                    Text(CorrectionConstants.reasonTypeLable)),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  correctionModelList
                                      .requestType!, // correction request type (punchIn / punchInOut / punch Out)
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
                                child: Text(CorrectionConstants.reasonLable)),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  correctionModelList
                                      .cancelReason!, // punchIn request Reason
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
                                child: Text(CorrectionConstants.dateLable)),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  startDate, // correction Date
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
                                    Text(CorrectionConstants.inOutTimeLable)),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  inOutTime, // punch in and punch out time
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
                            correctionModelList.rep1Status,
                            correctionModelList
                                .rep2Status), //reporting parson's Approving status
                        CommonWidgets.verticalSpace(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(CorrectionConstants.cancelReasonLable),
                            Text(CorrectionConstants
                                .cancelReasonNotGivenLable) // manager cancel reason
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
