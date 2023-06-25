part of 'holiday_bloc.dart';

abstract class HolidayState extends Equatable {
  const HolidayState();
}

class HolidayInitial extends HolidayState {
  @override
  List<Object> get props => [];
}

class LoadHolidayState extends HolidayState {
  List<HolidayModel> holidayModelList;

  LoadHolidayState(this.holidayModelList);

  @override
  List<Object> get props => [holidayModelList];
}
