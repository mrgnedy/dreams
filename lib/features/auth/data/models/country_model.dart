import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

class CountryModel {
  final String message;
  final int statusCode;
  final List<CountryData> data;
  CountryModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  CountryModel copyWith({
    String? message,
    int? status_code,
    List<CountryData>? data,
  }) {
    return CountryModel(
      message: message ?? this.message,
      statusCode: status_code ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status_code': statusCode,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      message: map['message'] ?? '',
      statusCode: map['status_code']?.toInt() ?? 0,
      data: List<CountryData>.from(
          map['data']?.map((x) => CountryData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryModel.fromJson(String source) =>
      CountryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CountryModel(message: $message, status_code: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CountryModel &&
        other.message == message &&
        other.statusCode == statusCode &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class CountryData {
  final int id;
  final String name;
  final List<CountryData>? cities;
  CountryData({
    required this.id,
    required this.name,
    this.cities,
  });

  CountryData copyWith({
    int? id,
    String? name,
    List<CountryData>? cities,
  }) {
    return CountryData(
      id: id ?? this.id,
      name: name ?? this.name,
      cities: cities ?? this.cities,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cities': cities?.map((x) => x.toMap()).toList(),
    };
  }

  factory CountryData.fromMap(Map<String, dynamic> map) {
    return CountryData(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      cities: List<CountryData>.from(
        map['cities']?.map(
              (x) => CountryData.fromMap(x),
            ) ??
            {},
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryData.fromJson(String source) =>
      CountryData.fromMap(json.decode(source));

  @override
  String toString() => 'CountryData(id: $id, name: $name, cities: $cities)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CountryData &&
        other.id == id &&
        // other.name == name &&
        listEquals(other.cities, cities);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ cities.hashCode;
}

// class CountryData {
//   final int id;
//   final String name;
//   CountryData({
//     required this.id,
//     required this.name,
//   });

//   CountryData copyWith({
//     int? id,
//     String? name,
//   }) {
//     return CountryData(
//       id: id ?? this.id,
//       name: name ?? this.name,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }

//   factory CountryData.fromMap(Map<String, dynamic> map) {
//     return CountryData(
//       id: map['id']?.toInt() ?? 0,
//       name: map['name'] ?? '',
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory CountryData.fromJson(String source) => CountryData.fromMap(json.decode(source));

//   @override
//   String toString() => 'CountryData(id: $id, name: $name)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is CountryData && other.id == id && other.name == name;
//   }

//   @override
//   int get hashCode => id.hashCode ^ name.hashCode;
// }
