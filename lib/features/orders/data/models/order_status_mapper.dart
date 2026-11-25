import 'package:wain_talabi/features/orders/domain/entities/order_status.dart';



/// تحويل الحالة بين نص الـ API والـ enum.
/// مكانه طبقة data لأن أسماء الـ API تفصيلة تخص مصدر البيانات فقط.
class OrderStatusMapper {
  const OrderStatusMapper._();

  static OrderStatus fromCode(String code) => switch (code) {
        'received' => OrderStatus.received,
        'preparing' => OrderStatus.preparing,
        'onTheWay' => OrderStatus.onTheWay,
        'delivered' => OrderStatus.delivered,
        'cancelled' => OrderStatus.cancelled,
        // حالة جديدة من السيرفر ما نعرفها: ما نكسر التطبيق.
        _ => OrderStatus.received,
      };

  static String toCode(OrderStatus status) => status.name;
}
