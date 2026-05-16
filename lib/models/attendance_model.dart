class AttendanceModel {

  final String id;

  final String totalHours;

  final String status;

  final String? punchInTime;

  final String? punchOutTime;

  AttendanceModel({

    required this.id,

    required this.totalHours,

    required this.status,

    this.punchInTime,

    this.punchOutTime,

  });

  factory AttendanceModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return AttendanceModel(

      id: json["_id"],

      totalHours:
      json["totalHours"] ?? "",

      status:
      json["status"] ?? "",

      punchInTime:
      json["punchInTime"]
      ?.toString(),

      punchOutTime:
      json["punchOutTime"]
      ?.toString(),

    );

  }

}