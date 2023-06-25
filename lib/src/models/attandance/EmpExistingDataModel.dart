class EmpExistingDataModel {
  EmpExistingDataModel({
    this.employeeId,
    this.actualInTime,
    this.actualOutTime,
    this.forDate,
    this.correctedInTime,
    this.correctedOutTime,
  });

  EmpExistingDataModel.fromJson(dynamic json) {
    employeeId = json['employeeId'];
    actualInTime = json['actualInTime'];
    actualOutTime = json['actualOutTime'];
    forDate = json['forDate'];
    correctedInTime = json['correctedInTime'];
    correctedOutTime = json['correctedOutTime'];
  }
  String? employeeId;
  String? actualInTime;
  String? actualOutTime;
  String? forDate;
  dynamic correctedInTime;
  dynamic correctedOutTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['employeeId'] = employeeId;
    map['actualInTime'] = actualInTime;
    map['actualOutTime'] = actualOutTime;
    map['forDate'] = forDate;
    map['correctedInTime'] = correctedInTime;
    map['correctedOutTime'] = correctedOutTime;
    return map;
  }
}
