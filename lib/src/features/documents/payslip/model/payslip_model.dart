class PayslipModel {
  PayslipModel({
    this.empId,
    this.year,
    this.month,
    this.fromMonthAndYear,
    this.toMonthAndYear,
    this.date,
  });

  PayslipModel.fromJson(dynamic json) {
    empId = json['empId'];
    year = json['year'];
    month = json['month'];
    fromMonthAndYear = json['fromMonthAndYear'];
    toMonthAndYear = json['toMonthAndYear'];
    date = json['date'];
  }

  String? empId;
  int? year;
  int? month;
  dynamic fromMonthAndYear;
  dynamic toMonthAndYear;
  String? date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['empId'] = empId;
    map['year'] = year;
    map['month'] = month;
    map['fromMonthAndYear'] = fromMonthAndYear;
    map['toMonthAndYear'] = toMonthAndYear;
    map['date'] = date;
    return map;
  }
}
