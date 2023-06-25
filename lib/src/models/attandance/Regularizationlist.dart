class RegularizationlistModel {
  RegularizationlistModel({
    this.id,
    this.employeeId,
    this.onNextDay,
    this.requestType,
    this.startDate,
    this.inTime,
    this.outTime,
    this.createdDate,
    this.createdDateString,
    this.cancelReason,
    this.finalStatus,
    this.endDate,
    this.oneDayOut,
    this.companyID,
    this.rep1Status,
    this.rep2Status,
    this.coffType,
    this.totalWorked,
    this.coffFullHalfValue,
    this.leaveCode,
    this.leaveDuration,
    this.noOfDays,
    this.repNumber,
    this.systemWorkflowMode,
    this.otherStatus,
    this.childAcceptStatusNumber,
    this.coffApplyDate,
    this.coffApproveDate,
    this.coffApproveById,
    this.typeDuration,
    this.coffApplyReason,
    this.isCoffPaymentApplicable,
    this.anotherRep1Status,
    this.anotherRep2Status,
    this.anotherFinalStatus,
    this.cnStatus,
    this.comm5,
    this.attachment,
    this.remark,
    this.rep1Remark,
    this.rep2Remark,
    this.finalRemark,
    this.leaveBalance,
    this.coffConfig,
    this.coffEncashMonth,
    this.coffEncashYear,
    this.coffEncashFormula,
    this.encashApprovedBy,
    this.encashApprovedDate,
    this.encashedAmount,
    this.totalWorkedDays,
    this.coffApprovedDays,
    this.coffPendingDays,
    this.coffRemainingDays,
    this.extraWorkingId,
    this.extraWorkFinalStatusBy,
    this.extraWorkFinalStatusRemark,
    this.rep1FinalOvertimeHours,
    this.rep2FinalOvertimeHours,
    this.extraWorkFinalStatusFinalOvertimeHours,
    this.rep1StatusDate,
    this.rep2StatusDate,
    this.reportingOTHours,
    this.workType,
    this.createdBy,
    this.primaryManagerId,
    this.secondaryManagerId,
    this.primaryManagerApprovalDate,
    this.secondaryManagerApprovalDate,
    this.modifiedBy,
    this.modifiedDate,
    this.parentalSubType,
    this.isConvertableOT,
    this.isConvertedFromOT,
  });

  RegularizationlistModel.fromJson(dynamic json) {
    id = json['id'];
    employeeId = json['employeeId'];
    onNextDay = json['onNextDay'];
    requestType = json['requestType'];
    startDate = json['startDate'];
    inTime = json['inTime'];
    outTime = json['outTime'];
    createdDate = json['createdDate'];
    createdDateString = json['createdDateString'];
    cancelReason = json['cancelReason'];
    finalStatus = json['finalStatus'];
    endDate = json['endDate'];
    oneDayOut = json['oneDayOut'];
    companyID = json['companyID'];
    rep1Status = json['rep1Status'];
    rep2Status = json['rep2Status'];
    coffType = json['coffType'];
    totalWorked = json['totalWorked'];
    coffFullHalfValue = json['coffFullHalfValue'];
    leaveCode = json['leaveCode'];
    leaveDuration = json['leaveDuration'];
    noOfDays = json['noOfDays'];
    repNumber = json['repNumber'];
    systemWorkflowMode = json['systemWorkflowMode'];
    otherStatus = json['otherStatus'];
    childAcceptStatusNumber = json['childAcceptStatusNumber'];
    coffApplyDate = json['coffApplyDate'];
    coffApproveDate = json['coffApproveDate'];
    coffApproveById = json['coffApproveById'];
    typeDuration = json['typeDuration'];
    coffApplyReason = json['coffApplyReason'];
    isCoffPaymentApplicable = json['isCoffPaymentApplicable'];
    anotherRep1Status = json['anotherRep1Status'];
    anotherRep2Status = json['anotherRep2Status'];
    anotherFinalStatus = json['anotherFinalStatus'];
    cnStatus = json['cnStatus'];
    comm5 = json['comm5'];
    attachment = json['attachment'];
    remark = json['remark'];
    rep1Remark = json['rep1Remark'];
    rep2Remark = json['rep2Remark'];
    finalRemark = json['finalRemark'];
    leaveBalance = json['leaveBalance'];
    coffConfig = json['coffConfig'];
    coffEncashMonth = json['coffEncashMonth'];
    coffEncashYear = json['coffEncashYear'];
    coffEncashFormula = json['coffEncashFormula'];
    encashApprovedBy = json['encashApprovedBy'];
    encashApprovedDate = json['encashApprovedDate'];
    encashedAmount = json['encashedAmount'];
    totalWorkedDays = json['totalWorkedDays'];
    coffApprovedDays = json['coffApprovedDays'];
    coffPendingDays = json['coffPendingDays'];
    coffRemainingDays = json['coffRemainingDays'];
    extraWorkingId = json['extraWorkingId'];
    extraWorkFinalStatusBy = json['extraWorkFinalStatusBy'];
    extraWorkFinalStatusRemark = json['extraWorkFinalStatusRemark'];
    rep1FinalOvertimeHours = json['rep1FinalOvertimeHours'];
    rep2FinalOvertimeHours = json['rep2FinalOvertimeHours'];
    extraWorkFinalStatusFinalOvertimeHours =
        json['extraWorkFinalStatusFinalOvertimeHours'];
    rep1StatusDate = json['rep1StatusDate'];
    rep2StatusDate = json['rep2StatusDate'];
    reportingOTHours = json['reportingOTHours'];
    workType = json['workType'];
    createdBy = json['createdBy'];
    primaryManagerId = json['primaryManagerId'];
    secondaryManagerId = json['secondaryManagerId'];
    primaryManagerApprovalDate = json['primaryManagerApprovalDate'];
    secondaryManagerApprovalDate = json['secondaryManagerApprovalDate'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    parentalSubType = json['parentalSubType'];
    isConvertableOT = json['isConvertableOT'];
    isConvertedFromOT = json['isConvertedFromOT'];
  }
  String? id;
  String? employeeId;
  dynamic onNextDay;
  String? requestType;
  String? startDate;
  String? inTime;
  String? outTime;
  String? createdDate;
  String? createdDateString;
  String? cancelReason;
  String? finalStatus;
  String? endDate;
  String? oneDayOut;
  int? companyID;
  String? rep1Status;
  String? rep2Status;
  dynamic coffType;
  dynamic totalWorked;
  dynamic coffFullHalfValue;
  dynamic leaveCode;
  dynamic leaveDuration;
  dynamic noOfDays;
  int? repNumber;
  dynamic systemWorkflowMode;
  dynamic otherStatus;
  dynamic childAcceptStatusNumber;
  dynamic coffApplyDate;
  dynamic coffApproveDate;
  dynamic coffApproveById;
  dynamic typeDuration;
  dynamic coffApplyReason;
  dynamic isCoffPaymentApplicable;
  dynamic anotherRep1Status;
  dynamic anotherRep2Status;
  dynamic anotherFinalStatus;
  int? cnStatus;
  dynamic comm5;
  dynamic attachment;
  dynamic remark;
  dynamic rep1Remark;
  String? rep2Remark;
  dynamic finalRemark;
  dynamic leaveBalance;
  dynamic coffConfig;
  int? coffEncashMonth;
  int? coffEncashYear;
  dynamic coffEncashFormula;
  dynamic encashApprovedBy;
  dynamic encashApprovedDate;
  double? encashedAmount;
  dynamic totalWorkedDays;
  dynamic coffApprovedDays;
  dynamic coffPendingDays;
  dynamic coffRemainingDays;
  dynamic extraWorkingId;
  dynamic extraWorkFinalStatusBy;
  dynamic extraWorkFinalStatusRemark;
  dynamic rep1FinalOvertimeHours;
  dynamic rep2FinalOvertimeHours;
  dynamic extraWorkFinalStatusFinalOvertimeHours;
  dynamic rep1StatusDate;
  dynamic rep2StatusDate;
  dynamic reportingOTHours;
  dynamic workType;
  String? createdBy;
  dynamic primaryManagerId;
  dynamic secondaryManagerId;
  dynamic primaryManagerApprovalDate;
  dynamic secondaryManagerApprovalDate;
  String? modifiedBy;
  String? modifiedDate;
  dynamic parentalSubType;
  dynamic isConvertableOT;
  dynamic isConvertedFromOT;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['employeeId'] = employeeId;
    map['onNextDay'] = onNextDay;
    map['requestType'] = requestType;
    map['startDate'] = startDate;
    map['inTime'] = inTime;
    map['outTime'] = outTime;
    map['createdDate'] = createdDate;
    map['createdDateString'] = createdDateString;
    map['cancelReason'] = cancelReason;
    map['finalStatus'] = finalStatus;
    map['endDate'] = endDate;
    map['oneDayOut'] = oneDayOut;
    map['companyID'] = companyID;
    map['rep1Status'] = rep1Status;
    map['rep2Status'] = rep2Status;
    map['coffType'] = coffType;
    map['totalWorked'] = totalWorked;
    map['coffFullHalfValue'] = coffFullHalfValue;
    map['leaveCode'] = leaveCode;
    map['leaveDuration'] = leaveDuration;
    map['noOfDays'] = noOfDays;
    map['repNumber'] = repNumber;
    map['systemWorkflowMode'] = systemWorkflowMode;
    map['otherStatus'] = otherStatus;
    map['childAcceptStatusNumber'] = childAcceptStatusNumber;
    map['coffApplyDate'] = coffApplyDate;
    map['coffApproveDate'] = coffApproveDate;
    map['coffApproveById'] = coffApproveById;
    map['typeDuration'] = typeDuration;
    map['coffApplyReason'] = coffApplyReason;
    map['isCoffPaymentApplicable'] = isCoffPaymentApplicable;
    map['anotherRep1Status'] = anotherRep1Status;
    map['anotherRep2Status'] = anotherRep2Status;
    map['anotherFinalStatus'] = anotherFinalStatus;
    map['cnStatus'] = cnStatus;
    map['comm5'] = comm5;
    map['attachment'] = attachment;
    map['remark'] = remark;
    map['rep1Remark'] = rep1Remark;
    map['rep2Remark'] = rep2Remark;
    map['finalRemark'] = finalRemark;
    map['leaveBalance'] = leaveBalance;
    map['coffConfig'] = coffConfig;
    map['coffEncashMonth'] = coffEncashMonth;
    map['coffEncashYear'] = coffEncashYear;
    map['coffEncashFormula'] = coffEncashFormula;
    map['encashApprovedBy'] = encashApprovedBy;
    map['encashApprovedDate'] = encashApprovedDate;
    map['encashedAmount'] = encashedAmount;
    map['totalWorkedDays'] = totalWorkedDays;
    map['coffApprovedDays'] = coffApprovedDays;
    map['coffPendingDays'] = coffPendingDays;
    map['coffRemainingDays'] = coffRemainingDays;
    map['extraWorkingId'] = extraWorkingId;
    map['extraWorkFinalStatusBy'] = extraWorkFinalStatusBy;
    map['extraWorkFinalStatusRemark'] = extraWorkFinalStatusRemark;
    map['rep1FinalOvertimeHours'] = rep1FinalOvertimeHours;
    map['rep2FinalOvertimeHours'] = rep2FinalOvertimeHours;
    map['extraWorkFinalStatusFinalOvertimeHours'] =
        extraWorkFinalStatusFinalOvertimeHours;
    map['rep1StatusDate'] = rep1StatusDate;
    map['rep2StatusDate'] = rep2StatusDate;
    map['reportingOTHours'] = reportingOTHours;
    map['workType'] = workType;
    map['createdBy'] = createdBy;
    map['primaryManagerId'] = primaryManagerId;
    map['secondaryManagerId'] = secondaryManagerId;
    map['primaryManagerApprovalDate'] = primaryManagerApprovalDate;
    map['secondaryManagerApprovalDate'] = secondaryManagerApprovalDate;
    map['modifiedBy'] = modifiedBy;
    map['modifiedDate'] = modifiedDate;
    map['parentalSubType'] = parentalSubType;
    map['isConvertableOT'] = isConvertableOT;
    map['isConvertedFromOT'] = isConvertedFromOT;
    return map;
  }
}
