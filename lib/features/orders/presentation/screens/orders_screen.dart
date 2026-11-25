import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../providers/orders_provider.dart';

/// شاشة مؤقتة لاختبار طبقة البيانات. بنستبدلها بالشاشة الحقيقية في الخطوة 4.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: Center(
        child: state.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text(e is AppException ? e.message : '$e'),
          data: (s) => Text(
            'عدد الطلبات: ${s.orders.length}\n'
            '${s.isStale ? 'غير محدّثة (من الكاش)' : 'محدّثة (من الشبكة)'}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
