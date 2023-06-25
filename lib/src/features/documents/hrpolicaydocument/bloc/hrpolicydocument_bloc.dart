import 'package:emgage_flutter/src/features/documents/hrpolicaydocument/api/api.dart';
import 'package:emgage_flutter/src/features/documents/hrpolicaydocument/model/hr_policy_document_model.dart';
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/image_view_page.dart';

part 'hrpolicydocument_event.dart';

part 'hrpolicydocument_state.dart';

class HrpolicydocumentBloc
    extends Bloc<HrpolicydocumentEvent, HrpolicydocumentState> {
  List<HrPolicyDocumentModel> hrPolicyDocumentModelList = [];

  HrpolicydocumentBloc() : super(HrpolicydocumentInitial()) {
    on<LoadPolicyDocumentDataEvent>((event, emit) async {
      var data = await Api.getHrPolicyDocumentDataApi(event.context);

      if (!CommonFunction.isNullOrIsEmpty(data)) {
        data.forEach((value) => hrPolicyDocumentModelList
            .add(HrPolicyDocumentModel.fromJson(value)));
        emit(LoadPolicyDocumentDataState(hrPolicyDocumentModelList));
      }
    });
    on<OpenFileEvent>((event, emit) {
      var fileType = (hrPolicyDocumentModelList[event.index].documentPath)!
          .split("/")
          .last
          .split(".")
          .last
          .toLowerCase();
      openFile(event.context,
          hrPolicyDocumentModelList[event.index].documentPath, fileType);
    });
  }
  openFile(context, contentUrl, fileType) {
    if (fileType == "png" || fileType == "jpg" || fileType == "jpeg") {
      openImage(context, contentUrl, contentUrl.split("/").last);
    } else if (fileType == "pdf") {
      launchUrl(Uri.parse(contentUrl), mode: LaunchMode.externalApplication);
    }
  }

  void openImage(context, imageUrl, imageName) => CommonFunction.pageRoute(
      context,
      ImageViewPage(
        imageUrl: imageUrl,
        imageName: imageName,
      ));
}
