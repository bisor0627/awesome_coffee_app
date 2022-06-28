import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';

class AddresssModel {
  String? roadAddress;
  String? jibunAddress;
  String? englishAddress;
  LatLng? latLng;
  AddresssModel({
    this.roadAddress,
    this.jibunAddress,
    this.englishAddress,
    this.latLng,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roadAddress': roadAddress,
      'jibunAddress': jibunAddress,
      'englishAddress': englishAddress,
      'latLng': latLng,
    };
  }

  factory AddresssModel.fromMap(Map<String, dynamic> map) {
    return AddresssModel(
      roadAddress: map['roadAddress'] ?? null,
      jibunAddress: map['jibunAddress'] ?? null,
      englishAddress: map['englishAddress'] ?? null,
      latLng: LatLng(double.parse(map['y']), double.parse(map['x'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddresssModel.fromJson(String source) => AddresssModel.fromMap(json.decode(source));
}
