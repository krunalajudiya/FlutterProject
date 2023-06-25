part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class ValidateCompanyState extends LoginState {
  @override
  List<Object> get props => [];
}

class ChangeCompanyState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoadedDataState extends LoginState {
  String companyNameText, companyLogoUrl, employeeIdText, passwordText;
  LoadedDataState(this.companyNameText, this.companyLogoUrl,
      this.employeeIdText, this.passwordText);
  @override
  List<Object> get props =>
      [companyNameText, companyLogoUrl, employeeIdText, passwordText];
}

class CredentialValidateState extends LoginState {
  @override
  List<Object> get props => [];
}

class LanguageChangeState extends LoginState {
  @override
  List<Object> get props => [];
}

class ErrorState extends LoginState {
  @override
  List<Object> get props => [];
}
