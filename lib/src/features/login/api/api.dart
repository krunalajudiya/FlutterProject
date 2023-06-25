import 'package:emgage_flutter/src/constants/login/login_constants.dart';
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:flutter/cupertino.dart';

import '../../../constants/urls.dart';
import '../../../utils/fetch_utils.dart';

class Api {
  static Future validateCompanyApi(
      BuildContext context, String companyName) async {
    try {
      var response = await FetchUtils.callAPIGET(
          url: Urls.validateCompanyUrl + companyName, context: context);
      if (response["statusCode"] == 204) {
        CommonFunction.showToastMsg(
            LoginConstants.validateCompany204ErrorMessage);
        return null;
      } else if (response["statusCode"] == 200) {
        return response["body"]["responseObj"];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future validateCredentialApi(BuildContext context, body) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.validateUserUrl, body: body, context: context);
      if (response["statusCode"] == 200) {
        return response["body"]["responseObj"];
      } else if (response["statusCode"] == 400 ||
          response["statusCode"] == 401 ||
          response["statusCode"] == 404 ||
          response["statusCode"] == 500) {
        var data = response["body"];
        if (data["responseObj"] == "LOCK") {
          CommonFunction.showToastMsg(LoginConstants.submitLabel);
        } else if (data["message"] ==
                "Emgage subscription expired. Contact support@emgage.work to renew" ||
            data["message"] ==
                "No role assigned, Kindly contact administrator." ||
            data["message"] ==
                "Account inactivated Kindly contact administrator") {
          CommonFunction.showToastMsg(data["message"]);
        } else if (data["responseObj"] == "" ||
            data["responseObj"] == "null" ||
            data["responseObj"] == null) {
          CommonFunction.showToastMsg(
              LoginConstants.validateUser401ErrorMessage);
        } else if ("Failure" == data["message"]) {
          if (data["responseObj"] < 0) {
            CommonFunction.showToastMsg(
                LoginConstants.accountBlockedErrorMessage);
          } else {
            CommonFunction.showToastMsg(
                "Invalid password, ${data["responseObj"]} attempt remaining");
          }
        }
      } else {
        CommonFunction.showToastMsg(LoginConstants.validateUser401ErrorMessage);
      }
    } catch (e) {
      return null;
    }
  }
}
