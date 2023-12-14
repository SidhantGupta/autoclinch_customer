// To parse this JSON data, do
//
//     final attendanceModel = attendanceModelFromJson(jsonString);

import 'dart:convert';

AttendanceModel attendanceModelFromJson(String str) => AttendanceModel.fromJson(json.decode(str));

class AttendanceModel {
  AttendanceModel({
    this.attendance,
  });

  Attendance? attendance;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
        attendance: Attendance.fromJson(json["data"]),
      );
}

class Attendance {
  Attendance({
    this.present,
    this.absent,
    this.notMarked,
    this.notAvailable
  });

  List<DateTime>? present;
  List<DateTime>? absent;
  List<DateTime>? notMarked;
  List<DateTime>? notAvailable;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        present: json["present"] == null ? null : List<DateTime>.from(json["present"].map((x) => DateTime.parse(x))),
        absent: json["absent"] == null ? null : List<DateTime>.from(json["absent"].map((x) => DateTime.parse(x))),
        notMarked:
            json["not_marked"] == null ? null : List<DateTime>.from(json["not_marked"].map((x) => DateTime.parse(x))),
    notAvailable:
    json["not_available"] == null ? null : List<DateTime>.from(json["not_available"].map((x) => DateTime.parse(x))),
      );
}
