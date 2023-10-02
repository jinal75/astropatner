class HighestQualificationModel {
  int? id;
  String? qualificationName;

  HighestQualificationModel({
    this.qualificationName,
    this.id,  
  });

  factory HighestQualificationModel.fromJson(Map<String, dynamic> json) => HighestQualificationModel(
        id: json["id"],
        qualificationName: json["qualificationName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "qualificationName": qualificationName,
      };
}
