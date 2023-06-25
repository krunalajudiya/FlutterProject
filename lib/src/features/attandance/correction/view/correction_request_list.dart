// ignore_for_file: depend_on_referenced_packages

import 'package:emgage_flutter/src/commonwidgets/common_widgets.dart';
import 'package:emgage_flutter/src/constants/ColorCode.dart';
import 'package:emgage_flutter/src/features/attandance/correction/view/widgets/correction_filter_diloug.dart';
import 'package:emgage_flutter/src/features/attandance/correction/view/widgets/correction_request_diloug.dart';
import 'package:emgage_flutter/src/features/attandance/correction/view/widgets/correction_request_user_detail_diloug.dart';
// import 'package:emgage_flutter/src/features/attandance/newCorrection/bloc/correction_bloc.dart';
// import 'package:emgage_flutter/src/features/attandance/newCorrection/view/widgets/correction_filter_diloug.dart';
// import 'package:emgage_flutter/src/features/attandance/newCorrection/view/widgets/correction_request_diloug.dart';
// import 'package:emgage_flutter/src/features/attandance/newCorrection/view/widgets/correction_request_user_detail_diloug.dart';
// import 'package:emgage_flutter/src/features/attandance/newCorrection/view/widgets/request_type_widget.dart';
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import '../../../../constants/attandence/correction_constants.dart';
import '../bloc/correction_bloc.dart';

void main() {
  runApp(const MaterialApp(
    home: CorrectionList(),
  ));
}

class CorrectionList extends StatefulWidget {
  const CorrectionList({Key? key}) : super(key: key);

  @override
  State<CorrectionList> createState() => _CorrectionListState();
}

class _CorrectionListState extends State<CorrectionList> {
  bool textVisiblity = true;
  int totalApprovedCount = 0; // pending for approval request count
  int totalRequestCount = 0; // total Request Count
  var correctionList = []; //correction data List from model

  ScrollController? _scrollController;
  bool bottomLoadingShow = false;

  var correctionFilterValue;

  List<DropdownMenuEntry>? employeeDropDownList;

