class dailyAttendanceModel {
  late DateTime actualInTime;
  late DateTime actualOutTime;
  late int mobilePunchInImage;
  late int mobilePunchOutImage;

  dailyAttendanceModel(
      {required this.actualInTime,
      required this.actualOutTime,
      required this.mobilePunchInImage,
      required this.mobilePunchOutImage});

  dailyAttendanceModel.fromJson(Map<String, dynamic> json) {
    actualInTime = json['actualInTime'];
    actualOutTime = json['actualOutTime'];
    mobilePunchInImage = json['mobilePunchInImage'];
    mobilePunchOutImage = json['mobilePunchOutImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actualInTime'] = actualInTime;
    data['actualOutTime'] = actualOutTime;
    data['mobilePunchInImage'] = mobilePunchInImage;
    data['mobilePunchOutImage'] = mobilePunchOutImage;

    return data;
  }
}
