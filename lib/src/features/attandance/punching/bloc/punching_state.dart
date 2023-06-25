// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

part of 'punching_bloc.dart';

abstract class PunchingState extends Equatable {
  const PunchingState();
}

class PunchingInitial extends PunchingState {
  @override
  List<Object> get props => [];
}

class PunchingActionState extends PunchingState {
  @override
  List<Object> get props => [];
}

class LoadDailyAttendanceDataState extends PunchingState {
  var dailyAttendance,
      punchInOrOut,
      imageSrcData,
      elapsedTime,
      mobilePunchInImage,
      mobilePunchOutImage,
      punchInTime,
      punchOutTime,
      outTimeText,
      employeeNameText,
      startClock;

  Position? currentPosition;
  List userTrackerLocationDtoList;
  List punchingListModel;

  LoadDailyAttendanceDataState(
      this.dailyAttendance,
      this.punchInOrOut,
      this.imageSrcData,
      this.elapsedTime,
      this.mobilePunchInImage,
      this.mobilePunchOutImage,
      this.userTrackerLocationDtoList,
      this.punchInTime,
      this.punchOutTime,
      this.outTimeText,
      this.employeeNameText,
      this.currentPosition,
      this.punchingListModel,
      this.startClock);

  @override
  List<Object> get props => [
        dailyAttendance,
        punchInOrOut,
        imageSrcData,
        elapsedTime,
        mobilePunchInImage,
        mobilePunchOutImage,
        userTrackerLocationDtoList,
        punchInTime,
        punchOutTime,
        outTimeText,
        employeeNameText,
        punchingListModel,
        startClock
      ];
}

class ErrorState extends PunchingState {
  String errorText;

  ErrorState(this.errorText);

  @override
  List<Object?> get props => [];
}

class PunchingLoadState extends PunchingState {
  @override
  List<Object> get props => [];
}

class StatusErrorState extends PunchingState {
  String errorText;

  StatusErrorState(this.errorText);

  @override
  List<Object?> get props => [];
}

class StartTimerState extends PunchingState {
  var elapsedTime;

  @override
  List<Object> get props => [elapsedTime];

  StartTimerState(this.elapsedTime);
}

class StopTimerState extends PunchingState {
  @override
  List<Object> get props => [];
}

class FetchEmployeeDetailState extends PunchingState {
  @override
  List<Object> get props => [];
}
