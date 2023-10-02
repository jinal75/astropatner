// ignore_for_file: avoid_print, file_names
class AvailabilityTimeModel {
  int? id;
  int? astrologerId;
  String? status;
  DateTime? waitTime;

  AvailabilityTimeModel({this.id, this.astrologerId, this.status, this.waitTime});

  AvailabilityTimeModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      astrologerId = json["astrologerId"];
      status = json["name"] ?? "";
      waitTime = DateTime.parse(json["waitTime"] ?? DateTime.now().toIso8601String());
    } catch (e) {
      print("Exception - AvailabilityTimeModel.dart - AvailabilityTimeModel.fromJson(): ${e.toString()}");
    }
  }

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "astrologerId": astrologerId,
        "status": status,
        "waitTime": waitTime != null ? waitTime!.toIso8601String() : null,
      };
}
