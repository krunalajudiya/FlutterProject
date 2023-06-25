class LeaveCodeUserModel {
  dynamic leaveId;
  dynamic leaveCodeName;
  dynamic leaveType;
  dynamic leaveSubType;
  dynamic docUpload;
  dynamic docUploadReqDays;
  dynamic remainingLeaveBalance;
  dynamic approvedLeaves;
  dynamic appliedLeaves;
  dynamic leavePolicyId;
  dynamic showInLeaveRequestBalance;

  LeaveCodeUserModel(
      {this.leaveId,
      this.leaveCodeName,
      this.leaveType,
      this.leaveSubType,
      this.docUpload,
      this.docUploadReqDays,
      this.remainingLeaveBalance,
      this.approvedLeaves,
      this.appliedLeaves,
      this.leavePolicyId,
      this.showInLeaveRequestBalance});

  LeaveCodeUserModel.fromJson(Map<String, dynamic> json) {
    leaveId = json['leaveId'];
    leaveCodeName = json['leaveCodeName'];
    leaveType = json['leaveType'];
    leaveSubType = json['leaveSubType'];
    docUpload = json['docUpload'];
    docUploadReqDays = json['docUploadReqDays'];
    remainingLeaveBalance = json['remainingLeaveBalance'];
    approvedLeaves = json['approvedLeaves'];
    appliedLeaves = json['appliedLeaves'];
    leavePolicyId = json['leavePolicyId'];
    showInLeaveRequestBalance = json['showInLeaveRequestBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leaveId'] = leaveId;
    data['leaveCodeName'] = leaveCodeName;
    data['leaveType'] = leaveType;
    data['leaveSubType'] = leaveSubType;
    data['docUpload'] = docUpload;
    data['docUploadReqDays'] = docUploadReqDays;
    data['remainingLeaveBalance'] = remainingLeaveBalance;
    data['approvedLeaves'] = approvedLeaves;
    data['appliedLeaves'] = appliedLeaves;
    data['leavePolicyId'] = leavePolicyId;
    data['showInLeaveRequestBalance'] = showInLeaveRequestBalance;
    return data;
  }
}
