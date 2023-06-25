import '../../../constants/urls.dart';
import '../../../utils/fetch_utils.dart';

class Api {
  static seperationDataListApi(
      context, body, loadingDialog, type, page, size) async {
    try {
      var response = await FetchUtils.callAPIPOST(
          url:
              "${Urls.fetchSeperationDataList}?type=$type&page=$page&size=$size",
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
}
