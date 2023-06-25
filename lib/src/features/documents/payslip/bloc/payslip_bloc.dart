import 'dart:async';
import 'dart:io';

import 'package:emgage_flutter/src/features/documents/payslip/api/api.dart';
import 'package:emgage_flutter/src/features/documents/payslip/view/widgets/date_picker_textbox.dart';
import 'package:emgage_flutter/src/utils/download_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/urls.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/pdf_viewer_page.dart';
import '../../../../utils/sharedpreferences_utils.dart';
import '../model/payslip_model.dart';

part 'payslip_event.dart';
part 'payslip_state.dart';

class PayslipBloc extends Bloc<PayslipEvent, PayslipState> {
  List<DropdownMenuEntry>? employeeDropdownList;
  String employeeId = "";
  List<PayslipModel> payslipModelList = [];
  PayslipBloc() : super(PayslipInitial()) {
    on<LoadInitialDataEvent>((event, emit) async {
      employeeDropdownList =
          await CommonFunction.getChildEmployeeDropdownList();
      if (employeeDropdownList!.isEmpty) {
        employeeId = await SharedpreferencesUtils.getEmployeeId();
        var data = await Api.getPayslipDataApi(event.context, employeeId);
        data.forEach(
            (value) => payslipModelList.add(PayslipModel.fromJson(value)));
      } else if (!CommonFunction.isNullOrIsEmpty(event.selectEmployeeId)) {
        employeeId = event.selectEmployeeId;
        var data = await Api.getPayslipDataApi(event.context, employeeId);
        data.forEach(
            (value) => payslipModelList.add(PayslipModel.fromJson(value)));
      }
      emit(LoadInitialDataState(employeeDropdownList!));
    });

    on<SelectPayslipTypeEvent>((event, emit) async {
      List<Widget> datePickerTextBox = DatePickerTextbox.datePickerTextboxShow(
          event.context,
          payslipModelList,
          event.payslipSelecteType,
          event.firstDateTextEditingController,
          event.secondDateTextEditingController,
          event.pdfShowStreamController);
      emit(SelectPayslipTypeState(datePickerTextBox));
    });

    on<DownloadPayslipEvent>((event, emit) async {
      if (await CommonFunction.checkStoragePermission()) {
        if (event.payslipSelecteType == 0 &&
            !CommonFunction.isNullOrIsEmpty(
                event.firstDateTextEditingController.text)) {
          await getPayslipDownloadData(event.context, event.viewPdf,
              event.firstDateTextEditingController);
        } else {
          if (event.payslipSelecteType == 1 &&
              !CommonFunction.isNullOrIsEmpty(
                  event.firstDateTextEditingController.text) &&
              !CommonFunction.isNullOrIsEmpty(
                  event.secondDateTextEditingController.text)) {
            getCumulativePayslipDownloadData(
                event.context,
                event.viewPdf,
                event.firstDateTextEditingController,
                event.secondDateTextEditingController);
          }
        }
      }
    });
  }
  getPayslipDownloadData(
      context, viewPdf, firstDateTextEditingController) async {
    Map<String, String> body = {};

    body["empId"] = employeeId;
    body["year"] = DateFormat("yyyy").format(
        DateFormat("yyyy-MM").parse(firstDateTextEditingController.text));
    body["month"] = DateFormat("MM").format(
        DateFormat("yyyy-MM").parse(firstDateTextEditingController.text));
    var data = await Api.getPayslipDownloadDataApi(context, body);
    if (!CommonFunction.isNullOrIsEmpty(data) && data) {
      var fileName =
          "${employeeId}_${(DateFormat("MM").format(DateFormat("yyyy-MM").parse(firstDateTextEditingController.text))).replaceAll(RegExp(r'^0+(?=.)'), '')}_${DateFormat("yyyy").format(DateFormat("yyyy-MM").parse(firstDateTextEditingController.text))}.pdf";
      var url = Urls.baseUrl.replaceAll("api", "salarySlips") + fileName;
      if (viewPdf) {
        await viewPdf(url);
      } else {
        var filePath = await DownloadUtils.downloadPdfFile(
            url, fileName, Constants.downloadFilePath);
        if (!CommonFunction.isNullOrIsEmpty(filePath)) {
          CommonFunction.showToastMsg(filePath);
          openPDF(context, File(filePath), filePath.split("/").last);
        }
      }
    }
  }

  getCumulativePayslipDownloadData(context, viewPdf,
      firstDateTextEditingController, secondDateTextEditingController) async {
    Map<String, String> body = {};
    body["empId"] = employeeId;
    body["fromMonthAndYear"] =
        "${DateFormat("MMMM").format(DateFormat("yyyy-MM").parse(firstDateTextEditingController.text))}-${DateFormat("yyyy").format(DateFormat("yyyy-MM").parse(firstDateTextEditingController.text))}";
    body["toMonthAndYear"] =
        "${DateFormat("MMMM").format(DateFormat("yyyy-MM").parse(secondDateTextEditingController.text))}-${DateFormat("yyyy").format(DateFormat("yyyy-MM").parse(secondDateTextEditingController.text))}";
    var data = await Api.getCumulativePayslipDownloadDataApi(context, body);
    if (!CommonFunction.isNullOrIsEmpty(data) && data) {
      var url =
          "${Urls.baseUrl.replaceAll("api", "salarySlips")}${employeeId}_cumulative.pdf";
      if (viewPdf) {
        viewPdf(url);
      } else {
        var filePath = await DownloadUtils.downloadPdfFile(
            url,
            "${firstDateTextEditingController.text}To${secondDateTextEditingController.text}_$employeeId.pdf",
            Constants.downloadFilePath);
        if (!CommonFunction.isNullOrIsEmpty(filePath)) {
          CommonFunction.showToastMsg(filePath);
          openPDF(context, File(filePath), filePath.split("/").last);
        }
      }
    }
  }

  viewPdf(url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void openPDF(BuildContext context, File file, fileName) =>
      CommonFunction.pageRoute(
          context, PDFViewerPage(file: file, fileName: fileName));
}
