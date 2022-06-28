import 'dart:convert';

class AddresssModel {
  String? roadAddress;
  String? jibunAddress;
  String? englishAddress;
  String? x;
  String? y;
  AddresssModel({
    this.roadAddress,
    this.jibunAddress,
    this.englishAddress,
    this.x,
    this.y,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roadAddress': roadAddress,
      'jibunAddress': jibunAddress,
      'englishAddress': englishAddress,
      'x': x,
      'y': y,
    };
  }

  factory AddresssModel.fromMap(Map<String, dynamic> map) {
    return AddresssModel(
      roadAddress: map['roadAddress'] ?? null,
      jibunAddress: map['jibunAddress'] ?? null,
      englishAddress: map['englishAddress'] ?? null,
      x: map['x'] ?? null,
      y: map['y'] ?? null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddresssModel.fromJson(String source) => AddresssModel.fromMap(json.decode(source));
}
