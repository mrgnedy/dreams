import 'dart:convert';

class SubscriptionData {
  final int id;
  final String name;
  final String description;
  final String? image;
  final String price;
  final String months;
  final String start_date;
  final String end_date;
  final Package package;
  SubscriptionData({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.price,
    required this.months,
    required this.start_date,
    required this.end_date,
    required this.package,
  });

  SubscriptionData copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    String? price,
    String? months,
    String? start_date,
    String? end_date,
    Package? package,
  }) {
    return SubscriptionData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      months: months ?? this.months,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      package: package ?? this.package,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'months': months,
      'start_date': start_date,
      'end_date': end_date,
      'package': package.toMap(),
    };
  }

  factory SubscriptionData.fromMap(Map<String, dynamic> map) {
    return SubscriptionData(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
      description: map['description'] as String,
      // image: map['image'],
      price: map['price'] as String,
      months: map['months'] as String,
      start_date: map['start_date'] as String,
      end_date: map['end_date'] as String,
      package: Package.fromMap(map['package'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionData.fromJson(String source) =>
      SubscriptionData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubscriptionData(id: $id, name: $name, description: $description, image: $image, price: $price, months: $months, start_date: $start_date, end_date: $end_date, package: $package)';
  }

  @override
  bool operator ==(covariant SubscriptionData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.image == image &&
        other.price == price &&
        other.months == months &&
        other.start_date == start_date &&
        other.end_date == end_date &&
        other.package == package;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        image.hashCode ^
        price.hashCode ^
        months.hashCode ^
        start_date.hashCode ^
        end_date.hashCode ^
        package.hashCode;
  }
}

class Package {
  final int id;
  final String image;
  final String name;
  final String description;
  final String price;
  final int months;
  final int dreams_count;
  Package({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.months,
    required this.dreams_count,
  });

  Package copyWith({
    int? id,
    String? image,
    String? name,
    String? description,
    String? price,
    int? months,
    int? dreams_count,
  }) {
    return Package(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      months: months ?? this.months,
      dreams_count: dreams_count ?? this.dreams_count,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'name': name,
      'description': description,
      'price': price,
      'months': months,
      'dreams_count': dreams_count,
    };
  }

  factory Package.fromMap(Map<String, dynamic> map) {
    return Package(
      id: map['id'].toInt() as int,
      image: map['image'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as String,
      months: map['months'].toInt() as int,
      dreams_count: map['dreams_count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Package.fromJson(String source) =>
      Package.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Package(id: $id, image: $image, name: $name, description: $description, price: $price, months: $months)';
  }

  @override
  bool operator ==(covariant Package other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.image == image &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.dreams_count == dreams_count &&
        other.months == months;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        dreams_count.hashCode ^
        months.hashCode;
  }
}
