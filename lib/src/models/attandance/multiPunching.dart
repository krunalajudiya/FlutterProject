class MultiPunchingModel {
  late String employeeId;
  late String punchInOrOut;
  late String regReason;
  late double currentLatitude;
  late double currentLongitude;
  late String punchInOutImage;

  MultiPunchingModel(
      {required this.employeeId,
      required this.punchInOrOut,
      required this.currentLatitude,
      required this.currentLongitude,
      required this.punchInOutImage});

  MultiPunchingModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    punchInOrOut = json['punchInOrOut'];
    punchInOutImage = json['punchInOutImage'];

    currentLatitude = json['currentLatitude'];
    currentLongitude = json['currentLongitude'];
  }

  Map<String, Object> toJson() {
    final Map<String, Object> data = <String, Object>{};
    data['employeeId'] = employeeId;
    data['punchInOrOut'] = punchInOrOut;
    data['currentLatitude'] = currentLatitude;
    data['currentLongitude'] = currentLongitude;
    data['punchInOutImage'] = punchInOutImage;
    return data;
  }
}
