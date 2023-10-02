// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

class AssistantLanguageModel {
  int? id;
  String? name;
  bool? isCheck = false;

  AssistantLanguageModel({
    this.name,
    this.id,
    this.isCheck = false,
  });

  AssistantLanguageModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      name = json["languageName"];
    } catch (e) {
      print('Exception: assistant_language_list_model.dart - AssistantLanguageModel.fromJson(): ' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "languageName": name ?? "",
      };
}
