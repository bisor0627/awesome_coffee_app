import 'dart:convert';

class CafeModel {
  String name;
  String link;
  String location;
  String? scale;
  String? operatingTime;
  String? congestion;
  String? priceRange;
  String? placeFeatures;
  String? hasSocket;
  String howManySocket;
  String? hasWifi;
  String howFastWifi;
  String otherFeatures;
  CafeModel({
    required this.name,
    required this.link,
    required this.location,
    this.scale,
    this.operatingTime,
    this.congestion,
    this.priceRange,
    this.placeFeatures,
    this.hasSocket,
    required this.howManySocket,
    this.hasWifi,
    required this.howFastWifi,
    required this.otherFeatures,
  });
}
