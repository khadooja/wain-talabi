import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/order_details_provider.dart';

/// شاشة مؤقتة: نستبدلها بالشاشة الحقيقية في الخطوة 5.
class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderDetailsProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Center(
        child: Text(order?.address ?? 'الطلب غير موجود'),
      ),
    );
  }
}
