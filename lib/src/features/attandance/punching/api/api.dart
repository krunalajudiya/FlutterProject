import '../../../../constants/urls.dart';
import '../../../../utils/fetch_utils.dart';
import '../../../../utils/sharedpreferences_utils.dart';

class Api {
  static fetchDailyAttandanceDataApi(context) async {
    try {
      var response = await FetchUtils.callAPIGET(
          url: Urls.fetchDailyAttendanceData +
              await SharedpreferencesUtils.getEmployeeId(),
          context: context);
      if (response["statusCode"] == 200) {
        var data = response["body"];
        return data["responseObj"];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static multiPunchingDataApi(context, body) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.punchInOut, body: body, context: context);
      if (response["statusCode"] == 200) {
        return response["body"];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
