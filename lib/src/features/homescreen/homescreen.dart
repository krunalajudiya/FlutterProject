import 'package:emgage_flutter/src/features/documents/hrpolicaydocument/view/hr_policy_document.dart';
import 'package:emgage_flutter/src/features/documents/payslip/view/payslip.dart';
import 'package:emgage_flutter/src/features/separation/view/separation_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../attandance/correction/view/correction_request_list.dart';
import '../attandance/regularization/view/regularization_request_list.dart';
import '../leave/extra working/view/extra_working_view.dart';
import '../leave/holiday/view/holiday_view.dart';
import '../leave/leave/view/leave_view.dart';

class drawer extends StatelessWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
      child: Column(children: [
        ExpansionTile(
          trailing: const Icon(Icons.expand_circle_down_rounded),
          title: Text("Attendance".tr),
          leading: const Icon(Icons.fingerprint_outlined),
          //add icon
          childrenPadding: const EdgeInsets.only(left: 60),
          //children padding
          children: [
            ListTile(
                title: Text("Regularization".tr),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const RegularizationRequestList()));
                }),
            const Divider(),
            ListTile(
              title: Text("Correction".tr),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CorrectionList()));
                //action on press
              },
            ),
          ],
        ),
        ExpansionTile(
          trailing: const Icon(Icons.expand_circle_down_rounded),
          title: Text("Leave".tr),
          leading: const Icon(Icons.card_travel),
          //add icon
          childrenPadding: const EdgeInsets.only(left: 60),
          //children padding
          children: [
            ListTile(
              title: Text("Holiday".tr),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HolidayView()));
                //action on press
              },
            ),
            const Divider(),
            ListTile(
                title: Text("Leave".tr),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LeaveView()));
                }),
            const Divider(),
            ListTile(
                title: Text("Extra Working".tr),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExtraWorkingView()));
                }),
          ],
        ),
        ExpansionTile(
          trailing: const Icon(Icons.expand_circle_down_rounded),
          title: Text("Documents".tr),
          leading: const Icon(Icons.paste_sharp),
          //add icon
          childrenPadding: const EdgeInsets.only(left: 60),
          //children padding
          children: [
            ListTile(
              title: Text("Payslip".tr),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Payslip()));
                //action on press
              },
            ),
            const Divider(),
            ListTile(
                title: Text("HR Policy Document".tr),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HrPolicyDocument()));
                }),
          ],
        ),
        ExpansionTile(
          trailing: const Icon(Icons.expand_circle_down_rounded),
          title: Text("Separation".tr),
          leading: const Icon(Icons.paste_sharp),
          //add icon
          childrenPadding: const EdgeInsets.only(left: 60),
          //children padding
          children: [
            ListTile(
              title: Text("Separation".tr),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SeparationView()));
                //action on press
              },
            ),
          ],
        ),
      ]),
    ));
  }
}
