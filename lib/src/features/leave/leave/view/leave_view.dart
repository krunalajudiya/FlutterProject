import 'dart:async';

import 'package:emgage_flutter/src/commonWidgets/common_information_dialog.dart';
import 'package:emgage_flutter/src/features/leave/leave/view/widgets/leave_request_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../commonWidgets/common_widgets.dart';
import '../../../../constants/leave/leave_constants.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/fetch_employee_detail.dart';
import '../bloc/leave_bloc.dart';
import '../../../../models/employee/EmployeedetailModel.dart';
import '../model/leave_model.dart';
import 'widgets/filter_dialog_box.dart';

class LeaveView extends StatelessWidget {
  List<LeaveModel>? leaveModelList;
  int totalApprovalCount = 0;
  int totalRequestCount = 0;

  bool bottomLoadingShow = false;

  //this flag is use for single time calling event
  bool loadMoreItemFlag = true;
  int leaveModelListLength = 0;
  ScrollController? _scrollController;
  LeaveBloc leaveBloc = LeaveBloc();
  StreamController<bool> requestCountShowStreamController = StreamController();
  List<DropdownMenuEntry> employeeDropdownList = [];
  List<DropdownMenuEntry> leaveCodeDropdownList = [];
  var filterData;

  LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(LeaveConstants.leaveLabel.tr),
        actions: [
          IconButton(
              onPressed: () async {
                var data = await showFilterDialogBox(context,
                    employeeDropdownList, leaveCodeDropdownList, filterData);
                if (data != null) {
                  filterData = data;
                  leaveBloc.add(LoadLeaveRequestListEvent(
                      context, true, false, filterData, true));
                }
              },
              icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: BlocProvider(
        create: (context) => leaveBloc
          ..add(LoadLeaveRequestListEvent(context, true, false, null, false)),
        child: BlocConsumer<LeaveBloc, LeaveState>(
          listener: (context, state) {
            if (state is LoadLeaveRequestListState) {
              bottomLoadingShow = false;
              loadMoreItemFlag = true;
              totalRequestCount = state.totalRequestCount;
              totalApprovalCount = state.totalApprovedCount;
              leaveModelList = state.leaveModelList;
              _scrollController = ScrollController()..addListener(loadMoreItem);
            } else if (state is LoadingState) {
              bottomLoadingShow = true;
            } else if (state is FilterDataLoadState) {
              employeeDropdownList = state.employeeDropdownList;
              leaveCodeDropdownList = state.leaveCodeDropdownList;
            }
          },
          buildWhen: (context, state) =>
              state is LoadLeaveRequestListState || state is LoadingState,
          builder: (context, state) {
            if (state is LoadLeaveRequestListState || state is LoadingState) {
              return Stack(
                children: [
                  NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      if (notification.direction == ScrollDirection.forward) {
                        requestCountShowStreamController.add(true);
                      } else if (notification.direction ==
                          ScrollDirection.reverse) {
                        requestCountShowStreamController.add(false);
                      }
                      return true;
                    },
                    child: Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController!,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (BuildContext context, int index) {
                          if (index < leaveModelList!.length) {
                            return GestureDetector(
                              onTap: () {
                                employeedetailModel employeeModel =
                                    employeedetailModel.fromJson(
                                        FetchEmployeeDetail.employeeDetail![
                                            leaveModelList![index].employeeId]);
                                CommonInformationDialog
                                    .showInformationDialogBox(
                                        context: context,
                                        employeeId:
                                            employeeModel.employeeId.toString(),
                                        employeeFirstName:
                                            employeeModel.firstName.toString(),
                                        employeeLastName:
                                            employeeModel.lastName.toString(),
                                        reportingPerson1:
                                            employeeModel.reportingPerson,
                                        reportingPerson2:
                                            employeeModel.reportingPerson1,
                                        rep1Status:
                                            leaveModelList![index].rep1Status,
                                        rep2Status:
                                            leaveModelList![index].rep2Status,
                                        value: {
                                      LeaveConstants
                                          .dateLabel: leaveModelList![index]
                                                  .startDate ==
                                              leaveModelList![index].endDate
                                          ? leaveModelList![index].startDate
                                          : "${leaveModelList![index].startDate} - ${leaveModelList![index].endDate}",
                                      LeaveConstants.leaveCodeLabel:
                                          leaveModelList![index]
                                              .leaveCode
                                              .toString(),
                                      LeaveConstants.requestDateLabel:
                                          CommonFunction.dateFormat(
                                              leaveModelList![index]
                                                  .createdDate
                                                  .toString(),
                                              "yyyy-MM-dd",
                                              "dd-MM-yyyy"),
                                      LeaveConstants.reasonLabel:
                                          leaveModelList![index]
                                              .cancelReason
                                              .toString()
                                    });
                              },
                              child: CommonWidgets.listViewTile(
                                  context: context,
                                  imagePath: CommonFunction.isNullOrIsEmpty(
                                          FetchEmployeeDetail
                                              .getEmployeeDetail())
                                      ? ""
                                      : CommonFunction.isNullOrIsEmpty(
                                              FetchEmployeeDetail.getEmployeeDetail()![
                                                  leaveModelList![index]
                                                      .employeeId])
                                          ? ""
                                          : (employeedetailModel.fromJson(
                                                  FetchEmployeeDetail
                                                          .employeeDetail![
                                                      leaveModelList![index]
                                                          .employeeId]))
                                              .photo
                                              .toString(),
                                  employeeName: CommonFunction.isNullOrIsEmpty(
                                          FetchEmployeeDetail.getEmployeeDetail())
                                      ? ""
                                      : CommonFunction.isNullOrIsEmpty(FetchEmployeeDetail.getEmployeeDetail()![leaveModelList![index].employeeId])
                                          ? ""
                                          : (employeedetailModel.fromJson(FetchEmployeeDetail.employeeDetail![leaveModelList![index].employeeId])).firstName.toString(),
                                  centerFirstText: leaveModelList![index].leaveCode.toString(),
                                  rep1Status: leaveModelList![index].rep1Status.toString(),
                                  rep2Status: leaveModelList![index].rep2Status.toString(),
                                  finalStatus: CommonWidgets.finalStatusRGG(leaveModelList![index].finalStatus.toString()),
                                  rightFirstText: leaveModelList![index].startDate!.compareTo(leaveModelList![index].endDate!) == 0 ? leaveModelList![index].startDate.toString() : "${leaveModelList![index].startDate} - ${leaveModelList![index].endDate}",
                                  rightSecondText: leaveModelList![index].typeDuration.toString()),
                            );
                          } else {
                            return const Center(
                                child: SizedBox(
                                    height: 40,
                                    child: CircularProgressIndicator()));
                          }
                        },
                        itemCount: bottomLoadingShow
                            ? leaveModelList!.length + 1
                            : leaveModelList!.length,
                      ),
                    ),
                  ),
                  StreamBuilder<bool>(
                      stream: requestCountShowStreamController.stream,
                      builder: (context, snapshot) {
                        return Visibility(
                          visible: snapshot.data ?? true,
                          child: CommonWidgets.totalReqAndPendingAppro(
                              totalRequestCount.toString(),
                              totalApprovalCount.toString()),
                        );
                      }),
                ],
              );
            } else {
              return CommonWidgets.emptyAnimationWidget();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var data = await showLeaveRequestDialogBox(context);
          if (!CommonFunction.isNullOrIsEmpty(data) && data) {
            leaveBloc.add(
                LoadLeaveRequestListEvent(context, true, false, null, true));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  loadMoreItem() {
    if (_scrollController!.hasClients) {
      if ((_scrollController!.position.pixels).toInt() ==
          (_scrollController!.position.maxScrollExtent).toInt()) {
        if (leaveModelListLength < totalRequestCount && loadMoreItemFlag) {
          loadMoreItemFlag = false;
          leaveBloc
              .add(LoadLeaveRequestListEvent(null, false, true, null, false));
        }
      }
    }
  }
}
