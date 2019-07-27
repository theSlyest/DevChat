class NotificationDTO {
  String message = "";
  String subject = "Distress Call";
  double latitude = -0.0;
  double longitude = -0.0;
  String type = "";
  int sort = -DateTime.now().millisecondsSinceEpoch;
  int time = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "message": message,
      "subject": subject,
      "latitude": latitude,
      "longitude": longitude,
      "sort": sort,
      "time": time,
    };
  }
}
