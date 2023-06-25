class Urls {
  static const updateUrl = true;

  //BASE URL
  static const baseUrl = 'http://115.246.27.38:9999/api/';

  //LOGIN APIS START
  static const validateCompanyUrl =
      '${baseUrl}auth/validateCompanyName?companyName='; // GET
  static const validateUserUrl = '${baseUrl}auth/signin'; // POST
  //LOGIN APIS END

// DAILY ATTENDANCE APIS START //
  static const fetchDailyAttendanceData =
      '${baseUrl}daily-attendance-v1/attendance-detail/'; // GET
  static const punchInOut =
      '${baseUrl}daily-attendance-v1/multiple-punch-in-out'; //POST
// DAILY ATTENDANCE APIS END //

//leave APIS START//

  //fetch holiday list
  static const fetchHolidayList =
      '${baseUrl}holidayallocation/foremployee'; //POST
  //fetch leaverequest list
  static const fetchLeaveRequestList = '${baseUrl}leave/getAllLeaveReq/'; //POST
  //fetch leave code data
  static const fetchLeaveCodeData = '${baseUrl}leave-code/active'; //GET
  //fetch leave
  static const fetchLeaveBalanceData =
      '${baseUrl}v1/leave/user-balance?userId='; //POST
  //fetch user holiday data
  static const fetchHolidayUserData = '$baseUrl/holidayallocation/employee/';
  //fetch user extra working data
  static const fetchExtraWorkingData =
      '${baseUrl}v1/leave/extraworkinglist/'; //POST
  //fetch user leavedays data
  static const fetchUserLeaveDaysData =
      '${baseUrl}v1/leave/user-leaveDays'; //POST
  //leave request
  static const leaveRequest = '${baseUrl}v1/leave/leaveRequest'; //POST
  //get extraworking list
  static const fetchExtraWorkingList =
      "${baseUrl}extraworking/getAllExtraWorkingDaysRequest/";

  //get user shift time in extraworking
  static const fetchUserShiftTime =
      "${baseUrl}attendance/get-attendance-date-employee"; //GET
  //extraworking request
  static const extraWorkingRequest =
      "${baseUrl}extraworking/extraWorkingApplicationRequest"; //POST

//leave APIS END//

//Fetch employee data APIS

  static const fetchEmployeeList = '${baseUrl}employee/getAllEmployeeList';

//APIS END

// CORRECTION LIST //
  static const correctionListData =
      '${baseUrl}attendance/getAllAttendanceCorrectionReq/';

// REGULARIZATION LIST //
  static const regularizationListData =
      '${baseUrl}leave/getAllRegularizationPendingReq/';

//documents API start//

//fetch payslip data
  static const fetchPayslipData =
      "${baseUrl}employee/getSalaryMonthsandYear/"; //GET
//fetch payslip download data
  static const fetchPayslipDownloadData =
      "${baseUrl}employee/downloadPaySlip"; //POST
//fetch cumulative payslip data
  static const fetchCumulativePayslipDownloadData =
      "${baseUrl}employee/downloadCumulativePaySlipPDF"; //POST
//fetch hr policydocument list
  static const fetchHrPolicayDocument =
      "${baseUrl}hrDocument/getHrDocumentNew"; //GET

//documents API End//

  //fetch regularization code data
  static const fetchRegularizationCodeData =
      '${baseUrl}leave/getAllReguRequestTypesByEmployeeId/';

// ATTENDANCE REGULARIZATION REQUEST
  static const attendanceRegularizationRequest =
      "${baseUrl}leave/attendanceRegularizationRequest"; // POST

//ATTENDANCE CORRECTION REQUEST
  static const attendanceCorrectionRequest =
      "${baseUrl}attendance/approveCorrectionRequest";

//CORRECTION FETCH EMPLOYEE EXISTING DATA
  static const attendanceExistingData =
      "${baseUrl}attendance/get-attendance-date-employee/";

//separation API start//

  //fetch sperationlist data
  static const fetchSeperationDataList =
      "${baseUrl}resignationMaster/findAllSeparationApprovalList"; //POST

//separation API End//
}
