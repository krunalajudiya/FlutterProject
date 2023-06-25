import 'package:emgage_flutter/src/utils/fetch_utils.dart';

import '../constants/urls.dart';

class FetchEmployeeDetail {
  static Map<String, dynamic>? employeeDetail;

  static Map<String, dynamic>? getEmployeeDetail() {
    return employeeDetail;
  }

  static setEmployeeDetail() async {
    await employeeApiCall();
  }

  static employeeApiCall() async {
    try {
      var response = await FetchUtils.callAPIGET(
          url: Urls.fetchEmployeeList, loadingDialog: false);
      if (response["statusCode"] == 200) {
        var data = response["body"];
        var responseObj = data["responseObj"];
        Map<String, Object> empmap = {};
        for (int i = 0; i < responseObj.length; i++) {
          empmap[responseObj[i]["employeeId"]] = responseObj[i];
        }
        employeeDetail = empmap;
      }
    } catch (e) {
      employeeDetail = null;
    }
  }
}
