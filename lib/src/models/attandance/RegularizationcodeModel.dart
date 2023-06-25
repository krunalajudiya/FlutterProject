class RegularizationcodeModel {
  RegularizationcodeModel({
    this.id,
    this.policyId,
    this.regType,
    this.timeLimit,
    this.instanceLimit,
    this.countInTotal,
    this.status,
  });

  RegularizationcodeModel.fromJson(dynamic json) {
    id = json['id'];
    policyId = json['policyId'];
    regType = json['regType'];
    timeLimit = json['timeLimit'];
    instanceLimit = json['instanceLimit'];
    countInTotal = json['countInTotal'];
    status = json['status'];
  }
  String? id;
  int? policyId;
  String? regType;
  dynamic timeLimit;
  dynamic instanceLimit;
  bool? countInTotal;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['policyId'] = policyId;
    map['regType'] = regType;
    map['timeLimit'] = timeLimit;
    map['instanceLimit'] = instanceLimit;
    map['countInTotal'] = countInTotal;
    map['status'] = status;
    return map;
  }
}
