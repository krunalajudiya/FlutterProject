// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables

// import 'package:emgage_flutter/src/features/attandance/newRegularization/view/widgets/regularization_filter_diloug.dart';
// import 'package:emgage_flutter/src/features/attandance/newRegularization/view/widgets/regularization_request_diloug.dart';
// import 'package:emgage_flutter/src/features/attandance/newRegularization/view/widgets/regularization_request_user_detail.dart';
import 'package:emgage_flutter/src/features/attandance/regularization/view/widgets/regularization_filter_diloug.dart';
import 'package:emgage_flutter/src/features/attandance/regularization/view/widgets/regularization_request_diloug.dart';
import 'package:emgage_flutter/src/features/attandance/regularization/view/widgets/regularization_request_user_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../constants/ColorCode.dart';
import '../../../../constants/attandence/regularization_constants.dart';
import '../../../../utils/common_functions.dart';
import '../bloc/regularization_bloc.dart';

void main() {
  runApp(const MaterialApp(home: RegularizationRequestList()));
}

class RegularizationRequestList extends StatefulWidget {
  const RegularizationRequestList({Key? key}) : super(key: key);

  @override
  State<RegularizationRequestList> createState() =>
      _RegularizationRequestListState();
}

class _RegularizationRequestListState extends State<RegularizationRequestList> {
  bool textVisiblity = true;
  int totalPendingApprovedCount = 0;
  int totalRequestCount = 0;
  var regularizationList = [];

  ScrollController? _scrollController;
  bool bottomLoadingShow = false;

  var regularizationFilterValue;

  List<DropdownMenuEntry>? employeeDropDownList;
  List<DropdownMenuEntry>? requestCodeDropDownList;

  List<DropdownMenuEntry>? regularizationRequestCodeDropDownList;

