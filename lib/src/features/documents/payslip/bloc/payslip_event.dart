part of 'payslip_bloc.dart';

abstract class PayslipEvent extends Equatable {
  const PayslipEvent();
}

class LoadInitialDataEvent extends PayslipEvent {
  BuildContext context;
  String selectEmployeeId;
  LoadInitialDataEvent(this.context, this.selectEmployeeId);
  @override
  List<Object?> get props => [context];
}

class SelectPayslipTypeEvent extends PayslipEvent {
  BuildContext context;
  int payslipSelecteType;
  TextEditingController firstDateTextEditingController,
      secondDateTextEditingController;
  StreamController<bool> pdfShowStreamController;
  SelectPayslipTypeEvent(
      this.context,
      this.payslipSelecteType,
      this.firstDateTextEditingController,
      this.secondDateTextEditingController,
      this.pdfShowStreamController);
  @override
  List<Object?> get props => [
        context,
        payslipSelecteType,
        firstDateTextEditingController,
        secondDateTextEditingController
      ];
}

class DownloadPayslipEvent extends PayslipEvent {
  var context;
  bool viewPdf;
  int payslipSelecteType;
  TextEditingController firstDateTextEditingController,
      secondDateTextEditingController;
  DownloadPayslipEvent(
      this.context,
      this.viewPdf,
      this.payslipSelecteType,
      this.firstDateTextEditingController,
      this.secondDateTextEditingController);
  @override
  List<Object?> get props => [
        payslipSelecteType,
        firstDateTextEditingController,
        secondDateTextEditingController
      ];
}
