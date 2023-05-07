import 'package:water_loss_project/constant/constant.dart';

class Report {
  /// Report info
  final String id;
  final String email;
  final String name;
  final String contactNumber;
  final int day;
  final int month;
  final int year;
  final DateTime timestamp;
  final String status;
  final DateTime timeReported;
  final DateTime timeRepaired;
  final String pipeSize;
  final double pipeSizeMM;
  final double waterLoss;
  final double mildLength;
  final double holeLength;
  final double holeWidth;
  final String damageType;
  final bool repaired;
  final String imageLink;
  final String department;
  final int timeInterval;
  final String reason;
  final double lat;
  final double lng;
  final String address;

  // Constructor
  Report({
    required this.id,
    required this.email,
    required this.name,
    required this.contactNumber,
    required this.day,
    required this.month,
    required this.year,
    required this.timestamp,
    required this.status,
    required this.timeReported,
    required this.timeRepaired,
    required this.pipeSize,
    required this.pipeSizeMM,
    required this.waterLoss,
    required this.mildLength,
    required this.holeLength,
    required this.holeWidth,
    required this.damageType,
    required this.repaired,
    required this.imageLink,
    required this.department,
    required this.timeInterval,
    required this.reason,
    required this.lat,
    required this.lng,
    required this.address,
  });

  /// factory user object
  factory Report.fromDocument(Map<String, dynamic> doc) {
    return Report(
      id: doc[REPORT_DOC_ID],
      email: doc[REPORT_EMAIL],
      name: doc[REPORT_NAME],
      contactNumber: doc[REPORT_CONTACT_NUMBER],
      day: doc[REPORT_DAY],
      month: doc[REPORT_MONTH],
      year: doc[REPORT_YEAR],
      timestamp: (doc[REPORT_TIMESTAMP]).toDate(),
      status: doc[REPORT_STATUS],
      timeReported: (doc[REPORT_TIME_REPORTED]).toDate(),
      timeRepaired: (doc[REPORT_TIME_REPAIRED]).toDate(),
      pipeSize: doc[REPORT_PIPE_SIZE] ?? "",
      pipeSizeMM: doc[REPORT_PIPE_SIZE_MM] ?? 0.0,
      waterLoss: doc[REPORT_WATER_LOSS].toDouble() ?? 0.0,
      mildLength: doc[REPORT_MILD_LENGTH] ?? 0.0,
      holeLength: doc[REPORT_HOLE_LENGTH] ?? 0.0,
      holeWidth: doc[REPORT_HOLE_WIDTH] ?? 0.0,
      damageType: doc[REPORT_DAMAGE_TYPE] ?? "",
      repaired: doc[REPORT_REPAIRD] ?? false,
      imageLink: doc[REPORT_IMAGE_LINK],
      department: doc[REPORT_DEPARTMENT] ?? "",
      timeInterval: doc[REPORT_TIME_INTERVAL] ?? 0,
      reason: doc[REPORT_REASON] ?? "",
      lat: doc[REPORT_LATITUDE] ?? 0,
      lng: doc[REPORT_LONGTITUDE] ?? 0,
      address: doc[REPORT_ADDRESS] ?? "",
    );
  }
}
