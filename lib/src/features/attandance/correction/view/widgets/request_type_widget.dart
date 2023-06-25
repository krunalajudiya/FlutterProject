import 'package:flutter/material.dart';

import '../../../../../constants/ColorCode.dart';

Widget punchingRequestId(requestType) {
  if (requestType == "In Punch Correction") {
    return Tooltip(
        message: "In Punch Correction",
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorCode.inPunchRequestColor.withAlpha(50),
            ),
            width: 30,
            child: const Center(
                child: Text(
              "IN",
              style: TextStyle(color: Colors.black45),
            ))));
  } else if (requestType == "In Out Punch Correction") {
    return Tooltip(
        message: "In Out Punch Correction",
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorCode.inOutPunchRequestColor.withAlpha(50),
            ),
            width: 50,
            child: const Center(
                child: Text(
              "INOUT",
              style: TextStyle(color: Colors.black45),
            ))));
  } else if (requestType == "Out Punch Correction") {
    return Tooltip(
        message: "Out Punch Correction",
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorCode.outPunchRequestColor.withAlpha(50),
            ),
            width: 40,
            child: const Center(
                child: Text(
              "OUT",
              style: TextStyle(color: Colors.black45),
            ))));
  } else {
    return const Text("empty");
  }
}
