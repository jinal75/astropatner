import 'package:flutter/material.dart';

class KundliGender {
  String? title;
  bool? isSelected;
  String? image;
  KundliGender({this.title, this.isSelected, this.image});
}

class Kundli {
  IconData? icon;
  bool? isSelected;
  Kundli({this.icon, this.isSelected});
}

class KundliDetailTab {
  String title;
  bool isSelected;
  KundliDetailTab({required this.title, required this.isSelected});
}

class KundliDetails {
  String? title;
  String? value;
  KundliDetails({this.title, this.value});
}
