part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class SubmitDataEvent extends LoginEvent {
  BuildContext context;
  String companyName;

  SubmitDataEvent(this.context, this.companyName);

  @override
  List<Object?> get props => [context, companyName];
}

class ChangeCompanyEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class CredentialValidateEvent extends LoginEvent {
  BuildContext context;
  String employeeIdText;
  String passwordText;

  CredentialValidateEvent(this.context, this.employeeIdText, this.passwordText);

  @override
  List<Object?> get props => [context, employeeIdText, passwordText];
}

class LoadDataEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LanguageChangeEvent extends LoginEvent {
  String languageName;

  LanguageChangeEvent(this.languageName);

  @override
  List<Object?> get props => [languageName];
}
