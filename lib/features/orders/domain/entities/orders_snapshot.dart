import 'order.dart';

/// نتيجة جلب الطلبات: القائمة + هل هي قديمة (من الكاش) + وقت آخر تحديث.
class OrdersSnapshot {
  const OrdersSnapshot({
    required this.orders,
    required this.isStale,
    required this.lastUpdated,
  });

  final List<Order> orders;

  /// true معناها: النت فشل وهذي آخر نسخة محفوظة.
  final bool isStale;

  final DateTime lastUpdated;
}
