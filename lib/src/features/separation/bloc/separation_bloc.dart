import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'separation_event.dart';
part 'separation_state.dart';

class SeparationBloc extends Bloc<SeparationEvent, SeparationState> {
  SeparationBloc() : super(SeparationInitial()) {
    on<SeparationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
