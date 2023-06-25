import 'package:dio/dio.dart';

import 'fetch_utils.dart';

class DownloadUtils {
  static downloadPdfFile(url, fileName, downloadFilePath) async {
    Dio dio = Dio();
    var filenameMillis = fileName.replaceAll(
        ".pdf", "_${DateTime.now().microsecondsSinceEpoch}.pdf");
    dio.options.headers = await FetchUtils.getHeaders();
    final pdfPath = downloadFilePath + filenameMillis;
    try {
      var response = await dio.download(url, pdfPath);
      if (response.statusCode == 200) {
        return pdfPath;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
