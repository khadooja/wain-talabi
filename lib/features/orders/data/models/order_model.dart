import 'order_item_model.dart';
import 'order_status_mapper.dart';
import 'delivery_stage_model.dart';
import 'package:wain_talabi/features/orders/domain/entities/order.dart';



class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.createdAt,
    required super.total,
    required super.status,
    required super.address,
    required List<OrderItemModel> super.items,
    required List<DeliveryStageModel> super.stages,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        total: json['total'] as int,
        status: OrderStatusMapper.fromCode(json['status'] as String),
        address: json['address'] as String,
        items: (json['items'] as List<dynamic>)
            .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        stages: (json['stages'] as List<dynamic>)
            .map((e) => DeliveryStageModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'total': total,
        'status': OrderStatusMapper.toCode(status),
        'address': address,
        'items': items.cast<OrderItemModel>().map((e) => e.toJson()).toList(),
        'stages':
            stages.cast<DeliveryStageModel>().map((e) => e.toJson()).toList(),
      };
}
