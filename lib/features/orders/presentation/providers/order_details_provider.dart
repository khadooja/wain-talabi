import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/order.dart';
import 'orders_provider.dart';

/// تفاصيل طلب واحد. ما نجلب من الشبكة مرة ثانية: ناخذه من قائمة الطلبات،
/// فيشتغل بدون نت ويتحدّث تلقائيًا لما القائمة تتحدّث.
final orderDetailsProvider = Provider.family<Order?, String>((ref, orderId) {
  final snapshot = ref.watch(ordersProvider).valueOrNull;
  return snapshot?.orders.where((o) => o.id == orderId).firstOrNull;
});