  RegularizationBloc regularizationBloc = RegularizationBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RegularizationConstants.regularizationListLable),
        actions: [
          IconButton(
              onPressed: () {
                var requestedData = showRequestDiloug(context);
                if (requestedData != null) {
                  regularizationBloc
                      .add(LoadRegularizationEvent(context, true, true, null));
                }
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: BlocProvider(
        create: (context) => regularizationBloc
          ..add(LoadRegularizationEvent(context, true, false, null)),
        child: BlocConsumer<RegularizationBloc, RegularizationState>(
          listener: (context, state) {
            if (state is LoadFilterContentState) {
              employeeDropDownList = state.employeeDropDownList;
              requestCodeDropDownList = state.regularizationCodeDropDownList;
            }
          },
          buildWhen: (context, state) {
            return state is RegularizationLoadedState || state is ErrorState;
          },
          builder: (context, state) {
            if (state is RegularizationLoadedState) {
              _scrollController = ScrollController()
                ..addListener(loadMoreItems);
              regularizationList = state.regularizationList;

              return Column(
                children: [
                  Visibility(
                    visible: textVisiblity,
                    child: SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: ColorCode.totalRequestColor.withAlpha(100),
                            ),
                            child: Text(
                                " ${RegularizationConstants.totalRequestLable}"
                                " : "
                                "${state.totalRequestCount} ",
                                style: const TextStyle(fontSize: 12)),
                          ),
                          CommonWidgets.horizontalSpace(5),
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color:
                                  ColorCode.pendingApprovalColor.withAlpha(100),
                            ),
                            child: Text(
                                " ${RegularizationConstants.approvalPendingLable}"
                                " : "
                                "${state.totalPendingApprovedCount} ",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ])),
                  ),
                  Expanded(
                      child: NotificationListener<UserScrollNotification>(
                          onNotification: (notification) {
                            if (notification.direction ==
                                ScrollDirection.forward) {
                              textVisiblity = true;
                            } else if (notification.direction ==
                                ScrollDirection.reverse) {
                              textVisiblity = false;
                            }
                            return true;
                          },
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => showRegularizationUserDetailDialog(
                                    context, regularizationList[index]),
                                child: CommonWidgets.listViewTile(
                                    context: context,
                                    imagePath:
                                        "assets/images/other_image/profile_man.png",
                                    employeeName:
                                        '${state.regularizationList[index].firstName}'
                                        '${state.regularizationList[index].lastName}',
                                    centerFirstText: state
                                        .regularizationList[index].requestType
                                        .toString(),
                                    rep1Status: state.regularizationList[index].rep1Status
                                        .toString()
                                        .toLowerCase(),
                                    rep2Status: state.regularizationList[index].rep2Status
                                        .toString()
                                        .toLowerCase(),
                                    finalStatus: CommonFunction.finalStatus(state
                                        .regularizationList[index].finalStatus
                                        .toString()
                                        .toLowerCase()),
                                    rightFirstText: CommonFunction.isNullOrIsEmpty(state.regularizationList[index].startDate) ||
                                            CommonFunction.isNullOrIsEmpty(state
                                                .regularizationList[index]
                                                .endDate)
                                        ? CommonFunction.isNullOrIsEmpty(state.regularizationList[index].startDate) &&
                                                CommonFunction.isNullOrIsEmpty(state.regularizationList[index].endDate)
                                            ? ""
                                            : CommonFunction.isNullOrIsEmpty(state.regularizationList[index].startDate)
                                                ? DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].endDate!))
                                                : DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].startDate!))
                                        : (DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].startDate!))).compareTo(DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].endDate!))) == 0
                                            ? DateFormat("dd/MMM/yy").format(DateTime.parse(state.regularizationList[index].startDate!))
                                            : ("${DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].startDate!))} - "
                                                "${DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].endDate!))}"),
                                    rightSecondText: (CommonFunction.isNullOrIsEmpty(state.regularizationList[index].inTime) ? "" : DateFormat("hh:mm").format(DateFormat("hh:mm:ss a").parse(state.regularizationList[index].inTime!))) + (CommonFunction.isNullOrIsEmpty(state.regularizationList[index].outTime) || CommonFunction.isNullOrIsEmpty(state.regularizationList[index].inTime) ? "" : " - ") + (CommonFunction.isNullOrIsEmpty(state.regularizationList[index].outTime) ? "" : DateFormat("hh:mm").format(DateFormat("hh:mm:ss a").parse(state.regularizationList[index].outTime!)))),
                                // child: Card(
                                //   elevation: 0.5,
                                //   shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(10)),
                                //   child: Row(
                                //     children: [
                                //       Expanded(
                                //           flex: 2,
                                //           child: Container(
                                //               alignment: Alignment.centerLeft,
                                //               padding: const EdgeInsets.only(
                                //                   left: 10),
                                //               child: Column(
                                //                   crossAxisAlignment:
                                //                       CrossAxisAlignment.center,
                                //                   children: [
                                //                     const CircleAvatar(
                                //                       backgroundImage: AssetImage(
                                //                           'assets/images/other_image/man.png'),
                                //                     ),
                                //                     SizedBox(
                                //                         width: 65,
                                //                         child: Tooltip(
                                //                             message: state
                                //                                 .regularizationList[
                                //                                     index]
                                //                                 .employeeId,
                                //                             child: Text(
                                //                                 '${state.regularizationList[index].firstName}'
                                //                                 '${state.regularizationList[index].lastName}',
                                //                                 overflow:
                                //                                     TextOverflow
                                //                                         .ellipsis,
                                //                                 textAlign:
                                //                                     TextAlign
                                //                                         .center)))
                                //                   ]))),
                                //       Expanded(
                                //           flex: 3,
                                //           child: Column(children: [
                                //             regularizationRequests(state
                                //                 .regularizationList[index]
                                //                 .requestType),
                                //             CommonWidgets.verticalSpace(4),
                                //             Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.center,
                                //               children: [
                                //                 // CommonFunction.statusIcon(state
                                //                 //     .regularizationList[index]
                                //                 //     .rep1Status
                                //                 //     .toString()
                                //                 //     .toLowerCase()),
                                //                 // CommonFunction.statusIcon(state
                                //                 //     .regularizationList[index]
                                //                 //     .rep2Status
                                //                 //     .toString()
                                //                 //     .toLowerCase()),
                                //                 CommonFunction.finalStatus(state
                                //                     .regularizationList[index]
                                //                     .finalStatus
                                //                     .toString()
                                //                     .toLowerCase())
                                //               ],
                                //             )
                                //           ])),
                                //       Expanded(
                                //           flex: 3,
                                //           child: Container(
                                //             padding:
                                //                 const EdgeInsets.only(left: 10),
                                //             child: Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 Row(
                                //                   children: [
                                //                     Text(CommonFunction.isNullOrIsEmpty(state
                                //                                 .regularizationList[
                                //                                     index]
                                //                                 .startDate) ||
                                //                             CommonFunction.isNullOrIsEmpty(state
                                //                                 .regularizationList[
                                //                                     index]
                                //                                 .endDate)
                                //                         ? CommonFunction.isNullOrIsEmpty(state.regularizationList[index].startDate) &&
                                //                                 CommonFunction.isNullOrIsEmpty(state
                                //                                     .regularizationList[
                                //                                         index]
                                //                                     .endDate)
                                //                             ? ""
                                //                             : CommonFunction.isNullOrIsEmpty(state
                                //                                     .regularizationList[
                                //                                         index]
                                //                                     .startDate)
                                //                                 ? DateFormat("dd/MMM")
                                //                                     .format(
                                //                                         DateTime.parse(state.regularizationList[index].endDate!))
                                //                                 : DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].startDate!))
                                //                         : (DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].startDate!))).compareTo(DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].endDate!))) == 0
                                //                             ? DateFormat("dd/MMM/yy").format(DateTime.parse(state.regularizationList[index].startDate!))
                                //                             : ("${DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].startDate!))} - "
                                //                                 "${DateFormat("dd/MMM").format(DateTime.parse(state.regularizationList[index].endDate!))}")),
                                //                     const Text("5")
                                //                   ],
                                //                 ),
                                //                 Text((CommonFunction.isNullOrIsEmpty(state.regularizationList[index].inTime)
                                //                         ? ""
                                //                         : DateFormat("hh:mm").format(
                                //                             DateFormat("hh:mm:ss a")
                                //                                 .parse(state
                                //                                     .regularizationList[
                                //                                         index]
                                //                                     .inTime!))) +
                                //                     (CommonFunction.isNullOrIsEmpty(state.regularizationList[index].outTime) || CommonFunction.isNullOrIsEmpty(state.regularizationList[index].inTime)
                                //                         ? ""
                                //                         : " - ") +
                                //                     (CommonFunction.isNullOrIsEmpty(state.regularizationList[index].outTime)
                                //                         ? ""
                                //                         : DateFormat("hh:mm")
                                //                             .format(DateFormat(
                                //                                     "hh:mm:ss a")
                                //                                 .parse(state.regularizationList[index].outTime!))))
                                //               ],
                                //             ),
                                //           ))
                                //     ],
                                //   ),
                                // ),
                              );
                            },
                            itemCount: state.regularizationList.length,
                          )))
                ],
              );
            } else if (state is ErrorState) {
              return const Center(
                child: Text("No Data Found"),
              );
            } else {
              return Container(child: CommonWidgets.emptyAnimationWidget());
            }
          },
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SpeedDial(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                animationAngle: 45,
                direction: SpeedDialDirection.up,
                spaceBetweenChildren: 10,
                animatedIcon: AnimatedIcons.menu_close,
                children: [
                  SpeedDialChild(
                      child: const Icon(Icons.content_paste_search),
                      label: 'Search',
                      onTap: () async {
                        var filterData = await showFilterDiloug(
                            context,
                            employeeDropDownList,
                            requestCodeDropDownList,
                            regularizationFilterValue);
                        if (filterData != null) {
                          regularizationBloc.add(LoadRegularizationEvent(
                              context, true, true, filterData));
                          regularizationFilterValue = filterData;
                        }
                      }),
                  SpeedDialChild(
                    child: const Icon(Icons.file_download_outlined),
                    label: 'Export',
                  )
                ]),
          )
        ],
      ),
    );
  }

  loadMoreItems() async {
    if ((_scrollController!.position.pixels).toInt() ==
        (_scrollController!.position.maxScrollExtent).toInt()) {
      if (regularizationList.length < totalRequestCount) {
        regularizationBloc
            .add(LoadRegularizationEvent(context, false, true, null));
      }
    }
  }
}
