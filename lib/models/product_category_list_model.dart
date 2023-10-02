class ProductCategoryListModel {
  int? id;
  String? name;
  int? displayOrder;
  String? categoryImage;
  int? isActive;
  int? isDelete;

  ProductCategoryListModel({
    this.id,
    this.name,
    this.displayOrder,
    this.categoryImage,
    this.isActive,
    this.isDelete,
  });

  factory ProductCategoryListModel.fromJson(Map<String, dynamic> json) => ProductCategoryListModel(
        id: json["id"],
        name: json["name"],
        displayOrder: json["displayOrder"],
        categoryImage: json["categoryImage"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "displayOrder": displayOrder,
        "categoryImage": categoryImage,
        "isActive": isActive,
        "isDelete": isDelete,
      };
}
