import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../constants/image_path.dart';
import '../../../../../constants/leave/leave_constants.dart';

class ListContent {
  static const colorList = [
    0xFF86E3CE,
    0xFFDDE6A5,
    0xFFFFDD94,
    0xFFFA897B,
    0xFFCCABD8,
    0xFF478BA2,
    0xFFDE5B6D,
    0xFFE9765B,
    0xFFF2A490,
    0xFFB9D4DB
  ];

  static Widget listTile(index, holidayModel, holidayModelList) {
    DateTime holidayDate =
        DateFormat("yyyy-MM-dd").parse(holidayModel.holidayDate);
    final dayName = DateFormat('EEEE').format(holidayDate);

    if (holidayModelList[index - 1 < 0 ? 0 : index - 1]
                .holidayDate
                .compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now())) <
            0 &&
        holidayModelList[index]
                .holidayDate
                .compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now())) >
            0) {
      return Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    const Divider(
                      color: Colors.black26,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 10, left: 10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Text(
                        LeaveConstants.pendingHolidaysLabel.tr,
                        style: const TextStyle(
                            fontSize: 10, fontStyle: FontStyle.italic),
                      ),
                    ),
                    const Divider(
                      color: Colors.black26,
                    )
                  ],
                ),
              ),
              tileContent(holidayModel, holidayDate, dayName),
            ],
          ));
    } else {
      return Container(
        padding: const EdgeInsets.all(5),
        child: tileContent(holidayModel, holidayDate, dayName),
      );
    }
  }

  static Widget tileContent(holidayModel, holidayDate, dayName) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 40),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 6)
              ]),
          height: 80,
          child: Row(
            children: [
              Expanded(
                child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    alignment: Alignment.centerLeft,
                    height: 80,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              holidayModel.holidayName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black54),
                            ),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                holidayModel.type,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                              )),
                        ])),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: Visibility(
                  visible: holidayModel.isOptionalHoliday != 0 ? true : false,
                  child: Image.asset(
                    width: 30,
                    height: 30,
                    ImagePath.checkedItem,
                    color: Colors.black26,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 6)
              ]),
          child: CircleAvatar(
            backgroundColor:
                Color(colorList[Random().nextInt(colorList.length)]),
            foregroundColor: Colors.black,
            radius: 40,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                (holidayDate.day).toString(),
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              Text(
                dayName.substring(0, 3),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              )
            ]),
          ),
        ),
      ],
    );
  }
}
