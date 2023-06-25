import 'dart:convert';

import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../constants/login/login_constants.dart';
import '../../../utils/sharedpreferences_utils.dart';
import '../api/api.dart';
import '../model/company_detail_model.dart';
import '../view/widgets/roll_select_dialog.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String companyNameText = "";

  LoginBloc() : super(LoginInitial()) {
    on<SubmitDataEvent>((event, emit) async {
      var data = await Api.validateCompanyApi(event.context, event.companyName);
      if (!CommonFunction.isNullOrIsEmpty(data)) {
        await SharedpreferencesUtils.setCompanyInfo(jsonEncode(data));
        emit(ValidateCompanyState());
      } else {
        emit(ErrorState());
      }
    });
    on<ChangeCompanyEvent>((event, emit) async {
      if (await SharedpreferencesUtils.removeCompanyInfo()) {
        if (await SharedpreferencesUtils.removeCredentials()) {
          emit(ChangeCompanyState());
        }
      }
    });
    on<LoadDataEvent>((event, emit) async {
      String? employeeIdText, passwordText;
      String? companyInfo = await SharedpreferencesUtils.getCompanyInfo();
      CompanyDetailModel companydetail =
          CompanyDetailModel.fromJson(jsonDecode(companyInfo.toString()));
      companyNameText = companydetail.companyName.toString();
      String? userinfo = await SharedpreferencesUtils.getUserCredentials();
      if (!CommonFunction.isNullOrIsEmpty(userinfo)) {
        var userdetail = jsonDecode(userinfo!);
        employeeIdText = userdetail["employeeid"].toString();
        passwordText = userdetail["password"].toString();
      }
      emit(LoadedDataState(
          companyNameText,
          companydetail.companyLogo.toString(),
          employeeIdText ?? "",
          passwordText ?? ""));
    });
    on<CredentialValidateEvent>((event, emit) async {
      Map<String, String> body = {};
      body["password"] = event.passwordText;
      body["usernameOrMobileno"] = "${event.employeeIdText}@$companyNameText";

      var data = await Api.validateCredentialApi(event.context, body);

      if (!CommonFunction.isNullOrIsEmpty(data)) {
        await SharedpreferencesUtils.setEmployeeDetailInfo(
            jsonEncode(data["employeeDetail"]));

        await SharedpreferencesUtils.setServerNoInfo(data["serverNo"]);

        await SharedpreferencesUtils.setTokenInfo(
            "Bearer ${data["token"]["accessToken"]}");

        Map<String, String> userCredentialMap = {};
        userCredentialMap["employeeid"] = event.employeeIdText;
        userCredentialMap["password"] = event.passwordText;

        await SharedpreferencesUtils.setUserCredentials(
            jsonEncode(userCredentialMap));

        if (data["userDetail"]["roles"].length > 1) {
          var selectedRole = await rollSelectDialogShow(
              event.context,
              data["userDetail"]["roles"],
              data["employeeDetail"]["firstName"],
              data["employeeDetail"]["middleName"],
              data["employeeDetail"]["lastName"]);
          if (selectedRole != null) {
            await SharedpreferencesUtils.setUserRollDetail(
                jsonEncode(selectedRole));
            emit(CredentialValidateState());
          }
        } else {
          await SharedpreferencesUtils.setUserRollDetail(
              jsonEncode(data["userDetail"]["roles"][0]));
          emit(CredentialValidateState());
        }
      } else {
        emit(ErrorState());
      }
    });
    on<LanguageChangeEvent>((event, emit) async {
      if (event.languageName == LoginConstants.englishLanguage) {
        Get.updateLocale(const Locale("en", "US"));
        await SharedpreferencesUtils.setLanguageDetail(
            LoginConstants.englishLanguage);
        emit(LanguageChangeState());
      } else if (event.languageName == LoginConstants.hindiLanguage) {
        Get.updateLocale(const Locale("hi", "IN"));
        await SharedpreferencesUtils.setLanguageDetail(
            LoginConstants.hindiLanguage);
        emit(LanguageChangeState());
      }
    });
  }
}
