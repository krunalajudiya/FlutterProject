import 'dart:async';

import 'package:emgage_flutter/src/constants/document/document_constants.dart';
import 'package:emgage_flutter/src/features/documents/payslip/model/payslip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../constants/image_path.dart';
import '../../../../utils/common_functions.dart';
import '../bloc/payslip_bloc.dart';

class Payslip extends StatelessWidget {
  int payslipSelecteType = 0;
  List<PayslipModel>? payslipModelList;
  final firstDateTextEditingController = TextEditingController();
  final secondDateTextEditingController = TextEditingController();
  String employeeId = "";
  List<DropdownMenuEntry> employeeDropdownList = [];
  StreamController<bool> pdfShowStreamController = StreamController();
  final payslipBloc = PayslipBloc();

  Payslip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(DocumentConstants.payslipLabel.tr),
      ),
      body: BlocProvider(
        create: (context) =>
            payslipBloc..add(LoadInitialDataEvent(context, "")),
        child: BlocConsumer<PayslipBloc, PayslipState>(
          listener: (context, state) {
            if (state is LoadInitialDataState) {
              employeeDropdownList = state.employeeDropdownList;
              payslipBloc.add(SelectPayslipTypeEvent(
                  context,
                  payslipSelecteType,
                  firstDateTextEditingController,
                  secondDateTextEditingController,
                  pdfShowStreamController));
            }
          },
          buildWhen: (context, state) =>
              state is SelectPayslipTypeState || state is LoadInitialDataState,
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: employeeDropdownList.isNotEmpty,
                          child: DropdownMenu(
                            width: MediaQuery.of(context).size.width - 20,
                            dropdownMenuEntries: employeeDropdownList,
                            menuHeight: 200,
                            enableFilter: true,
                            label: Text(
                              DocumentConstants.employeeLabel.tr,
                            ),
                            onSelected: (value) async {
                              FocusScope.of(context).unfocus();
                              firstDateTextEditingController.clear();
                              secondDateTextEditingController.clear();
                              payslipBloc
                                  .add(LoadInitialDataEvent(context, value));
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ChoiceChip(
                                elevation: 2,
                                label: Text(DocumentConstants.payslipLabel.tr),
                                selected: payslipSelecteType == 0,
                                onSelected: (bool value) {
                                  payslipSelecteType = 0;
                                  payslipBloc.add(SelectPayslipTypeEvent(
                                      context,
                                      payslipSelecteType,
                                      firstDateTextEditingController,
                                      secondDateTextEditingController,
                                      pdfShowStreamController));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ChoiceChip(
                                elevation: 2,
                                label: Text(DocumentConstants
                                    .cumulativePayslipLabel.tr),
                                selected: payslipSelecteType == 1,
                                onSelected: (bool value) {
                                  payslipSelecteType = 1;
                                  payslipBloc.add(SelectPayslipTypeEvent(
                                      context,
                                      payslipSelecteType,
                                      firstDateTextEditingController,
                                      secondDateTextEditingController,
                                      pdfShowStreamController));
                                },
                              ),
                            )
                          ],
                        ),
                        Column(
                            children: state is SelectPayslipTypeState
                                ? state.datePickerTextBox
                                : []),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<bool>(
                        stream: pdfShowStreamController.stream,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: (payslipSelecteType == 0 &&
                                        !CommonFunction.isNullOrIsEmpty(
                                            firstDateTextEditingController
                                                .text)) ||
                                    (payslipSelecteType == 1 &&
                                        !CommonFunction.isNullOrIsEmpty(
                                            firstDateTextEditingController
                                                .text) &&
                                        !CommonFunction.isNullOrIsEmpty(
                                            secondDateTextEditingController
                                                .text))
                                ? true
                                : false,
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                      height: 200,
                                      width: 300,
                                      ImagePath.pdfFile),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            payslipBloc.add(DownloadPayslipEvent(
                                                context,
                                                false,
                                                payslipSelecteType,
                                                firstDateTextEditingController,
                                                secondDateTextEditingController));
                                          },
                                          child: Text(DocumentConstants
                                              .downloadLabel.tr)),
                                      // const SizedBox(
                                      //   width: 20,
                                      // ),
                                      // ElevatedButton(
                                      //     onPressed: () async {
                                      //       // await validate(true);
                                      //     },
                                      //     child: Text(DocumentConstants.viewLabel.tr))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
