import '../../../../constants/urls.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/fetch_utils.dart';

class CorrectionApi {
  static fetchCorrectionDataListApi(
      context, body, page, size, employeeId) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url:
              "${Urls.correctionListData}$employeeId/list?page=$page&size=$size",
          body: body,
          context: context,
          loadingDialog: true);
      if (response["statusCode"] == 200) {
        var data = response["body"];
        var responseObj = data["responseObj"];
        return responseObj;
      } else if (response["statusCode"] == 204) {
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static setAttendanceCorrectionRequest(
    body,
    context,
    loadingDialog,
  ) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.attendanceCorrectionRequest,
          body: body,
          context: context,
          loadingDialog: loadingDialog);
      if (response["statusCode"] == 200) {
        var data = response["body"];
        if (data["code"] == 200) {
          var responseObj = data["responseObj"];
          CommonFunction.showSuccessToastMsg(data["message"]);
          return responseObj;
        } else if (data["code"] == 204) {
          CommonFunction.showToastMsg(data["message"]);
        } else {
          return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  static fetchPunchInOutTimeData(
      employeeId, correctionDate, loadingDialog) async {
    var response = await FetchUtils.callAPIGET(
        url:
            "${Urls.attendanceExistingData}?dateString=$correctionDate&employeeId=$employeeId",
        loadingDialog: loadingDialog);
    if (response["statusCode"] == 200) {
      var data = response["body"];
      var responseObj = data["responseObj"];
      return responseObj;
    }
  }
}
