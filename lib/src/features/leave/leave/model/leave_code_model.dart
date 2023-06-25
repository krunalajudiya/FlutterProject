class LeaveCodeModel {
  LeaveCodeModel({
    this.id,
    this.leaveCodeName,
    this.leaveType,
    this.leaveCodePrefix,
    this.leaveDescription,
    this.leaveSubType,
    this.leaveSubTypeValue,
    this.typeOfAnniversary,
    this.leaveCodeStatus,
    this.isGeneratedPolicy,
    this.orderBy,
    this.order,
    this.count,
  });

  LeaveCodeModel.fromJson(dynamic json) {
    id = json['id'];
    leaveCodeName = json['leaveCodeName'];
    leaveType = json['leaveType'];
    leaveCodePrefix = json['leaveCodePrefix'];
    leaveDescription = json['leaveDescription'];
    leaveSubType = json['leaveSubType'];
    leaveSubTypeValue = json['leaveSubTypeValue'];
    typeOfAnniversary = json['typeOfAnniversary'];
    leaveCodeStatus = json['leaveCodeStatus'];
    isGeneratedPolicy = json['isGeneratedPolicy'];
    orderBy = json['orderBy'];
    order = json['order'];
    count = json['count'];
  }

  int? id;
  String? leaveCodeName;
  String? leaveType;
  String? leaveCodePrefix;
  String? leaveDescription;
  String? leaveSubType;
  String? leaveSubTypeValue;
  dynamic typeOfAnniversary;
  String? leaveCodeStatus;
  dynamic isGeneratedPolicy;
  dynamic orderBy;
  dynamic order;
  dynamic count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['leaveCodeName'] = leaveCodeName;
    map['leaveType'] = leaveType;
    map['leaveCodePrefix'] = leaveCodePrefix;
    map['leaveDescription'] = leaveDescription;
    map['leaveSubType'] = leaveSubType;
    map['leaveSubTypeValue'] = leaveSubTypeValue;
    map['typeOfAnniversary'] = typeOfAnniversary;
    map['leaveCodeStatus'] = leaveCodeStatus;
    map['isGeneratedPolicy'] = isGeneratedPolicy;
    map['orderBy'] = orderBy;
    map['order'] = order;
    map['count'] = count;
    return map;
  }
}
