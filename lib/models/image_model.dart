// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'dart:typed_data';

class ImageModel {
  int? id;
  String? imgPath;
  dynamic imageData;
  dynamic img;
  dynamic userImageWeb;
  String? description;
  String? alt;

  ImageModel({
    this.id,
    this.imgPath,
    this.imageData,
    this.img,
    this.userImageWeb,
    this.description,
    this.alt,
  });

  ImageModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      imgPath = json['imgPath'];
      description = json['description'];
      alt = json['alt'];
      imageData = json['imageData'];
      img = Uint8List.fromList(List<int>.from(json['imageData']['data']));
    } catch (e) {
      print("Exception - imageModel.dart -  ImageModel.fromJson(): " + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'imgPath': imgPath,
        'imageData': imageData,
        'description': description,
        'alt': alt,
      };
}
