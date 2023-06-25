part of 'hrpolicydocument_bloc.dart';

abstract class HrpolicydocumentEvent extends Equatable {
  const HrpolicydocumentEvent();
}

class LoadPolicyDocumentDataEvent extends HrpolicydocumentEvent {
  var context;
  LoadPolicyDocumentDataEvent(this.context);
  @override
  List<Object?> get props => [context];
}

class OpenFileEvent extends HrpolicydocumentEvent {
  var context;
  int index;
  OpenFileEvent(this.context, this.index);
  @override
  List<Object?> get props => [context, index];
}
