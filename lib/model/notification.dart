class NotificationDTO {
  String id = "";
  String message = "";
  String subject = "Distress Call";
  double latitude = -0.0;
  double longitude = -0.0;
  String type = "";
  bool seen = false;
  int sort = -DateTime.now().millisecondsSinceEpoch;
  int time = DateTime.now().millisecondsSinceEpoch;

  NotificationDTO();
  NotificationDTO.fromMap(Map<dynamic, dynamic> data){
    type = data['type'] ?? '';
    message = data['message'] ?? '';
    subject = data['subject'] ?? '';
    latitude = data['latitude'] ?? -0.0;
    longitude = data['longitude'] ?? -0.0;
    seen = data['seen'] ?? false;
    sort = data['sort'] ?? -DateTime.now().millisecondsSinceEpoch;
    time = data['time'] ?? DateTime.now().millisecondsSinceEpoch;
  }

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
