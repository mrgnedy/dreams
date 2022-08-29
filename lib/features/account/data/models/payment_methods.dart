import 'dart:convert';

class PaymentMethodsModel {
  final String message;
  final int status_code;
  final PaymentMethods data;
  PaymentMethodsModel({
    required this.message,
    required this.status_code,
    required this.data,
  });

  PaymentMethodsModel copyWith({
    String? message,
    int? status_code,
    PaymentMethods? data,
  }) {
    return PaymentMethodsModel(
      message: message ?? this.message,
      status_code: status_code ?? this.status_code,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status_code': status_code,
      'data': data.toMap(),
    };
  }

  factory PaymentMethodsModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodsModel(
      message: map['message'] as String,
      status_code: map['status_code'].toInt() as int,
      data: PaymentMethods.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethodsModel.fromJson(String source) =>
      PaymentMethodsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PaymentMethodsModel(message: $message, status_code: $status_code, data: $data)';

  @override
  bool operator ==(covariant PaymentMethodsModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status_code == status_code &&
        other.data == data;
  }

  @override
  int get hashCode => message.hashCode ^ status_code.hashCode ^ data.hashCode;
}

class PaymentMethods {
  final String cash;
  final String paypal;
  const PaymentMethods({
    required this.cash,
    required this.paypal,
  });

  PaymentMethods copyWith({
    String? cash,
    String? paypal,
  }) {
    return PaymentMethods(
      cash: cash ?? this.cash,
      paypal: paypal ?? this.paypal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cash': cash,
      'paypal': paypal,
    };
  }

  factory PaymentMethods.fromMap(Map<String, dynamic> map) {
    return PaymentMethods(
      cash: map['cash'] as String,
      paypal: map['paypal'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethods.fromJson(String source) =>
      PaymentMethods.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PaymentMethods(cash: $cash, paypal: $paypal)';

  @override
  bool operator ==(covariant PaymentMethods other) {
    if (identical(this, other)) return true;

    return other.cash == cash && other.paypal == paypal;
  }

  @override
  int get hashCode => cash.hashCode ^ paypal.hashCode;
}
