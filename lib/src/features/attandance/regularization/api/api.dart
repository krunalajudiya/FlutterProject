import '../../../../constants/urls.dart';
import '../../../../utils/fetch_utils.dart';
import '../../../../utils/sharedpreferences_utils.dart';

class Api {
  static fetchRegularizationDataListApi(
      context, filterdData, page, size) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url:
              "${Urls.regularizationListData}${await SharedpreferencesUtils.getEmployeeId()}/list?page:$page&size:$size",
          body: filterdData,
          context: context,
          loadingDialog: true);
      if (response["statusCode"] == 200) {
        var data = response["body"];
        var responseObj = data["responseObj"];
        return responseObj;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static fetchRegularizationCodeData(context, loadingDialog) async {
    try {
      var response = await FetchUtils.callAPIGET(
          url: Urls.fetchRegularizationCodeData +
              (await SharedpreferencesUtils.getEmployeeId()),
          context: context,
          loadingDialog: loadingDialog);
      if (response['statusCode'] == 200) {
        var data = response["body"];
        var responseObj = data["responseObj"];
        return responseObj;
      }
    } catch (e) {
      return null;
    }
  }

  static setAttendanceRegularizationRequest(
      body, context, loadingDialog) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.attendanceRegularizationRequest,
          body: body,
          context: context,
          loadingDialog: loadingDialog);
      if (response["statusCode"] == 200) {
        var data = response["body"];
        var responseObj = data["responseObj"];
        return responseObj;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
