import 'package:wain_talabi/features/orders/domain/entities/order_item.dart';



class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.name,
    required super.quantity,
    required super.unitPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        name: json['name'] as String,
        quantity: json['quantity'] as int,
        unitPrice: json['unitPrice'] as int,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };
}
