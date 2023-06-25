part of 'payslip_bloc.dart';

abstract class PayslipState extends Equatable {
  const PayslipState();
}

class PayslipInitial extends PayslipState {
  @override
  List<Object> get props => [];
}

class LoadInitialDataState extends PayslipState {
  List<DropdownMenuEntry> employeeDropdownList;
  LoadInitialDataState(this.employeeDropdownList);
  @override
  List<Object> get props => [employeeDropdownList];
}

class SelectPayslipTypeState extends PayslipState {
  List<Widget> datePickerTextBox;
  SelectPayslipTypeState(this.datePickerTextBox);
  @override
  List<Object> get props => [datePickerTextBox];
}

class DownloadPayslipState extends PayslipState {
  @override
  List<Object> get props => [];
}
