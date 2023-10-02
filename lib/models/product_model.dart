import 'package:astrologer_app/models/image_model.dart';

class ProductModel {
  int? id;
  String? getproductImage;
  ImageModel? sentProductImage = ImageModel();
  String? title;
  int? price;
  String? description;
  int? categoryId;
  int? isActive;
  int? isDelete;

  ProductModel({
    this.id,
    this.getproductImage,
    this.sentProductImage,
    this.title,
    this.price,
    this.description,
    this.categoryId,
    this.isActive,
    this.isDelete,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        getproductImage: json["productImage"],
        title: json["name"],
        price: json["amount"],
        description: json["description"],
        categoryId: json["productCategoryId"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productImage": getproductImage,
        "name": title,
        "amount": price,
        "description": description,
        "productCategoryId": categoryId,
        "isActive": isActive,
        "isDelete": isDelete,
      };
}
