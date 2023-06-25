import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/constants.dart';

class BottomBar {
  static Widget bottomInfo() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 20,
        width: double.infinity,
        color: Colors.black38,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Version ${Constants.version}",
              style: TextStyle(color: Colors.white),
            ),
            const Text(" | "),
            GestureDetector(
              onTap: () async {
                await launchUrl(Uri.parse(Constants.privacyPolicayUrl));
              },
              child: Container(
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                      color: Colors.white38,
                      decoration: TextDecoration.underline),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
