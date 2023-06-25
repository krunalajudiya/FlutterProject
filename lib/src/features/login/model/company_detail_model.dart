class CompanyDetailModel {
  String? expiryDate;
  String? companyLogo;
  String? companyName;

  CompanyDetailModel({this.expiryDate, this.companyLogo, this.companyName});

  CompanyDetailModel.fromJson(Map<String, dynamic> json) {
    expiryDate = json['expiryDate'];
    companyLogo = json['companyLogo'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expiryDate'] = expiryDate;
    data['companyLogo'] = companyLogo;
    data['companyName'] = companyName;
    return data;
  }
}
