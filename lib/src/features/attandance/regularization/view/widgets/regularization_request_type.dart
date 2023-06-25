import 'package:flutter/material.dart';

import '../../../../../constants/ColorCode.dart';

Widget regularizationRequests(requestType) {
  if (requestType == "Official Work") {
    return Tooltip(
      message: "Official Work",
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorCode.officialWorkRequestColor.withAlpha(50),
          ),
          width: 30,
          child: const Center(
              child: Text(
            "OW",
            style: TextStyle(color: Colors.black45),
          ))),
    );
  } else if (requestType == "Training") {
    return Tooltip(
      message: "Training",
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorCode.trainingRequestColor.withAlpha(50),
          ),
          width: 50,
          child: const Center(
              child: Text(
            "TR",
            style: TextStyle(color: Colors.black45),
          ))),
    );
  } else if (requestType == "Work From Home") {
    return Tooltip(
      message: "Work From Home",
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorCode.workFromHomeRequestColor.withAlpha(50),
          ),
          width: 40,
          child: const Center(
              child: Text(
            "WFH",
            style: TextStyle(color: Colors.black45),
          ))),
    );
  } else if (requestType == "Late Coming Request") {
    return Tooltip(
      message: "Late Coming Request",
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorCode.lateComingRequestColor.withAlpha(50),
          ),
          width: 40,
          child: const Center(
              child: Text(
            "LCR",
            style: TextStyle(color: Colors.black45),
          ))),
    );
  } else if (requestType == "Early Going Request") {
    return Tooltip(
      message: "Early Going Request",
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorCode.earlyGoingRequestColor.withAlpha(50),
          ),
          width: 40,
          child: const Center(
              child: Text(
            "EGR",
            style: TextStyle(color: Colors.black45),
          ))),
    );
  } else if (requestType == "On Tour") {
    return Tooltip(
      message: "On tour",
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorCode.onTourRequestColor.withAlpha(50),
          ),
          width: 50,
          child: const Center(
              child: Text(
            "TOUR",
            style: TextStyle(color: Colors.black45),
          ))),
    );
  } else if (requestType == "Time Off") {
    return Tooltip(
      message: "Time Off",
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorCode.timeOffRequestColor.withAlpha(50),
        ),
        width: 40,
        child: const Center(
          child: Text(
            "TO",
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ),
    );
  } else if (requestType == "Out Fence Punch In Request") {
    return Tooltip(
      message: "Out Fence Punch In Request",
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorCode.outFencePunchInRequestColor.withAlpha(50),
        ),
        width: 40,
        child: const Center(
          child: Text(
            "OFPI",
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ),
    );
  } else if (requestType == "Out Fence Punch Out Request") {
    return Tooltip(
      message: "Out Fence Punch Out Request",
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorCode.outFencePunchOutRequestColor.withAlpha(50),
        ),
        width: 50,
        child: const Center(
          child: Text(
            "OFPO",
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ),
    );
  } else {
    return Tooltip(
      message: "Not Found",
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorCode.nFRequestColor.withAlpha(50),
        ),
        width: 50,
        child: const Center(
          child: Text(
            "NF",
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ),
    );
  }
}
