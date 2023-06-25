// ignore_for_file: must_be_immutable

part of 'regularization_bloc.dart';

abstract class RegularizationState extends Equatable {
  const RegularizationState();
}

class RegularizationInitial extends RegularizationState {
  @override
  List<Object> get props => [];
}

class RegularizationLoadedState extends RegularizationState {
  List<RegularizationListModel> regularizationList;
  int totalRequestCount;
  int totalPendingApprovedCount;
  int page;
  int size;

  RegularizationLoadedState(
    this.totalRequestCount,
    this.totalPendingApprovedCount,
    this.regularizationList,
    this.page,
    this.size,
  );

  @override
  List<Object?> get props => [
        totalRequestCount,
        totalPendingApprovedCount,
        regularizationList,
        page,
        size
      ];
}

class LoadFilterContentState extends RegularizationState {
  List<DropdownMenuEntry> employeeDropDownList;

  List<DropdownMenuEntry> regularizationCodeDropDownList;

  LoadFilterContentState(
      this.employeeDropDownList, this.regularizationCodeDropDownList);

  @override
  List<Object> get props => [];
}

class LoadRequestContentState extends RegularizationState {
  List<DropdownMenuEntry> employeeDropDownList;
  List<DropdownMenuEntry> regularizationCodeDropDownList;

  LoadRequestContentState(
      this.employeeDropDownList, this.regularizationCodeDropDownList);

  @override
  List<Object> get props => [];
}

class ShowRequestContentState extends RegularizationState {
  String dateText;
  bool inTimeVisible;
  bool outTimeVisible;
  bool toDateVisible;

  ShowRequestContentState(this.dateText, this.inTimeVisible,
      this.outTimeVisible, this.toDateVisible);

  @override
  List<Object?> get props =>
      [dateText, inTimeVisible, outTimeVisible, toDateVisible];
}

class ShowOtherReasonFieldState extends RegularizationState {
  bool otherReasonVisible;

  ShowOtherReasonFieldState(this.otherReasonVisible);

  @override
  List<Object?> get props => [otherReasonVisible];
}

class ValidateFieldsState extends RegularizationState {
  var employeeErrorStatus,
      requestTypeErrorState,
      fromDateErrorState,
      toDateErrorState,
      inTimeErrorStatus,
      outTimeErrorStatus,
      reasonErrorStatus,
      otherReasonErrorStatus;

  ValidateFieldsState(
      this.employeeErrorStatus,
      this.requestTypeErrorState,
      this.fromDateErrorState,
      this.toDateErrorState,
      this.inTimeErrorStatus,
      this.outTimeErrorStatus,
      this.reasonErrorStatus,
      this.otherReasonErrorStatus);

  @override
  List<Object?> get props => [
        employeeErrorStatus,
        requestTypeErrorState,
        fromDateErrorState,
        toDateErrorState,
        inTimeErrorStatus,
        outTimeErrorStatus,
        reasonErrorStatus,
        otherReasonErrorStatus
      ];
}

class SubmitRegularizationRequestState extends RegularizationState {
  @override
  List<Object?> get props => [];
}

class ErrorState extends RegularizationState {
  String ErrorText;

  ErrorState(this.ErrorText);

  @override
  // TODO: implement props
  List<Object?> get props => [ErrorText];
}
