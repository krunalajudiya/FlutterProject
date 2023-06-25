// ignore_for_file: must_be_immutable

part of 'correction_bloc.dart';

abstract class CorrectionEvent extends Equatable {
  const CorrectionEvent();
}

class CorrectionInitialEvent extends CorrectionEvent {
  @override
  List<Object?> get props => [];
}

class LoadCorrectionEvent extends CorrectionEvent {
  dynamic context;
  bool loadingDiloug;
  Map<String, String>? body;
  bool isReset;

  LoadCorrectionEvent(
      this.context, this.body, this.isReset, this.loadingDiloug);

  @override
  List<Object?> get props => [context, body, isReset, loadingDiloug];
}

class FilterLoadedEvent extends CorrectionEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ShowOtherReasonFieldEvent extends CorrectionEvent {
  String? reasonType;
  ShowOtherReasonFieldEvent(this.reasonType);
  @override
  List<Object?> get props => [reasonType];
}

class SubmitCorrectionRequestEvent extends CorrectionEvent {
  dynamic context;
  String? employeeNameTextEditingController;
  String? correctionDateTextEditingController;
  String? inTimeTextEditingController;
  String? outTimeTextEditingController;
  String? reasonTypeTextEditingController;
  String? otherReasonTextEditingController;
  String? correctionDate;
  String? resaonType;
  String? inTime;
  String? outTime;
  Map<String, dynamic> inOutPunchBody;

  SubmitCorrectionRequestEvent(
      this.employeeNameTextEditingController,
      this.correctionDateTextEditingController,
      this.inTimeTextEditingController,
      this.outTimeTextEditingController,
      this.reasonTypeTextEditingController,
      this.otherReasonTextEditingController,
      this.correctionDate,
      this.resaonType,
      this.inTime,
      this.outTime,
      this.inOutPunchBody);

  @override
  List<Object?> get props => [
        employeeNameTextEditingController,
        correctionDateTextEditingController,
        inTimeTextEditingController,
        outTimeTextEditingController,
        reasonTypeTextEditingController,
        otherReasonTextEditingController,
        resaonType,
        inTime,
        outTime,
        correctionDate
      ];
}

class FetchPunchInOutTimeDataEvent extends CorrectionEvent {
  DateTime? correctionDate;

  FetchPunchInOutTimeDataEvent(this.correctionDate);

  @override
  List<Object?> get props => [correctionDate];
}
