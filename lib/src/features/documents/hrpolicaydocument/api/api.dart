import '../../../../constants/urls.dart';
import '../../../../utils/fetch_utils.dart';

class Api {
  static getHrPolicyDocumentDataApi(context) async {
    try {
      var response = await FetchUtils.callAPIGET(
          url: Urls.fetchHrPolicayDocument,
          context: context,
          loadingDialog: false);
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
