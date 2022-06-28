import 'package:awesome_cafe/global/model/address_model.dart';

class CafeModel {
  String name;
  String link;
  String location;
  AddresssModel? address;
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
    this.address,
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
