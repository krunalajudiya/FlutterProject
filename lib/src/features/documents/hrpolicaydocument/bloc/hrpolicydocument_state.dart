part of 'hrpolicydocument_bloc.dart';

abstract class HrpolicydocumentState extends Equatable {
  const HrpolicydocumentState();
}

class HrpolicydocumentInitial extends HrpolicydocumentState {
  @override
  List<Object> get props => [];
}

class LoadPolicyDocumentDataState extends HrpolicydocumentState {
  List<HrPolicyDocumentModel> hrPolicyDocumentModelList;
  LoadPolicyDocumentDataState(this.hrPolicyDocumentModelList);
  @override
  List<Object> get props => [hrPolicyDocumentModelList];
}
