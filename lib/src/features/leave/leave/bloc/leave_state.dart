part of 'leave_bloc.dart';

abstract class LeaveState extends Equatable {
  const LeaveState();
}

class LeaveInitial extends LeaveState {
  @override
  List<Object> get props => [];
}

class LoadLeaveRequestListState extends LeaveState {
  int totalRequestCount, totalApprovedCount;
  List<LeaveModel> leaveModelList;

  LoadLeaveRequestListState(
      this.totalRequestCount, this.totalApprovedCount, this.leaveModelList);

  @override
  List<Object> get props =>
      [totalRequestCount, totalApprovedCount, leaveModelList];
}

class LoadingState extends LeaveState {
  @override
  List<Object> get props => [];
}

class FilterDataLoadState extends LeaveState {
  List<DropdownMenuEntry> employeeDropdownList;
  List<DropdownMenuEntry> leaveCodeDropdownList;

  FilterDataLoadState(this.employeeDropdownList, this.leaveCodeDropdownList);

  @override
  List<Object> get props => [employeeDropdownList, leaveCodeDropdownList];
}

class LoadInitialDataState extends LeaveState {
  String employeeId;
  List<DropdownMenuEntry> leaveCodeDropdownMenuList;
  List<DropdownMenuEntry> extraWorkingDropdownMenuList;
  Map<String, String> userLeaveDaysData;
  List<LeaveCodeUserModel> leaveCodeUserModelList;
  List<ExtraWorkingModel> extraWorkingModelList;

  LoadInitialDataState(
      this.employeeId,
      this.leaveCodeDropdownMenuList,
      this.extraWorkingDropdownMenuList,
      this.userLeaveDaysData,
      this.leaveCodeUserModelList,
      this.extraWorkingModelList);

  @override
  List<Object> get props => [
        employeeId,
        leaveCodeDropdownMenuList,
        extraWorkingDropdownMenuList,
        userLeaveDaysData,
        leaveCodeUserModelList,
        extraWorkingModelList
      ];
}

class HalfDayLeaveCalculationState extends LeaveState {
  Map<String, String> userLeaveDaysData;

  HalfDayLeaveCalculationState(this.userLeaveDaysData);

  @override
  List<Object> get props => [userLeaveDaysData];
}

class LeaveCodeSelectState extends LeaveState {
  bool fileUploadShowFlag,
      fileUploadMandatoryFlag,
      extraWorkingDropdownShowFlag,
      maternityTypeDropdownShowFlag;

  LeaveCodeSelectState(this.fileUploadShowFlag, this.fileUploadMandatoryFlag,
      this.extraWorkingDropdownShowFlag, this.maternityTypeDropdownShowFlag);

  @override
  List<Object> get props => [
        fileUploadShowFlag,
        fileUploadMandatoryFlag,
        extraWorkingDropdownShowFlag,
        maternityTypeDropdownShowFlag
      ];
}

class SelectDateState extends LeaveState {
  bool fileUploadShowFlag, fileUploadMandatoryFlag;
  Map<String, String> userLeaveDaysData;

  SelectDateState(this.fileUploadShowFlag, this.fileUploadMandatoryFlag,
      this.userLeaveDaysData);

  @override
  List<Object> get props =>
      [fileUploadShowFlag, fileUploadMandatoryFlag, userLeaveDaysData];
}

class FileUploadState extends LeaveState {
  String fileName, fileBase64;

  FileUploadState(this.fileName, this.fileBase64);

  @override
  List<Object> get props => [fileName, fileBase64];
}

class EmployeeListState extends LeaveState {
  List<DropdownMenuEntry> employeeDropdownMenuList;
  EmployeeListState(this.employeeDropdownMenuList);
  @override
  List<Object> get props => [employeeDropdownMenuList];
}

class SubmitState extends LeaveState {
  @override
  List<Object> get props => [];
}

class ResetValueState extends LeaveState {
  Map<String, String> userLeaveDaysData;
  ResetValueState(this.userLeaveDaysData);
  @override
  List<Object> get props => [userLeaveDaysData];
}

class ValidateErrorState extends LeaveState {
  var reasonText,
      employeeErrorStatus,
      leaveCodeErrorStatus,
      paternityMaternityErrorStatus,
      extraWorkingErrorStatus,
      fileUploadErrorStatus;

  ValidateErrorState(
      this.reasonText,
      this.employeeErrorStatus,
      this.leaveCodeErrorStatus,
      this.paternityMaternityErrorStatus,
      this.extraWorkingErrorStatus,
      this.fileUploadErrorStatus);

  @override
  List<Object> get props => [
        reasonText,
        employeeErrorStatus,
        leaveCodeErrorStatus,
        paternityMaternityErrorStatus,
        extraWorkingErrorStatus,
        fileUploadErrorStatus
      ];
}
