class DaysModel{
   String? days;  

  DaysModel({
    this.days,
  });

  Map<String, dynamic> toJson() => {
        "days": days,        
      };
}