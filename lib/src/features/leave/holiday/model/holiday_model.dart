class HolidayModel {
  HolidayModel({
    this.holidayId,
    this.holidayName,
    this.holidayDate,
    this.holidayType,
    this.isHolidayTaken,
    this.isOptionalHoliday,
    this.isContinuousHoliday,
    this.type,
    this.hbranchId,
  });

  HolidayModel.fromJson(dynamic json) {
    holidayId = json['holidayId'];
    holidayName = json['holidayName'];
    holidayDate = json['holidayDate'];
    holidayType = json['holidayType'];
    isHolidayTaken = json['isHolidayTaken'];
    isOptionalHoliday = json['isOptionalHoliday'];
    isContinuousHoliday = json['isContinuousHoliday'];
    type = json['type'];
    hbranchId = json['hbranchId'];
  }

  int? holidayId;
  String? holidayName;
  String? holidayDate;
  dynamic? holidayType;
  dynamic? isHolidayTaken;
  int? isOptionalHoliday;
  bool? isContinuousHoliday;
  String? type;
  dynamic? hbranchId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['holidayId'] = holidayId;
    map['holidayName'] = holidayName;
    map['holidayDate'] = holidayDate;
    map['holidayType'] = holidayType;
    map['isHolidayTaken'] = isHolidayTaken;
    map['isOptionalHoliday'] = isOptionalHoliday;
    map['isContinuousHoliday'] = isContinuousHoliday;
    map['type'] = type;
    map['hbranchId'] = hbranchId;
    return map;
  }
}
