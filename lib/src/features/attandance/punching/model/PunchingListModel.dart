import 'dart:convert';

PunchingListModel punchingListModelFromJson(String str) =>
    PunchingListModel.fromJson(json.decode(str));
String punchingListModelToJson(PunchingListModel data) =>
    json.encode(data.toJson());

class PunchingListModel {
  PunchingListModel({
    this.srNO,
    this.inTime,
    this.outTime,
    this.duration,
  });

  PunchingListModel.fromJson(dynamic json) {
    srNO = json['srNO'];
    inTime = json['inTime'];
    outTime = json['outTime'];
    duration = json['duration'];
  }
  String? srNO;
  String? inTime;
  String? outTime;
  String? duration;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['srNO'] = srNO;
    map['inTime'] = inTime;
    map['outTime'] = outTime;
    map['duration'] = duration;
    return map;
  }
}
