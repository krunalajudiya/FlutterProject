class HrPolicyDocumentModel {
  HrPolicyDocumentModel({
    this.description,
    this.documentCategory,
    this.documentId,
    this.documentName,
    this.documentPath,
  });

  HrPolicyDocumentModel.fromJson(dynamic json) {
    description = json['description'];
    documentCategory = json['documentCategory'];
    documentId = json['documentId'];
    documentName = json['documentName'];
    documentPath = json['documentPath'];
  }

  String? description;
  String? documentCategory;
  String? documentId;
  String? documentName;
  String? documentPath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['documentCategory'] = documentCategory;
    map['documentId'] = documentId;
    map['documentName'] = documentName;
    map['documentPath'] = documentPath;
    return map;
  }
}
