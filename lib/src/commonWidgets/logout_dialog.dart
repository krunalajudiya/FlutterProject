import 'package:emgage_flutter/src/utils/sharedpreferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

logoutView(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LogoutDialog();
      });
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: dialogContet(context),
    );
  }

  Widget dialogContet(context) {
    return Card(
      child: Container(
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text("Logout".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 30))),
            Container(
                padding: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text("Are you sure, you want to logout?".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 20))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        SharedpreferencesUtils.logoutUser(context);
                      },
                      child: Text("Yes, log out".tr)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel".tr)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
