part of 'leave_bloc.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();
}

class LoadLeaveRequestListEvent extends LeaveEvent {
  dynamic context;
  bool showLoadingView, bottomLodaingView, isReset;
  Map<String, String>? filterBody;

  LoadLeaveRequestListEvent(this.context, this.showLoadingView,
      this.bottomLodaingView, this.filterBody, this.isReset);

  @override
  List<Object?> get props =>
      [context, showLoadingView, bottomLodaingView, filterBody, isReset];
}

class LoadInitialDataEvent extends LeaveEvent {
  var context;
  String date;
  LoadInitialDataEvent(this.context, this.date);

  @override
  List<Object?> get props => [context, date];
}

class HalfDayLeaveCalculationEvent extends LeaveEvent {
  String date;
  int leaveDurationSelectType;
  String employeeId;
  HalfDayLeaveCalculationEvent(
      this.date, this.leaveDurationSelectType, this.employeeId);
  @override
  List<Object?> get props => [date, leaveDurationSelectType, employeeId];
}

class LeaveCodeSelectEvent extends LeaveEvent {
  LeaveCodeUserModel leaveCodeUserModelSelectValue;
  Map<String, String> userLeaveDaysData;

  LeaveCodeSelectEvent(
      this.leaveCodeUserModelSelectValue, this.userLeaveDaysData);

  @override
  List<Object?> get props => [leaveCodeUserModelSelectValue, userLeaveDaysData];
}

class SelectDateEvent extends LeaveEvent {
  LeaveCodeUserModel? leaveCodeUserModelSelectValue;
  String date;
  String employeeId;
  SelectDateEvent(
      this.leaveCodeUserModelSelectValue, this.date, this.employeeId);

  @override
  List<Object?> get props => [leaveCodeUserModelSelectValue, date, employeeId];
}

class FileUploadEvent extends LeaveEvent {
  @override
  List<Object?> get props => [];
}

class SelectEmployeeIdEvent extends LeaveEvent {
  String employeeId;
  String date;
  SelectEmployeeIdEvent(this.employeeId, this.date);
  @override
  List<Object?> get props => [employeeId, date];
}

class SubmitEvent extends LeaveEvent {
  var context;
  int leaveReasonSelecteType;
  List<String> leaveReasonTypeList;
  String? selectedEmployeeId;
  List<DropdownMenuEntry> employeeDropdownMenu;
  LeaveCodeUserModel? leaveCodeUserModel;
  String? leaveCodeText;
  bool maternityTypeDropdownShowFlag;
  String? maternityTypeDropdownSelectText;
  String? paternityMaternityText;
  bool extraWorkingDropdownShowFlag;
  ExtraWorkingModel? extraWorkingModel;
  String? extraWorkingText;
  bool otherReasonVisibilityFlag;
  String? otherReasonText;
  bool fileUploadShowFlag;
  bool fileUploadMandatoryFlag;
  String? fileContent;
  String? fileName;
  int leaveDurationSelectType;
  Map<String, String> userLeaveDaysData;
  String date;

  SubmitEvent(
      this.context,
      this.leaveReasonSelecteType,
      this.leaveReasonTypeList,
      this.employeeDropdownMenu,
      this.selectedEmployeeId,
      this.leaveCodeUserModel,
      this.leaveCodeText,
      this.maternityTypeDropdownShowFlag,
      this.maternityTypeDropdownSelectText,
      this.paternityMaternityText,
      this.extraWorkingDropdownShowFlag,
      this.extraWorkingModel,
      this.extraWorkingText,
      this.otherReasonVisibilityFlag,
      this.otherReasonText,
      this.fileUploadShowFlag,
      this.fileUploadMandatoryFlag,
      this.fileContent,
      this.fileName,
      this.leaveDurationSelectType,
      this.userLeaveDaysData,
      this.date);

  @override
  List<Object?> get props => [
        context,
        leaveReasonSelecteType,
        leaveReasonTypeList,
        employeeDropdownMenu,
        selectedEmployeeId,
        leaveCodeUserModel,
        leaveCodeText,
        maternityTypeDropdownShowFlag,
        maternityTypeDropdownSelectText,
        paternityMaternityText,
        extraWorkingDropdownShowFlag,
        extraWorkingModel,
        extraWorkingText,
        otherReasonVisibilityFlag,
        otherReasonText,
        fileUploadShowFlag,
        fileUploadMandatoryFlag,
        fileContent,
        fileName,
        leaveDurationSelectType,
        userLeaveDaysData,
        date
      ];
}

class ResetValueEvent extends LeaveEvent {
  List<DropdownMenuEntry> employeeDropdownMenuList;
  String employeeId;
  String date;
  ResetValueEvent(this.employeeDropdownMenuList, this.employeeId, this.date);
  @override
  List<Object?> get props => [employeeDropdownMenuList, employeeId, date];
}
