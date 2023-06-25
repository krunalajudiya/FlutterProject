part of 'extra_working_bloc.dart';

abstract class ExtraWorkingState extends Equatable {
  const ExtraWorkingState();
}

class ExtraWorkingInitial extends ExtraWorkingState {
  @override
  List<Object> get props => [];
}

class ExtraWokringLoadState extends ExtraWorkingState {
  int totalRequestCount, totalApprovedCount;
  List<ExtraWorkingModel> extraWorkingModelList;
  ExtraWokringLoadState(this.extraWorkingModelList, this.totalRequestCount,
      this.totalApprovedCount);
  @override
  List<Object> get props =>
      [extraWorkingModelList, totalRequestCount, totalApprovedCount];
}

class LoadingState extends ExtraWorkingState {
  @override
  List<Object> get props => [];
}

class FilterDataLoadState extends ExtraWorkingState {
  List<DropdownMenuEntry> employeeDropdownMenuList;
  FilterDataLoadState(this.employeeDropdownMenuList);
  @override
  List<Object> get props => [employeeDropdownMenuList];
}

class LoadInitialDataState extends ExtraWorkingState {
  List<DropdownMenuEntry> employeeDropdownMenuList;
  Map<String, dynamic> userShiftData;
  var employeeId;
  LoadInitialDataState(
      this.userShiftData, this.employeeId, this.employeeDropdownMenuList);
  @override
  List<Object> get props =>
      [userShiftData, employeeId, employeeDropdownMenuList];
}

class ChangeValueState extends ExtraWorkingState {
  Map<String, dynamic> userShiftData;
  ChangeValueState(this.userShiftData);
  @override
  List<Object> get props => [userShiftData];
}

class ValidateErrorState extends ExtraWorkingState {
  var employeeErrorStatus, reasonErrorStatus;
  ValidateErrorState(this.employeeErrorStatus, this.reasonErrorStatus);
  @override
  List<Object> get props => [employeeErrorStatus, reasonErrorStatus];
}

class SubmitState extends ExtraWorkingState {
  @override
  List<Object> get props => [];
}

class ResetState extends ExtraWorkingState {
  @override
  List<Object> get props => [];
}

class ErrorState extends ExtraWorkingState {
  String errorText;
  ErrorState(this.errorText);
  @override
  List<Object> get props => [errorText];
}
