class MyAssistantModel {
  int? id;
  String? name;

  MyAssistantModel({
    this.id,
    this.name,
  });

  factory MyAssistantModel.fromJson(Map<String, dynamic> json) => MyAssistantModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
