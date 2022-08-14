import 'dart:convert';

class NotificationDataModel {
  final String title;
  final String body;
  NotificationDataModel({
    required this.title,
    required this.body,
  });

  NotificationDataModel copyWith({
    String? title,
    String? body,
  }) {
    return NotificationDataModel(
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'body': body,
    };
  }

  factory NotificationDataModel.fromMap(Map<String, dynamic> map) {
    return NotificationDataModel(
      title: map['title'] as String,
      body: map['body'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationDataModel.fromJson(String source) => NotificationDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NotificationDataModel(title: $title, body: $body)';

  @override
  bool operator ==(covariant NotificationDataModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.body == body;
  }

  @override
  int get hashCode => title.hashCode ^ body.hashCode;
}