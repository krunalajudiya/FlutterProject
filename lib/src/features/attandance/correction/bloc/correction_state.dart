// ignore_for_file: must_be_immutable

part of 'correction_bloc.dart';

abstract class CorrectionState extends Equatable {
  const CorrectionState();
}

class CorrectionInitial extends CorrectionState {
  @override
  List<Object> get props => [];
}

class CorrectionLoadedState extends CorrectionState {
  List<CorrectionlistModel> correctionList;
  int totalRequestCount;
  int totalApprovedCount;
  int page;
  int size;

  CorrectionLoadedState(
    this.totalRequestCount,
    this.totalApprovedCount,
    this.correctionList,
    this.page,
    this.size,
  );

  @override
  List<Object> get props => [
        totalRequestCount,
        totalApprovedCount,
        correctionList,
        page,
        size,
      ];
}

class FilterLoadedState extends CorrectionState {
  List<DropdownMenuEntry> employeeDropDownList = [];

  FilterLoadedState(this.employeeDropDownList);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ShowOtherReasonFieldState extends CorrectionState {
  bool otherReasonVisible;

  ShowOtherReasonFieldState(this.otherReasonVisible);

  @override
  List<Object?> get props => [otherReasonVisible];
}

class ValidateFieldState extends CorrectionState {
  var employeeErrorStatus,
      correctionDateErrorStatus,
      inTimeErrorStatus,
      outTimeErrorStatus,
      reasonErrorStatus,
      otherReasonErrorStatus;

  ValidateFieldState(
      this.employeeErrorStatus,
      this.correctionDateErrorStatus,
      this.inTimeErrorStatus,
      this.outTimeErrorStatus,
      this.reasonErrorStatus,
      this.otherReasonErrorStatus);

  @override
  List<Object?> get props => [
        employeeErrorStatus,
        correctionDateErrorStatus,
        inTimeErrorStatus,
        outTimeErrorStatus,
        reasonErrorStatus,
        otherReasonErrorStatus
      ];
}

class SubmitCorrectionRequestState extends CorrectionState {
  @override
  List<Object?> get props => [];
}

class FetchPunchInOutTimeDataState extends CorrectionState {
  String inTime;
  String outTime;
  String correctionDate;
  Map<String, dynamic> inOutPunchBody;

  FetchPunchInOutTimeDataState(
      this.inTime, this.outTime, this.correctionDate, this.inOutPunchBody);

  @override
  List<Object?> get props => [inTime, outTime, correctionDate, inOutPunchBody];
}

class ErrorState extends CorrectionState {
  String ErrorText;

  ErrorState(this.ErrorText);

  @override
  // TODO: implement props
  List<Object?> get props => [ErrorText];
}
