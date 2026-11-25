import 'order_item.dart';
import 'order_status.dart';
import 'delivery_stage.dart';

/// الطلب. كلاس نقي: ما يعرف شي عن JSON ولا عن Flutter.
class Order {
  const Order({
    required this.id,
    required this.createdAt,
    required this.total,
    required this.status,
    required this.address,
    required this.items,
    required this.stages,
  });

  final String id;
  final DateTime createdAt;
  final int total;
  final OrderStatus status;
  final String address;
  final List<OrderItem> items;
  final List<DeliveryStage> stages;

  /// الطلب لسه شغال (ما انتهى ولا انلغى).
  bool get isActive =>
      status != OrderStatus.delivered && status != OrderStatus.cancelled;
}
