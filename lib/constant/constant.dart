import 'dart:ui';

import 'package:water_loss_project/data/department.dart';

const COLOR_GREEN = Color(0xff11751d);
const COLOR_LIGHT_GREEN = Color(0xffc1ffbf);

// Status types
const STATUS_SUBMITTED = "Submitted";
const STATUS_CONFIRMED = "Confirmed";
const STATUS_REPAIRED = "Repaired";

// COLLECTION
const C_ACCOUNTS = "Accounts";
const C_REPORTS = "Reports";
const C_DEPARTMENTS = "Departments";

// DATABASE USER FIELDS
const USER_DOC_ID = "document_id";
const USER_NAME = "name";
const USER_EMAIL = "email";
const USER_CONTACT_NUMBER = "contact_number";
const USER_DEPARTMENT = "department";
const USER_OCCUPATION = "occupation";
const USER_TYPE = "user_type";
const USER_CREATED_AT = "created_at";
const USER_UPDATED_AT = "updated_at";

// DATABASE REPORTS FIELDS
const REPORT_ID = "id";
const REPORT_EMAIL = "email";
const REPORT_NAME = "name";
const REPORT_CONTACT_NUMBER = "contact_number";
const REPORT_DAY = "day";
const REPORT_MONTH = "month";
const REPORT_YEAR = "year";
const REPORT_TIMESTAMP = "timestamp";
const REPORT_STATUS = "status";
const REPORT_TIME_REPORTED = "time_reported";
const REPORT_TIME_REPAIRED = "time_repaired";
const REPORT_PIPE_SIZE = "pipe_size";
const REPORT_PIPE_SIZE_MM = "pipe_size_mm";
const REPORT_WATER_LOSS = "water_loss";
const REPORT_DAMAGE_TYPE = "damage_type";
const REPORT_IMAGE_LINK = "image_link";
const REPORT_REPAIRD = "repaired";
const REPORT_DEPARTMENT = "department";
const REPORT_DOC_ID = "document_id";
const REPORT_MILD_LENGTH = "mild_length";
const REPORT_HOLE_LENGTH = "hole_length";
const REPORT_HOLE_WIDTH = "hole_width";
const REPORT_TIME_INTERVAL = "time_interval";
const REPORT_REASON = "reason";

// DEPARTMENT
const DEPARTMENT = "department";
const HEIGHT = "height";

// List<Department> DEPARTMENT_LISTS = [
//   Department(department: "CCJS", height: 1.02),
//   Department(department: "COED", height: 1.22),
//   Department(department: "COM", height: 1.22),
//   Department(department: "COM 2nd building", height: 1.52),
//   Department(department: "CAT", height: 1.52),
//   Department(department: "CET", height: 1.78),
//   Department(department: "CCIS", height: 1.02),
//   Department(department: "OFFICE OF THE REGISTRAR", height: 1.35),
//   Department(department: "CASHIER'S OFFICE", height: 1.02),
//   Department(department: "SAS", height: 1.52),
//   Department(department: "OFFICE OF THE PRESIDENT", height: 1.52),
//   Department(department: "LIBRARY", height: 1.35),
//   Department(department: "NWSSU HOTEL", height: 1.35),
//   Department(department: "BDC", height: 1.02),
// ];
