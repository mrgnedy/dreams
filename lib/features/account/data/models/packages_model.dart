// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:dreams/features/account/data/models/subscription_model.dart';
import 'package:dreams/utils/base_state.dart';

class PackagesModel {
  final String message;
  final int status_code;
  final List<Package> data;
  final int? selectedPkgIndex;
  Package? get selectedPackage =>
      selectedPkgIndex == null ? null : data.elementAt(selectedPkgIndex!);
  final Result state;
  PackagesModel(
      {this.selectedPkgIndex,
      this.message = '',
      this.status_code = 1,
      this.data = const [],
      this.state = const Result.init()});

  PackagesModel copyWith({
    String? message,
    int? status_code,
    List<Package>? data,
    int? selectedPkgIndex,
    Result? state,
  }) {
    return PackagesModel(
      message: message ?? this.message,
      status_code: status_code ?? this.status_code,
      data: data ?? this.data,
      selectedPkgIndex: selectedPkgIndex ?? this.selectedPkgIndex,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status_code': status_code,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory PackagesModel.fromMap(Map<String, dynamic> map) {
    return PackagesModel(
      message: map['message'] as String,
      status_code: map['status_code'].toInt() as int,
      data: List<Package>.from(
        (map['data'] as List).map<Package>(
          (x) => Package.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PackagesModel.fromJson(String source) =>
      PackagesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PackagesModel(message: $message, status_code: $status_code, data: $data)';

  @override
  bool operator ==(covariant PackagesModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status_code == status_code &&
        listEquals(other.data, data) &&
        other.selectedPkgIndex == selectedPkgIndex &&
        other.state == state;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        status_code.hashCode ^
        data.hashCode ^
        selectedPkgIndex.hashCode ^
        state.hashCode;
  }
}
