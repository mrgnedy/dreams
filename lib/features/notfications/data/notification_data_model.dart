import 'dart:convert';

import 'dart:developer';

class NotificationDataModel {
  final String title;
  final String body;
  final int dream_id;
  NotificationDataModel({
    required this.title,
    required this.body,
    this.dream_id = 0,
  });

  NotificationDataModel copyWith({
    String? title,
    String? body,
    int? dream_id,
  }) {
    return NotificationDataModel(
      title: title ?? this.title,
      body: body ?? this.body,
      dream_id: dream_id ?? this.dream_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'body': body,
      'dream_id': dream_id,
    };
  }

  factory NotificationDataModel.fromMap(Map<String, dynamic> map) {

    return NotificationDataModel(
      title: map['title'] as String,
      body: map['body'] as String,
      dream_id: map['dream_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationDataModel.fromJson(String source) =>
      NotificationDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NotificationDataModel(title: $title, body: $body)';

  @override
  bool operator ==(covariant NotificationDataModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.body == body &&
        other.dream_id == dream_id;
  }

  @override
  int get hashCode => title.hashCode ^ body.hashCode ^ dream_id.hashCode;
}
