// ignore_for_file: must_be_immutable

part of 'regularization_bloc.dart';

abstract class RegularizationEvent extends Equatable {
  const RegularizationEvent();
}

class RegularizationInitialEvent extends RegularizationEvent {
  @override
  List<Object?> get props => [];
}

class LoadRegularizationEvent extends RegularizationEvent {
  BuildContext context;
  bool loadingDiloug;
  Map<String, String>? filterdData;
  bool isReset;

  LoadRegularizationEvent(
      this.context, this.isReset, this.loadingDiloug, this.filterdData);

  @override
  List<Object?> get props => [context, loadingDiloug, filterdData, isReset];
}

class LoadFilterContentEvent extends RegularizationEvent {
  @override
  List<Object?> get props => [];
}

class SubmitRegularizationRequestEvent extends RegularizationEvent {
  dynamic context;
  bool employeeDropDownVisible;
  String? employeeNameTextEditingController,
      requestTypeTextEditingController,
      fromDateTextEditingController,
      toDateTextEditingController,
      inTimeTextEditingController,
      outTimeTextEditingController,
      reasonTextEditingController,
      otherReasonTextEditingController;
  String? fromDate;
  String? toDate;
  var requestTypeId;
  String? requestType;
  String? inTime;
  String? outTime;
  String? reasonType;

  SubmitRegularizationRequestEvent(
      this.employeeDropDownVisible,
      this.employeeNameTextEditingController,
      this.requestTypeTextEditingController,
      this.fromDateTextEditingController,
      this.toDateTextEditingController,
      this.inTimeTextEditingController,
      this.outTimeTextEditingController,
      this.reasonTextEditingController,
      this.otherReasonTextEditingController,
      this.fromDate,
      this.toDate,
      this.inTime,
      this.outTime,
      this.requestType,
      this.requestTypeId,
      this.reasonType);
  @override
  List<Object?> get props => [
        employeeDropDownVisible,
        employeeNameTextEditingController,
        requestTypeTextEditingController,
        fromDateTextEditingController,
        toDateTextEditingController,
        inTimeTextEditingController,
        outTimeTextEditingController,
        reasonTextEditingController,
        otherReasonTextEditingController,
        fromDate,
        toDate,
        inTime,
        outTime,
        requestType,
        requestTypeId,
        reasonType
      ];
}

class ShowRequestContentEvent extends RegularizationEvent {
  String requestType;
  ShowRequestContentEvent(this.requestType);
  @override
  List<Object?> get props => [requestType];
}

class ShowOtherReasonFieldEvent extends RegularizationEvent {
  @override
  String reasonType;
  ShowOtherReasonFieldEvent(this.reasonType);
  @override
  List<Object?> get props => [reasonType];
}

class LoadRequestContentEvent extends RegularizationEvent {
  @override
  List<Object?> get props => [];
}
