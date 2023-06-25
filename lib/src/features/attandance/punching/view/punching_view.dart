// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'dart:async';

import 'package:emgage_flutter/src/constants/attandence/punching_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../commonWidgets/logout_dialog.dart';
import '../../../../utils/common_functions.dart';
import '../../../homescreen/homescreen.dart';
import '../bloc/punching_bloc.dart';
import 'package:intl/intl.dart';

class Punching extends StatelessWidget {
  Punching({Key? key}) : super(key: key);

  var employeeName = "";
  var punchInOrOut = "PUNCH IN";
  var elapsedTime = 0;
  var punchInTime = "00:00";
  var punchOutTime;
  var outTimeText;
  var startClock = false;
  List userTrackerLocationDtoList = [];
  List punchingListModel = [];
  StreamController<bool> punchInOutTimerStreamController = StreamController();

  final punchingBloc = PunchingBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        // leading: appbar_icon_set(),
        actions: [
          IconButton(
            onPressed: () {
              logoutView(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        // automaticallyImplyLeading: false,
      ),
      drawer: const drawer(),
      body: BlocProvider(
        create: (context) =>
            punchingBloc..add(FetchDailyAttendanceDataEvent(context)),
        child: BlocConsumer<PunchingBloc, PunchingState>(
          listener: (context, state) {
            if (state is LoadDailyAttendanceDataState) {
              employeeName = state.employeeNameText;
              punchInOrOut = state.punchInOrOut;
              elapsedTime = state.elapsedTime;
              punchInTime = state.punchInTime;
              punchOutTime = state.punchOutTime;
              outTimeText = state.outTimeText;
              userTrackerLocationDtoList = state.userTrackerLocationDtoList;
              punchingListModel = state.punchingListModel;
              startClock = state.startClock;
              punchInOutTimerStreamController.add(true);
            } else if (state is PunchingActionState) {
              punchingBloc.add(FetchDailyAttendanceDataEvent(context));
            }
          },
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Text(
                          "Welcome".tr,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          " $employeeName",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: 130,
                              width: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                        child: Container(
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 125, 177, 221),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15),
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    bottomRight:
                                                        Radius.circular(15))),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                              ),
                                              onPressed: () async {
                                                punchingBloc.add(
                                                    PunchingLoadEvent(context));
                                              },
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      punchInOrOut,
                                                      style: const TextStyle(
                                                          fontSize: 25),
                                                    ),
                                                    StreamBuilder<bool>(
                                                        stream:
                                                            punchInOutTimerStreamController
                                                                .stream,
                                                        builder: (context,
                                                            snapshot) {
                                                          final displayTimer =
                                                              CommonFunction
                                                                  .transformSecondToHHmmss(
                                                                      elapsedTime);
                                                          if (snapshot.data ??
                                                              false) {
                                                            if (startClock) {
                                                              Timer(
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                                  () {
                                                                elapsedTime +=
                                                                    1;
                                                                punchInOutTimerStreamController
                                                                    .add(true);
                                                              });
                                                              return Text(
                                                                displayTimer,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            17),
                                                              );
                                                            } else {
                                                              return Text(
                                                                  displayTimer,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17));
                                                            }
                                                          } else {
                                                            return Text(
                                                                displayTimer,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            17));
                                                          }
                                                        }),
                                                  ]),
                                            )))
                                  ],
                                ),
                              ))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: punchInTime,
                                style: const TextStyle(fontSize: 25.0)),
                            const TextSpan(
                                text: "\nIn Time",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15.0)),
                          ])),
                          const SizedBox(
                            height: 7,
                          ),
                          Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: punchOutTime,
                                style: const TextStyle(fontSize: 25.0)),
                            TextSpan(
                                text: outTimeText,
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 15.0)),
                          ]))
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                      child: CommonFunction.isNullOrIsEmpty(
                                  userTrackerLocationDtoList) ||
                              userTrackerLocationDtoList.isEmpty
                          // start no punch found Lable If there is no Punch found  then show lable text
                          ? Text(PunchingConstants.noPunchFoundLable)
                          // end no punch lable text
                          //start multi punching data list
                          : DataTable(
                              columnSpacing: 25.0,
                              columns: [
                                DataColumn(
                                    label: Text(
                                  PunchingConstants.serialNoLable,
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  PunchingConstants.inTimeLable,
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  PunchingConstants.outTimeLable,
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  PunchingConstants.durationLable,
                                  textAlign: TextAlign.center,
                                ))
                              ],
                              rows: List.generate(punchingListModel.length,
                                  (index) {
                                return DataRow(cells: [
                                  DataCell(Text(
                                    '${punchingListModel.length - index}',
                                    textAlign: TextAlign.center,
                                  )),
                                  DataCell(SizedBox(
                                    width: 75,
                                    child: Text(
                                      punchingListModel[index].inTime,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    width: 75,
                                    child: Text(
                                      punchingListModel[index].outTime,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                                  DataCell(Text(
                                    punchingListModel[index].duration,
                                    textAlign: TextAlign.center,
                                  ))
                                ]);
                              }),
                            )),
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: 5),
                  //     child: GestureDetector(
                  //       onTap: ()async{
                  //         if(Platform.isAndroid){
                  //           WebViewWidget.fromPlatform(platform: Platformw)
                  //         }
                  //         WebViewController controller = WebViewController()
                  //           ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  //           ..setNavigationDelegate(
                  //             NavigationDelegate(
                  //               onProgress: (int progress) {
                  //                 // Update loading bar.
                  //               },
                  //               onPageStarted: (String url) {},
                  //               onPageFinished: (String url) {},
                  //               onWebResourceError: (WebResourceError error) {},
                  //               onNavigationRequest: (NavigationRequest request) {
                  //                 // print(request.url);
                  //                 return NavigationDecision.navigate;
                  //               },
                  //             ),
                  //           )
                  //           ..loadRequest(Uri.parse('https://www.google.com/'));
                  //         WebViewWidget(controller: controller,);
                  //         // await launchUrl(Uri.parse("https://ess.emgage.work"),
                  //       //   webViewConfiguration: WebViewConfiguration());
                  //       },
                  //         child: Text("ess.emgage.Work",style: TextStyle(color: Colors.blueAccent),)))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

multiPunchingDataList(userTracker) {
  return !CommonFunction.isNullOrIsEmpty(userTracker) &&
          !CommonFunction.isNullOrIsEmpty(userTracker['dateString'])
      ? DateFormat('hh:mm a').format(
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(userTracker['dateString']))
      : " ";
}
