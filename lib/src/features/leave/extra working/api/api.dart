import '../../../../constants/urls.dart';
import '../../../../utils/fetch_utils.dart';

class Api {
  static extraWorkingListApi(
      context,
      bool loadingDialog,
      Map<String, dynamic> body,
      String employeeId,
      String type,
      int page,
      int size) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url:
              "${Urls.fetchExtraWorkingList}$employeeId/$type?page=$page&size=$size",
          body: body,
          context: context,
          loadingDialog: loadingDialog);
      if (response["statusCode"] == 200) {
        return response["body"];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static userShiftDataApi(
      context, bool loadingDialog, String date, String employeeId) async {
    try {
      var response = await FetchUtils.callAPIGET(
          url:
              "${Urls.fetchUserShiftTime}?dateString=$date&employeeId=$employeeId",
          context: context,
          loadingDialog: loadingDialog);
      if (response["statusCode"] == 200) {
        return response["body"]["responseObj"];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static extraWorkingRequestApi(
      context, bool loadingDialog, Map<String, dynamic> body) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.extraWorkingRequest,
          context: context,
          body: body,
          loadingDialog: loadingDialog);
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
