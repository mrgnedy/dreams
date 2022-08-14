// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dreams/features/notfications/data/notification_data_model.dart';
import 'package:flutter/foundation.dart';

import 'package:dreams/utils/base_state.dart';

class NotificationModel {
  final String message;
  final int status_code;
  final List<NotificationData> data;
  final Result state;
  NotificationModel({
    this.message = '',
    this.status_code = 0,
    this.data = const [],
    this.state = const Result.init(),
  });

  NotificationModel copyWith({
    String? message,
    int? status_code,
    List<NotificationData>? data,
    Result? state,
  }) {
    return NotificationModel(
      message: message ?? this.message,
      status_code: status_code ?? this.status_code,
      data: data ?? this.data,
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

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      message: map['message'] as String,
      status_code: map['status_code'].toInt() as int,
      data: List<NotificationData>.from(
        (map['data'] as List).map<NotificationData>(
          (x) => NotificationData.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'NotificationModel(message: $message, status_code: $status_code, data: $data)';

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status_code == status_code &&
        listEquals(other.data, data) &&
        other.state == state;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        status_code.hashCode ^
        data.hashCode ^
        state.hashCode;
  }
}

class NotificationData {
  final int id;
  final String type;
  final String notifiable_type;
  final int notifiable_id;
  final NotificationDataModel? data;
  final String read_at;
  final String created_at;
  final String updated_at;
  NotificationData({
    required this.id,
    required this.type,
    required this.notifiable_type,
    required this.notifiable_id,
    required this.data,
    this.read_at = '',
    this.created_at = '',
    this.updated_at = '',
  });

  NotificationData copyWith({
    int? id,
    String? type,
    String? notifiable_type,
    int? notifiable_id,
    NotificationDataModel? data,
    String? read_at,
    String? created_at,
    String? updated_at,
  }) {
    return NotificationData(
      id: id ?? this.id,
      type: type ?? this.type,
      notifiable_type: notifiable_type ?? this.notifiable_type,
      notifiable_id: notifiable_id ?? this.notifiable_id,
      data: data ?? this.data,
      read_at: read_at ?? this.read_at,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'notifiable_type': notifiable_type,
      'notifiable_id': notifiable_id,
      'data': data,
      'read_at': read_at,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      id: map['id'].toInt() as int,
      type: map['type'] as String,
      notifiable_type: map['notifiable_type'] as String,
      notifiable_id: map['notifiable_id'].toInt() as int,
      data: map['data'] == null
          ? null
          : NotificationDataModel.fromMap(map['data']),
      read_at: map['read_at'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationData.fromJson(String source) =>
      NotificationData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationData(id: $id, type: $type, notifiable_type: $notifiable_type, notifiable_id: $notifiable_id, data: $data, read_at: $read_at, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant NotificationData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.notifiable_type == notifiable_type &&
        other.notifiable_id == notifiable_id &&
        other.data == data &&
        other.read_at == read_at &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        notifiable_type.hashCode ^
        notifiable_id.hashCode ^
        data.hashCode ^
        read_at.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}