  CorrectionBloc correctionBloc = CorrectionBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                var requestData =
                    showRequestDiloug(context, employeeDropDownList);
                if (requestData != null) {
                  correctionBloc
                      .add(LoadCorrectionEvent(context, null, true, true));
                }
              },
              icon: const Icon(Icons.add))
        ],
        title: Text(CorrectionConstants.correctionListLable),
      ),
      body: BlocProvider(
        create: (context) => correctionBloc
          ..add(LoadCorrectionEvent(context, null, true, false)),
        child: BlocConsumer<CorrectionBloc, CorrectionState>(
          listener: (context, state) {
            if (state is FilterLoadedState) {
              employeeDropDownList = state.employeeDropDownList;
            }
          },
          buildWhen: (context, state) {
            return state is CorrectionLoadedState || state is ErrorState;
          },
          builder: (context, state) {
            if (state is CorrectionLoadedState) {
              _scrollController = ScrollController()
                ..addListener(loadMoreItems);
              correctionList = state.correctionList;

              return Column(
                children: [
                  Visibility(
                      visible: textVisiblity,
                      child: Container(
                        padding: const EdgeInsets.only(right: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: ColorCode.totalRequestColor
                                      .withAlpha(150)),
                              child: Text(
                                " ${CorrectionConstants.totalRequestLable}"
                                " : "
                                "${state.totalRequestCount} ",
                                // Total request count
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            CommonWidgets.horizontalSpace(5),
                            Container(
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: ColorCode.pendingApprovalColor
                                    .withAlpha(150),
                              ),
                              child: Text(
                                  " ${CorrectionConstants.approvalPendingLable}"
                                  " : "
                                  "${state.totalApprovedCount} ",
                                  // pending for approval request count
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      child: Stack(
                    children: [
                      NotificationListener<UserScrollNotification>(
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
                          physics: const BouncingScrollPhysics(),
                          controller: _scrollController,
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () => showUserDetailDialog(
                                  context, correctionList[index]),
                              // user Detail Diloug page Navigation
                              child: CommonWidgets.listViewTile(
                                  context: context,
                                  imagePath:
                                      "assets/images/other_image/profile_man.png",
                                  employeeName:
                                      '${state.correctionList[index].firstName}'
                                      '${state.correctionList[index].lastName}',
                                  centerFirstText: state
                                      .correctionList[index].requestType
                                      .toString(),
                                  rep1Status: state.correctionList[index].rep1Status
                                      .toString()
                                      .toLowerCase(),
                                  rep2Status: state.correctionList[index].rep2Status
                                      .toString()
                                      .toLowerCase(),
                                  finalStatus: CommonFunction.finalStatus(state
                                      .correctionList[index].finalStatus
                                      .toString()
                                      .toLowerCase()),
                                  rightFirstText: state.correctionList[index].startDate
                                      .toString(),
                                  rightSecondText: (CommonFunction.isNullOrIsEmpty(state.correctionList[index].inTime) ? "" : DateFormat("HH:mm").format(DateFormat("hh:mm a").parse(state.correctionList[index].inTime.toString()))) +
                                      (CommonFunction.isNullOrIsEmpty(state.correctionList[index].outTime) || CommonFunction.isNullOrIsEmpty(state.correctionList[index].inTime)
                                          ? ""
                                          : " - ") +
                                      (CommonFunction.isNullOrIsEmpty(state.correctionList[index].outTime)
                                          ? ""
                                          : DateFormat("HH:mm").format(DateFormat("hh:mm a")
                                              .parse(state.correctionList[index].outTime)))),
                              // Card(
                              //   elevation: 0.5,
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(10)),
                              //   child: SizedBox(
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceEvenly,
                              //       children: [
                              //         Expanded(
                              //             flex: 3,
                              //             child: Container(
                              //               alignment: Alignment.centerLeft,
                              //               padding: const EdgeInsets.only(
                              //                   left: 20, right: 40),
                              //               child: Column(
                              //                 children: [
                              //                   // CommonWidgets.profileImage(),
                              //                   //User profile Image
                              //                   SizedBox(
                              //                       width: 65,
                              //                       child: Tooltip(
                              //                           message: state
                              //                               .correctionList[
                              //                                   index]
                              //                               .employeeId,
                              //                           child: Text(
                              //                               '${state.correctionList[index].firstName}' // User first name
                              //                               "${state.correctionList[index].lastName}",
                              //                               // User last name
                              //                               overflow:
                              //                                   TextOverflow
                              //                                       .ellipsis,
                              //                               textAlign: TextAlign
                              //                                   .center)))
                              //                 ],
                              //               ),
                              //             )),
                              //         Expanded(
                              //             flex: 3,
                              //             child: Container(
                              //               padding: const EdgeInsets.only(
                              //                   right: 75),
                              //               child: Column(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.start,
                              //                 children: [
                              //                   punchingRequestId(state
                              //                       .correctionList[index]
                              //                       .requestType),
                              //                   // Correction Request type  shortForm (in / in-out/ out)
                              //                   CommonWidgets.verticalSpace(4),
                              //                   Row(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment.center,
                              //                     children: [
                              //                       // CommonFunction.statusIcon(
                              //                       //     state
                              //                       //         .correctionList[
                              //                       //             index]
                              //                       //         .rep1Status
                              //                       //         .toString()
                              //                       //         .toLowerCase()),
                              //                       // // manager approving status Indicator
                              //                       // CommonFunction.statusIcon(
                              //                       //     state
                              //                       //         .correctionList[
                              //                       //             index]
                              //                       //         .rep2Status
                              //                       //         .toString()
                              //                       //         .toLowerCase()),
                              //                       // Secondary manager approving status Indicator
                              //                       CommonFunction.finalStatus(
                              //                           state
                              //                               .correctionList[
                              //                                   index]
                              //                               .finalStatus
                              //                               .toString()
                              //                               .toLowerCase())
                              //                       // final approving status Indicator
                              //                     ],
                              //                   )
                              //                 ],
                              //               ),
                              //             )),
                              //         Expanded(
                              //             flex: 2,
                              //             child: SizedBox(
                              //               child: Column(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.start,
                              //                 children: [
                              //                   Text(state.correctionList[index]
                              //                       .startDate
                              //                       .toString()),
                              //                   // correction Request Date
                              //                   Text((CommonFunction.isNullOrIsEmpty(state.correctionList[index].inTime)
                              //                           ? ""
                              //                           : DateFormat("HH:mm").format(
                              //                               DateFormat("hh:mm a")
                              //                                   .parse(state
                              //                                       .correctionList[
                              //                                           index]
                              //                                       .inTime
                              //                                       .toString()))) +
                              //                       (CommonFunction.isNullOrIsEmpty(state.correctionList[index].outTime) || CommonFunction.isNullOrIsEmpty(state.correctionList[index].inTime)
                              //                           ? ""
                              //                           : " - ") +
                              //                       (CommonFunction.isNullOrIsEmpty(state.correctionList[index].outTime)
                              //                           ? ""
                              //                           : DateFormat("HH:mm").format(
                              //                               DateFormat("hh:mm a")
                              //                                   .parse(state.correctionList[index].outTime))))
                              //                   // correction time for punch in or out
                              //                 ],
                              //               ),
                              //             ))
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            );
                          },
                          itemCount: state.correctionList.length,
                        ),
                      ),
                    ],
                  ))
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
                        var filterdData = await showFilterDiloug(context,
                            employeeDropDownList, correctionFilterValue);
                        if (filterdData != null) {
                          correctionBloc.add(LoadCorrectionEvent(
                              context, filterdData, true, true));
                          correctionFilterValue = filterdData;
                        }
                      }),
                  SpeedDialChild(
                    child: const Icon(Icons.file_download_outlined),
                    label: 'Export',
                  )
                ],
              ))
        ],
      ),
    );
  }

  loadMoreItems() async {
    if ((_scrollController!.position.pixels).toInt() ==
        (_scrollController!.position.maxScrollExtent).toInt()) {
      if (correctionList.length < totalRequestCount) {
        correctionBloc.add(LoadCorrectionEvent(context, null, false, false));
      }
    }
  }
}
