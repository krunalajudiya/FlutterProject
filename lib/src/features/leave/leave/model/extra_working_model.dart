class ExtraWorkingModel {
  ExtraWorkingModel({
    this.id,
    this.extraWorkingDate,
    this.expiryDate,
    this.totalWorkedDays,
    this.coffApprovedDays,
    this.coffPendingDays,
    this.coffRemainingDays,
  });

  ExtraWorkingModel.fromJson(dynamic json) {
    id = json['id'];
    extraWorkingDate = json['extraWorkingDate'];
    expiryDate = json['expiryDate'];
    totalWorkedDays = json['totalWorkedDays'];
    coffApprovedDays = json['coffApprovedDays'];
    coffPendingDays = json['coffPendingDays'];
    coffRemainingDays = json['coffRemainingDays'];
  }

  String? id;
  String? extraWorkingDate;
  String? expiryDate;
  String? totalWorkedDays;
  String? coffApprovedDays;
  String? coffPendingDays;
  String? coffRemainingDays;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['extraWorkingDate'] = extraWorkingDate;
    map['expiryDate'] = expiryDate;
    map['totalWorkedDays'] = totalWorkedDays;
    map['coffApprovedDays'] = coffApprovedDays;
    map['coffPendingDays'] = coffPendingDays;
    map['coffRemainingDays'] = coffRemainingDays;
    return map;
  }
}
