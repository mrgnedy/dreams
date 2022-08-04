import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:dreams/utils/base_state.dart';

class MoaberenModel {
  final String message;
  final int status_code;
  final MoaberenData data;
  MoaberenModel({
    required this.message,
    required this.status_code,
    required this.data,
  });

  MoaberenModel copyWith({
    String? message,
    int? status_code,
    MoaberenData? data,
  }) {
    return MoaberenModel(
      message: message ?? this.message,
      status_code: status_code ?? this.status_code,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status_code': status_code,
      'data': data.toMap(),
    };
  }

  factory MoaberenModel.fromMap(Map<String, dynamic> map) {
    return MoaberenModel(
      message: map['message'] ?? '',
      status_code: map['status_code']?.toInt() ?? 0,
      data: MoaberenData.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MoaberenModel.fromJson(String source) =>
      MoaberenModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'MoaberenModel(message: $message, status_code: $status_code, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoaberenModel &&
        other.message == message &&
        other.status_code == status_code &&
        other.data == data;
  }

  @override
  int get hashCode => message.hashCode ^ status_code.hashCode ^ data.hashCode;
}

class MoaberenData {
  final List<MoaberData> data;
  final Result state;
  final Links? links;
  final Meta? meta;
  MoaberenData({
    this.data = const [],
    this.state = const Result.init(),
    this.links,
    this.meta,
  });

  MoaberenData copyWith({
    List<MoaberData>? data,
    Result? state,
    Links? links,
    Meta? meta,
  }) {
    return MoaberenData(
      data: data ?? this.data,
      state: state ?? this.state,
      links: links ?? this.links,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
      'links': links?.toMap(),
      'meta': meta?.toMap(),
    };
  }

  factory MoaberenData.fromMap(Map<String, dynamic> map) {
    log("ss${map['data']?.map((x) => MoaberData.fromMap(x))?.length}");
    return MoaberenData(
      data: List<MoaberData>.from(map['data']?.map((x) => MoaberData.fromMap(x))),
      links: Links.fromMap(map['links']),
      // meta: Meta.fromMap(map['meta']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MoaberenData.fromJson(String source) =>
      MoaberenData.fromMap(json.decode(source));

  @override
  String toString() => 'MoaberData(data: $data, links: $links, meta: $meta)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoaberenData &&
        listEquals(other.data, data) &&
        other.state == state &&
        other.links == links &&
        other.meta == meta;
  }

  @override
  int get hashCode {
    return data.hashCode ^ state.hashCode ^ links.hashCode ^ meta.hashCode;
  }
}

class MoaberData {
  final int id;
  final String name;
  final String image;
  final String note;
  final int experience_years;
  MoaberData({
    required this.id,
    required this.name,
    required this.image,
    required this.note,
    required this.experience_years,
  });

  MoaberData copyWith({
    int? id,
    String? name,
    String? image,
    String? note,
    int? experience_years,
  }) {
    return MoaberData(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      note: note ?? this.note,
      experience_years: experience_years ?? this.experience_years,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'note': note,
      'experience_years': experience_years,
    };
  }

  factory MoaberData.fromMap(Map<String, dynamic> map) {
    return MoaberData(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      note: map['note'] ?? '',
      experience_years: map['experience_years']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MoaberData.fromJson(String source) => MoaberData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MoaberData(id: $id, name: $name, image: $image, note: $note, experience_years: $experience_years)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoaberData &&
        other.id == id &&
        other.name == name &&
        other.image == image &&
        other.note == note &&
        other.experience_years == experience_years;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        note.hashCode ^
        experience_years.hashCode;
  }
}

class Links {
  final String first;
  final String last;
  final String? prev;
  final String? next;
  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  Links copyWith({
    String? first,
    String? last,
    String? prev,
    String? next,
  }) {
    return Links(
      first: first ?? this.first,
      last: last ?? this.last,
      prev: prev ?? this.prev,
      next: next ?? this.next,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }

  factory Links.fromMap(Map<String, dynamic> map) {
    return Links(
      first: map['first'] ?? '',
      last: map['last'] ?? '',
      prev: (map['prev']),
      next: (map['next']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Links.fromJson(String source) => Links.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Links(first: $first, last: $last, prev: $prev, next: $next)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Links &&
        other.first == first &&
        other.last == last &&
        other.prev == prev &&
        other.next == next;
  }

  @override
  int get hashCode {
    return first.hashCode ^ last.hashCode ^ prev.hashCode ^ next.hashCode;
  }
}

class Meta {
  final int current_page;
  final int from;
  final int last_page;
  final List<Link> links;
  final String path;
  final int per_page;
  final int to;
  final int total;
  Meta({
    required this.current_page,
    required this.from,
    required this.last_page,
    required this.links,
    required this.path,
    required this.per_page,
    required this.to,
    required this.total,
  });

  Meta copyWith({
    int? current_page,
    int? from,
    int? last_page,
    List<Link>? links,
    String? path,
    int? per_page,
    int? to,
    int? total,
  }) {
    return Meta(
      current_page: current_page ?? this.current_page,
      from: from ?? this.from,
      last_page: last_page ?? this.last_page,
      links: links ?? this.links,
      path: path ?? this.path,
      per_page: per_page ?? this.per_page,
      to: to ?? this.to,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'current_page': current_page,
      'from': from,
      'last_page': last_page,
      'links': links.map((x) => x.toMap()).toList(),
      'path': path,
      'per_page': per_page,
      'to': to,
      'total': total,
    };
  }

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      current_page: map['current_page']?.toInt() ?? 0,
      from: map['from']?.toInt() ?? 0,
      last_page: map['last_page']?.toInt() ?? 0,
      links: List<Link>.from(map['links']?.map((x) => Link.fromMap(x))),
      path: map['path'] ?? '',
      per_page: map['per_page']?.toInt() ?? 0,
      to: map['to']?.toInt() ?? 0,
      total: map['total']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Meta.fromJson(String source) => Meta.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Meta(current_page: $current_page, from: $from, last_page: $last_page, links: $links, path: $path, per_page: $per_page, to: $to, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Meta &&
        other.current_page == current_page &&
        other.from == from &&
        other.last_page == last_page &&
        listEquals(other.links, links) &&
        other.path == path &&
        other.per_page == per_page &&
        other.to == to &&
        other.total == total;
  }

  @override
  int get hashCode {
    return current_page.hashCode ^
        from.hashCode ^
        last_page.hashCode ^
        links.hashCode ^
        path.hashCode ^
        per_page.hashCode ^
        to.hashCode ^
        total.hashCode;
  }
}

class Link {
  final String url;
  final String label;
  final bool active;
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  Link copyWith({
    String? url,
    String? label,
    bool? active,
  }) {
    return Link(
      url: url ?? this.url,
      label: label ?? this.label,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }

  factory Link.fromMap(Map<String, dynamic> map) {
    return Link(
      url: map['url'],
      label: map['label'] ?? '',
      active: map['active'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Link.fromJson(String source) => Link.fromMap(json.decode(source));

  @override
  String toString() => 'Link(url: $url, label: $label, active: $active)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Link &&
        other.url == url &&
        other.label == label &&
        other.active == active;
  }

  @override
  int get hashCode => url.hashCode ^ label.hashCode ^ active.hashCode;
}
