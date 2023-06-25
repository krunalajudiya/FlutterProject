// ignore_for_file: must_be_immutable

part of 'punching_bloc.dart';

abstract class PunchingEvent extends Equatable {
  const PunchingEvent();
}

class PunchingInitialEvent extends PunchingEvent {
  @override
  List<Object?> get props => [];
}

class PunchingActionEvent extends PunchingEvent {
  @override
  List<Object?> get props => [];
}

class LoadInitialDataEvent extends PunchingEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class PunchingLoadEvent extends PunchingEvent {
  BuildContext context;

  PunchingLoadEvent(this.context);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchDailyAttendanceDataEvent extends PunchingEvent {
  BuildContext context;

  FetchDailyAttendanceDataEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class StartTimerEvent extends PunchingEvent {
  BuildContext context;

  StartTimerEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class StopTimerEvent extends PunchingEvent {
  BuildContext context;

  StopTimerEvent(this.context);

  @override
  List<Object?> get props => [context];
}
