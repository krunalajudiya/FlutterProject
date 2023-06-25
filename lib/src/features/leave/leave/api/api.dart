import '../../../../constants/urls.dart';
import '../../../../utils/fetch_utils.dart';

class Api {
  static getLeaveRequestListApi(context, String employeeId, String typeOfList,
      int page, int size, Map<String, dynamic> body, bool loadingDialog) async {
    try {
      var url =
          "${Urls.fetchLeaveRequestList}$employeeId/$typeOfList?page=$page&size=$size";
      var response = await FetchUtils.callAPIPOST(
          url: url, body: body, context: context, loadingDialog: loadingDialog);
      if (response["statusCode"] == 200) {
        return response["body"];
      }
    } catch (e) {
      return null;
    }
  }

  static filterLeaveCodeDataApi(context, bool loadingDialog) async {
    try {
      var response = await FetchUtils.callAPIGET(
          url: Urls.fetchLeaveCodeData, context: context, loadingDialog: false);
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

  static getUserLeaveDaysDataApi(context, body, loadingDialog) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.fetchUserLeaveDaysData,
          body: body,
          context: context,
          loadingDialog: loadingDialog);
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

  static getLeaveCodeUserDataApi(
      context, body, loadingDialog, employeeId) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.fetchLeaveBalanceData + employeeId,
          body: body,
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

  static getExtraWorkingDataApi(
      context, body, loadingDialog, employeeId) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.fetchExtraWorkingData + employeeId,
          body: body,
          context: context,
          loadingDialog: loadingDialog);
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

  static leaveRequestApi(context, body, loadingDialog) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url: Urls.leaveRequest,
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
}
