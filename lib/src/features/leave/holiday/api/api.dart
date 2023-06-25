import '../../../../constants/urls.dart';
import '../../../../utils/fetch_utils.dart';

class Api {
  static getHolidayListApi(context, String employeeId) async {
    try {
      Map<String, String> body = {};
      body["employeeId"] = employeeId;
      var response = await FetchUtils.callAPIPOST(
          url: Urls.fetchHolidayList, body: body, context: context);
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
}
