// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:astrologer_app/models/time_availability_model.dart';

class Week {
  String? day;
  List<TimeAvailabilityModel>? timeAvailabilityList;

  Week({
    this.day,
    this.timeAvailabilityList,
  });

  Week.fromJson(Map<String, dynamic> json) {
    try {
      day = json["day"] ?? '';
      timeAvailabilityList = (json["time"] != null && json['time'] != []) ? List<TimeAvailabilityModel>.from(json['time'].map((e) => TimeAvailabilityModel.fromJson(e))) : [];
    } catch (e) {
      print('Exception: week_model.dart - Week.fromJson(): ' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "day": day ?? '',
        "time": timeAvailabilityList ?? [],
      };
}
