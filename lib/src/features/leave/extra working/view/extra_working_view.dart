import 'package:emgage_flutter/src/commonWidgets/common_information_dialog.dart';
import 'package:emgage_flutter/src/features/leave/extra%20working/view/widgets/extra_working_request_dialog_box.dart';
import 'package:emgage_flutter/src/features/leave/extra%20working/view/widgets/filter_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../constants/leave/leave_constants.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/fetch_employee_detail.dart';
import '../bloc/extra_working_bloc.dart';
import '../model/extra_working_model.dart';
import '../../../../models/employee/EmployeedetailModel.dart';

class ExtraWorkingView extends StatelessWidget {
  ExtraWorkingBloc extraWorkingBloc = ExtraWorkingBloc();
  List<ExtraWorkingModel> extraWorkingModelList = [];
  bool bottomLoadingShow = false;
  ScrollController? _scrollController;
  int totalApprovalCount = 0;
  int totalRequestCount = 0;
  var filterData;
  List<DropdownMenuEntry> employeeDropdownMenuList = [];

  ExtraWorkingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LeaveConstants.extraWorkingLabel),
        actions: [
          IconButton(
              onPressed: () async {
                var data = await showFilterDialogBox(
                    context, employeeDropdownMenuList, filterData);
                if (data != null) {
                  filterData = data;
                  extraWorkingBloc.add(ExtraWokringLoadEvent(
                      context, true, false, true, filterData));
                }
              },
              icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: BlocProvider(
        create: (context) => extraWorkingBloc
          ..add(ExtraWokringLoadEvent(context, true, false, false, null)),
        child: BlocConsumer<ExtraWorkingBloc, ExtraWorkingState>(
          listener: (context, state) {
            if (state is ExtraWokringLoadState) {
              bottomLoadingShow = false;
              totalApprovalCount = state.totalApprovedCount;
              totalRequestCount = state.totalRequestCount;
              extraWorkingModelList = state.extraWorkingModelList;
              _scrollController ??= ScrollController()
                ..addListener(loadMoreItem);
            } else if (state is LoadingState) {
              bottomLoadingShow = true;
            } else if (state is FilterDataLoadState) {
              employeeDropdownMenuList = state.employeeDropdownMenuList;
            }
          },
          buildWhen: (context, state) =>
              state is ExtraWokringLoadState ||
              state is LoadingState ||
              state is ErrorState,
          builder: (context, state) {
            if (state is ExtraWokringLoadState || state is LoadingState) {
              return ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index < extraWorkingModelList.length) {
                    return GestureDetector(
                      onTap: () {
                        employeedetailModel employeeModel = employeedetailModel
                            .fromJson(FetchEmployeeDetail.employeeDetail![
                                extraWorkingModelList[index].employeeId]);
                        CommonInformationDialog.showInformationDialogBox(
                            context: context,
                            employeeId: employeeModel.employeeId.toString(),
                            employeeFirstName:
                                employeeModel.firstName.toString(),
                            employeeLastName: employeeModel.lastName.toString(),
                            reportingPerson1: employeeModel.reportingPerson,
                            reportingPerson2: employeeModel.reportingPerson1,
                            rep1Status: extraWorkingModelList[index].rep1Status,
                            rep2Status: extraWorkingModelList[index].rep2Status,
                            value: {
                              "Work Type":
                                  extraWorkingModelList[index].workType,
                              "Apply Date":
                                  extraWorkingModelList[index].startDate,
                              "Expiry Date":
                                  extraWorkingModelList[index].endDate,
                              "Time Range":
                                  "${extraWorkingModelList[index].inTime} - ${extraWorkingModelList[index].outTime}",
                              "Actual Hour/Day": CommonFunction.isNullOrIsEmpty(
                                      extraWorkingModelList[index].workType)
                                  ? ""
                                  : extraWorkingModelList[index].workType ==
                                          "Overtime"
                                      ? CommonFunction.isNullOrIsEmpty(
                                              extraWorkingModelList[index]
                                                  .extraWorkFinalStatusFinalOvertimeHours)
                                          ? ""
                                          : "${extraWorkingModelList[index].extraWorkFinalStatusFinalOvertimeHours}(H)"
                                      : CommonFunction.isNullOrIsEmpty(
                                              extraWorkingModelList[index]
                                                  .totalWorkedDays)
                                          ? ""
                                          : "${extraWorkingModelList[index].totalWorkedDays}(D)",
                              "Total Extra Hour Worked":
                                  extraWorkingModelList[index].totalWorked,
                              "Requested Date": extraWorkingModelList[index]
                                  .createdDateString,
                              "Reason":
                                  extraWorkingModelList[index].cancelReason
                            });
                      },
                      child: CommonWidgets.listViewTile(
                          context: context,
                          imagePath: "",
                          employeeName: CommonFunction.isNullOrIsEmpty(
                                  FetchEmployeeDetail.getEmployeeDetail())
                              ? ""
                              : CommonFunction.isNullOrIsEmpty(
                                      FetchEmployeeDetail.getEmployeeDetail()![
                                          extraWorkingModelList[index]
                                              .employeeId])
                                  ? ""
                                  : (employeedetailModel.fromJson(FetchEmployeeDetail.employeeDetail![extraWorkingModelList[index].employeeId]))
                                      .firstName
                                      .toString(),
                          centerFirstText:
                              extraWorkingModelList[index].workType.toString(),
                          rep1Status: extraWorkingModelList[index]
                              .rep1Status
                              .toString(),
                          rep2Status: extraWorkingModelList[index]
                              .rep2Status
                              .toString(),
                          finalStatus: CommonWidgets.finalStatusRGG(
                              extraWorkingModelList[index]
                                  .finalStatus
                                  .toString()),
                          rightFirstText:
                              "${extraWorkingModelList[index].inTime}-${extraWorkingModelList[index].outTime} (${extraWorkingModelList[index].totalWorked})",
                          rightSecondText: extraWorkingModelList[index]
                              .startDate
                              .toString()
                              .replaceAll("-", "/")),
                    );
                  } else {
                    return const Center(
                        child: SizedBox(
                            height: 40, child: CircularProgressIndicator()));
                  }
                },
                itemCount: bottomLoadingShow
                    ? extraWorkingModelList.length + 1
                    : extraWorkingModelList.length,
              );
            } else if (state is ErrorState) {
              return CommonWidgets.emptyAnimationWidget();
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var data = await showExtraWorkingRequestDialogBox(context);
          if (data != null) {}
        },
      ),
    );
  }

  loadMoreItem() {
    if (_scrollController!.hasClients) {
      if ((_scrollController!.position.pixels).toInt() ==
          (_scrollController!.position.maxScrollExtent).toInt()) {
        if (extraWorkingModelList.length < totalRequestCount) {
          extraWorkingBloc
              .add(ExtraWokringLoadEvent(null, false, true, false, null));
        }
      }
    }
  }
}
