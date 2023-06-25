import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emgage_flutter/src/features/leave/holiday/model/holiday_model.dart';
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:equatable/equatable.dart';

import '../../../../utils/sharedpreferences_utils.dart';
import '../api/api.dart';

part 'holiday_event.dart';

part 'holiday_state.dart';

class HolidayBloc extends Bloc<HolidayEvent, HolidayState> {
  HolidayBloc() : super(HolidayInitial()) {
    on<LoadHolidayEvent>((event, emit) async {
      String employeeId = await SharedpreferencesUtils.getEmployeeId();
      var data = await Api.getHolidayListApi(event.context, employeeId);
      if (!CommonFunction.isNullOrIsEmpty(data)) {
        List<HolidayModel> holidayModelList = [];
        data.forEach(
            (value) => holidayModelList.add(HolidayModel.fromJson(value)));
        emit(LoadHolidayState(holidayModelList));
      }
    });
  }
}
