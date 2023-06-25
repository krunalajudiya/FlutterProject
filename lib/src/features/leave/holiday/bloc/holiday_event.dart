part of 'holiday_bloc.dart';

abstract class HolidayEvent extends Equatable {
  const HolidayEvent();
}

class LoadHolidayEvent extends HolidayEvent {
  var context;

  LoadHolidayEvent(this.context);

  @override
  List<Object?> get props => [context];
}
