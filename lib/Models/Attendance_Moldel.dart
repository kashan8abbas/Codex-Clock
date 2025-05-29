class AttendanceModel {
  final String date; // e.g., "02 May"
  final String checkIn;
  final String checkOut;
  final String hours;
  final String status;

  AttendanceModel({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.hours,
    required this.status,
  });
}
