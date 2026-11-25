import 'package:flutter/material.dart';

import '../../domain/entities/order_status.dart';

/// كل شي يخص شكل الحالة (نص، لون، أيقونة) في مكان واحد.
/// الـ domain ما يعرف شي عن الألوان، فحطيناها هنا كـ extension.
extension OrderStatusUi on OrderStatus {
  String get label => switch (this) {
        OrderStatus.received => 'تم الاستلام',
        OrderStatus.preparing => 'قيد التحضير',
        OrderStatus.onTheWay => 'في الطريق',
        OrderStatus.delivered => 'تم التوصيل',
        OrderStatus.cancelled => 'ملغي',
      };

  Color get color => switch (this) {
        OrderStatus.received => const Color(0xFF64748B),
        OrderStatus.preparing => const Color(0xFFD97706),
        OrderStatus.onTheWay => const Color(0xFF2563EB),
        OrderStatus.delivered => const Color(0xFF15803D),
        OrderStatus.cancelled => const Color(0xFFDC2626),
      };

  IconData get icon => switch (this) {
        OrderStatus.received => Icons.receipt_long_outlined,
        OrderStatus.preparing => Icons.soup_kitchen_outlined,
        OrderStatus.onTheWay => Icons.local_shipping_outlined,
        OrderStatus.delivered => Icons.check_circle_outline,
        OrderStatus.cancelled => Icons.cancel_outlined,
      };
}
