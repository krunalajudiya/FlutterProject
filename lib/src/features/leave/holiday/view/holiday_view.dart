import 'package:emgage_flutter/src/constants/leave/leave_constants.dart';
import 'package:emgage_flutter/src/features/leave/holiday/view/widgets/list_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../constants/image_path.dart';
import '../bloc/holiday_bloc.dart';
import '../model/holiday_model.dart';

class HolidayView extends StatelessWidget {
  List<HolidayModel> holidayModelList = [];

  final listMonth = [
    "January".tr,
    "February".tr,
    "March".tr,
    "April".tr,
    "May".tr,
    "June".tr,
    "July".tr,
    "August".tr,
    "September".tr,
    "October".tr,
    "November".tr,
    "December".tr
  ];

  HolidayView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HolidayBloc()..add(LoadHolidayEvent(context)),
      child: BlocBuilder<HolidayBloc, HolidayState>(
        builder: (context, state) {
          if (state is LoadHolidayState) {
            holidayModelList = state.holidayModelList;
            return Scaffold(
                appBar: AppBar(
                  title: Text(LeaveConstants.holidayLabel.tr),
                  actions: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.only(left: 22, top: 10),
                            child: Text(
                              (holidayModelList.length).toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            ImagePath.calandar,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                body: GroupedListView<dynamic, String>(
                  sort: false,
                  elements: holidayModelList,
                  groupBy: (holidaymodel) {
                    DateTime datetemp = DateFormat("yyyy-MM-dd")
                        .parse(holidaymodel.holidayDate);
                    return (datetemp.month).toString();
                  },
                  groupComparator: (value1, value2) => value2.compareTo(value1),
                  groupSeparatorBuilder: (String value) => Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Wrap(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            color: Colors.blue.shade50,
                          ),
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, top: 5, bottom: 5),
                          child: Text(
                            listMonth[int.parse(value) - 1],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                  indexedItemBuilder: (context, element, index) {
                    return ListContent.listTile(
                        index, element, holidayModelList);
                  },
                ));
          } else {
            return Scaffold(
              appBar: AppBar(title: Text(LeaveConstants.holidayLabel.tr)),
              body: CommonWidgets.emptyAnimationWidget(),
            );
          }
        },
      ),
    );
  }
}
