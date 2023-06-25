import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/common_functions.dart';

class DatePickerTextbox {
  static List<Widget> datePickerTextboxShow(
      context,
      payslipModelList,
      payslipSelecteType,
      firstDateTextEditingController,
      secondDateTextEditingController,
      pdfShowStreamController) {
    List<Widget> listWidgets = [];
    if (!CommonFunction.isNullOrIsEmpty(payslipModelList) &&
        payslipModelList.isNotEmpty) {
      if (payslipSelecteType == 0) {
        listWidgets.add(Row(
          children: [
            Expanded(
              child: TextField(
                  controller: firstDateTextEditingController,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Date",
                  ),
                  readOnly: true,
                  onTap: () async {
                    var pickedDate = await datePickerDialog(
                        context,
                        DateTime(payslipModelList[0].year!.toInt(),
                            payslipModelList[0].month!.toInt()),
                        DateTime(
                            payslipModelList[payslipModelList.length - 1]
                                .year!
                                .toInt(),
                            payslipModelList[payslipModelList.length - 1]
                                .month!
                                .toInt()));
                    if (pickedDate != null) {
                      firstDateTextEditingController!.text =
                          DateFormat('yyyy-MM').format(pickedDate);
                      pdfShowStreamController.add(true);
                    }
                  }),
            ),
          ],
        ));
        return listWidgets;
      } else if (payslipSelecteType == 1) {
        listWidgets.add(Row(
          children: [
            Expanded(
              child: TextField(
                  controller: firstDateTextEditingController,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "From Date",
                  ),
                  readOnly: true,
                  onTap: () async {
                    var pickedDate = await datePickerDialog(
                        context,
                        DateTime(payslipModelList[0].year!.toInt(),
                            payslipModelList[0].month!.toInt()),
                        DateTime(
                            payslipModelList[payslipModelList.length - 1]
                                .year!
                                .toInt(),
                            payslipModelList[payslipModelList.length - 1]
                                .month!
                                .toInt()));
                    if (pickedDate != null) {
                      firstDateTextEditingController.text =
                          DateFormat('yyyy-MM').format(pickedDate);
                      pdfShowStreamController.add(true);
                    }
                  }),
            ),
          ],
        ));
        listWidgets.add(const SizedBox(
          height: 10,
        ));
        listWidgets.add(Row(
          children: [
            Expanded(
              child: TextField(
                  controller: secondDateTextEditingController,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "To Date",
                  ),
                  readOnly: true,
                  onTap: () async {
                    if (firstDateTextEditingController != null) {
                      var pickedDate = await datePickerDialog(
                          context,
                          DateTime(
                              int.parse(DateFormat("yyyy").format(
                                  DateFormat("yyyy-MM").parse(
                                      firstDateTextEditingController!.text))),
                              int.parse(DateFormat("MM").format(
                                  DateFormat("yyyy-MM").parse(
                                      firstDateTextEditingController!.text)))),
                          DateTime(
                              payslipModelList[payslipModelList.length - 1]
                                  .year!
                                  .toInt(),
                              payslipModelList[payslipModelList.length - 1]
                                  .month!
                                  .toInt()));
                      if (pickedDate != null) {
                        secondDateTextEditingController.text =
                            DateFormat('yyyy-MM').format(pickedDate);
                        pdfShowStreamController.add(true);
                      }
                    }
                  }),
            ),
          ],
        ));
      }
    }
    return listWidgets;
  }

  static Future<DateTime?> datePickerDialog(
      context, DateTime firstDate, DateTime lastDate) async {
    DateTime? pickedDate = await showMonthPicker(
      context: context,
      initialDate: lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    return pickedDate;
  }
}
