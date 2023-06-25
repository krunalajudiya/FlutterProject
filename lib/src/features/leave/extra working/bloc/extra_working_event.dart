part of 'extra_working_bloc.dart';

abstract class ExtraWorkingEvent extends Equatable {
  const ExtraWorkingEvent();
}

class ExtraWokringLoadEvent extends ExtraWorkingEvent {
  var context;
  bool showLoadingView, bottomLodaingView, isReset;
  Map<String, dynamic>? filterBody;

  ExtraWokringLoadEvent(this.context, this.showLoadingView,
      this.bottomLodaingView, this.isReset, this.filterBody);

  @override
  List<Object?> get props =>
      [context, showLoadingView, bottomLodaingView, isReset, filterBody];
}

class LoadInitialDataEvent extends ExtraWorkingEvent {
  String date;
  LoadInitialDataEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class ChangeValueEvent extends ExtraWorkingEvent {
  String date;
  String? employeeId;
  ChangeValueEvent(this.date, this.employeeId);

  @override
  List<Object?> get props => [date, employeeId];
}

class ResetEvent extends ExtraWorkingEvent {
  @override
  List<Object?> get props => [];
}

class SubmitEvent extends ExtraWorkingEvent {
  var context;
  List<DropdownMenuEntry> employeeDropdownMenuList;
  String? employeeId;
  String workFromtime, workToTime;
  String date;
  String? reason;
  bool otherReasonVisibilityFlag;

  SubmitEvent(
    this.context,
    this.employeeId,
    this.workFromtime,
    this.workToTime,
    this.date,
    this.reason,
    this.otherReasonVisibilityFlag,
    this.employeeDropdownMenuList,
  );
  @override
  List<Object?> get props => [
        context,
        employeeId,
        workFromtime,
        workToTime,
        date,
        reason,
        employeeDropdownMenuList
      ];
}
