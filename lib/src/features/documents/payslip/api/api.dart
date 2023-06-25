import '../../../../constants/urls.dart';
import '../../../../utils/fetch_utils.dart';

class Api {
  static Future getPayslipDataApi(context, String employeeId) async {
    try {
      var url = Urls.fetchPayslipData + employeeId;
      var response = await FetchUtils.callAPIGET(url: url, context: context);
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

  static Future getPayslipDownloadDataApi(context, body) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.fetchPayslipDownloadData, body: body, context: context);
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

  static Future getCumulativePayslipDownloadDataApi(context, body) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.fetchCumulativePayslipDownloadData,
          body: body,
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
}
