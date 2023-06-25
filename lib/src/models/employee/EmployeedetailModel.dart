class employeedetailModel {
  employeedetailModel({
    this.firstName,
    this.middleName,
    this.lastName,
    this.dateOfBirth,
    this.email,
    this.photo,
    this.companyId,
    this.employeeId,
    this.lookUpName,
    this.departmentName,
    this.designationName,
    this.reportingPerson,
    this.reportingPerson1,
    this.employeementDate,
    this.mobileNo,
    this.comm10,
    this.stateName,
    this.categoryName,
    this.paycaderID,
    this.subCatName,
    this.officialPhoneNo,
    this.branchName,
    this.isChild,
    this.sbuId,
    this.extendedProbationDate,
    this.probation,
    this.probationPeriod,
    this.probationEndDate,
    this.probationExtendedEndDate,
    this.probationStatus,
    this.fnfNoticePeriod,
    this.noticePeriod,
    this.eemployeeStatus,
    this.eaddress,
    this.epersonalEmail,
    this.ecity,
  });

  employeedetailModel.fromJson(dynamic json) {
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    dateOfBirth = json['dateOfBirth'];
    email = json['email'];
    photo = json['photo'];
    companyId = json['companyId'];
    employeeId = json['employeeId'];
    lookUpName = json['lookUpName'];
    departmentName = json['departmentName'];
    designationName = json['designationName'];
    reportingPerson = json['reportingPerson'];
    reportingPerson1 = json['reportingPerson1'];
    employeementDate = json['employeementDate'];
    mobileNo = json['mobileNo'];
    comm10 = json['comm10'];
    stateName = json['stateName'];
    categoryName = json['categoryName'];
    paycaderID = json['paycaderID'];
    subCatName = json['subCatName'];
    officialPhoneNo = json['officialPhoneNo'];
    branchName = json['branchName'];
    isChild = json['isChild'];
    sbuId = json['sbuId'];
    extendedProbationDate = json['extendedProbationDate'];
    probation = json['probation'];
    probationPeriod = json['probationPeriod'];
    probationEndDate = json['probationEndDate'];
    probationExtendedEndDate = json['probationExtendedEndDate'];
    probationStatus = json['probationStatus'];
    fnfNoticePeriod = json['fnfNoticePeriod'];
    noticePeriod = json['noticePeriod'];
    eemployeeStatus = json['eemployeeStatus'];
    eaddress = json['eaddress'];
    epersonalEmail = json['epersonalEmail'];
    ecity = json['ecity'];
  }
  String? firstName;
  String? middleName;
  String? lastName;
  String? dateOfBirth;
  String? email;
  dynamic photo;
  int? companyId;
  String? employeeId;
  dynamic lookUpName;
  String? departmentName;
  String? designationName;
  String? reportingPerson;
  String? reportingPerson1;
  String? employeementDate;
  dynamic mobileNo;
  String? comm10;
  String? stateName;
  String? categoryName;
  String? paycaderID;
  String? subCatName;
  dynamic officialPhoneNo;
  String? branchName;
  bool? isChild;
  String? sbuId;
  dynamic extendedProbationDate;
  int? probation;
  dynamic probationPeriod;
  dynamic probationEndDate;
  dynamic probationExtendedEndDate;
  dynamic probationStatus;
  dynamic fnfNoticePeriod;
  dynamic noticePeriod;
  String? eemployeeStatus;
  String? eaddress;
  dynamic epersonalEmail;
  dynamic ecity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['middleName'] = middleName;
    map['lastName'] = lastName;
    map['dateOfBirth'] = dateOfBirth;
    map['email'] = email;
    map['photo'] = photo;
    map['companyId'] = companyId;
    map['employeeId'] = employeeId;
    map['lookUpName'] = lookUpName;
    map['departmentName'] = departmentName;
    map['designationName'] = designationName;
    map['reportingPerson'] = reportingPerson;
    map['reportingPerson1'] = reportingPerson1;
    map['employeementDate'] = employeementDate;
    map['mobileNo'] = mobileNo;
    map['comm10'] = comm10;
    map['stateName'] = stateName;
    map['categoryName'] = categoryName;
    map['paycaderID'] = paycaderID;
    map['subCatName'] = subCatName;
    map['officialPhoneNo'] = officialPhoneNo;
    map['branchName'] = branchName;
    map['isChild'] = isChild;
    map['sbuId'] = sbuId;
    map['extendedProbationDate'] = extendedProbationDate;
    map['probation'] = probation;
    map['probationPeriod'] = probationPeriod;
    map['probationEndDate'] = probationEndDate;
    map['probationExtendedEndDate'] = probationExtendedEndDate;
    map['probationStatus'] = probationStatus;
    map['fnfNoticePeriod'] = fnfNoticePeriod;
    map['noticePeriod'] = noticePeriod;
    map['eemployeeStatus'] = eemployeeStatus;
    map['eaddress'] = eaddress;
    map['epersonalEmail'] = epersonalEmail;
    map['ecity'] = ecity;
    return map;
  }
}
