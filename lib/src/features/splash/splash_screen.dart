import 'dart:async';

import 'package:emgage_flutter/src/features/login/view/employee_signin.dart';
import 'package:emgage_flutter/src/features/login/view/validate_company_view.dart';
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:emgage_flutter/src/utils/sharedpreferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/image_path.dart';
import '../../constants/login/login_constants.dart';
import '../attandance/punching/view/punching_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      screenMove(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Image.asset(ImagePath.companyLogo),
    );
  }

  void screenMove(context) async {
    await languageCheck();
    if (!CommonFunction.isNullOrIsEmpty(
            await SharedpreferencesUtils.getTokenInfo()) &&
        !CommonFunction.isNullOrIsEmpty(
            await SharedpreferencesUtils.getUserRollDetail())) {
      CommonFunction.pageRouteOrReplace(context, Punching());
    } else if (!CommonFunction.isNullOrIsEmpty(
        await SharedpreferencesUtils.getCompanyInfo())) {
      CommonFunction.pageRouteOrReplace(context, EmployeeSignin());
    } else {
      CommonFunction.pageRouteOrReplace(context, ValidateCompanyView());
    }
  }

  languageCheck() async {
    var language = await SharedpreferencesUtils.getLanguageDetail();
    if (!CommonFunction.isNullOrIsEmpty(language)) {
      if (language == LoginConstants.hindiLanguage) {
        Get.updateLocale(const Locale("hi", "IN"));
      } else {
        Get.updateLocale(const Locale("en", "US"));
      }
    }
  }
}
