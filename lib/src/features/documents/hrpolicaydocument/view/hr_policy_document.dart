import 'package:emgage_flutter/src/constants/document/document_constants.dart';
import 'package:emgage_flutter/src/features/documents/hrpolicaydocument/model/hr_policy_document_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../constants/image_path.dart';
import '../../../../utils/common_functions.dart';
import '../bloc/hrpolicydocument_bloc.dart';

class HrPolicyDocument extends StatelessWidget {
  List<HrPolicyDocumentModel> hrPolicyDocumentModelList = [];
  final hrPolicyDocuemntBloc = HrpolicydocumentBloc();

  HrPolicyDocument({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DocumentConstants.hrPolicyDocuemntLabel.tr),
      ),
      body: BlocProvider(
        create: (context) =>
            hrPolicyDocuemntBloc..add(LoadPolicyDocumentDataEvent(context)),
        child: BlocBuilder<HrpolicydocumentBloc, HrpolicydocumentState>(
          builder: (context, state) {
            if (state is LoadPolicyDocumentDataState) {
              hrPolicyDocumentModelList = state.hrPolicyDocumentModelList;
              return ListView.builder(
                itemBuilder: (context, index) {
                  var fileType =
                      (hrPolicyDocumentModelList[index].documentPath)!
                          .split("/")
                          .last
                          .split(".")
                          .last
                          .toLowerCase();
                  return GestureDetector(
                    onTap: () {
                      hrPolicyDocuemntBloc.add(OpenFileEvent(context, index));
                    },
                    child: Card(
                      elevation: 3,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                  height: 80,
                                  fileType == "png" ||
                                          fileType == "jpg" ||
                                          fileType == "jpeg"
                                      ? ImagePath.imagePlaceholder
                                      : fileType == "pdf"
                                          ? ImagePath.pdfFile
                                          : ImagePath.imagePlaceholder),
                            ),
                            CommonWidgets.horizontalSpace(10),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: !CommonFunction.isNullOrIsEmpty(
                                        hrPolicyDocumentModelList[index]
                                            .documentName),
                                    child: Text(
                                        (hrPolicyDocumentModelList[index]
                                                .documentName)
                                            .toString(),
                                        overflow: CommonWidgets
                                            .textOverFlowEllipsis()),
                                  ),
                                  Visibility(
                                    visible: !CommonFunction.isNullOrIsEmpty(
                                        hrPolicyDocumentModelList[index]
                                            .documentCategory),
                                    child: Text(
                                        (hrPolicyDocumentModelList[index]
                                                .documentCategory)
                                            .toString(),
                                        overflow: CommonWidgets
                                            .textOverFlowEllipsis()),
                                  ),
                                  Visibility(
                                    visible: !CommonFunction.isNullOrIsEmpty(
                                        hrPolicyDocumentModelList[index]
                                            .description),
                                    child: Text(
                                      (hrPolicyDocumentModelList[index]
                                              .description)
                                          .toString(),
                                      overflow:
                                          CommonWidgets.textOverFlowEllipsis(),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: hrPolicyDocumentModelList.length,
              );
            } else {
              return CommonWidgets.emptyAnimationWidget();
            }
          },
        ),
      ),
    );
  }
}
