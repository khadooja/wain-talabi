import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/order.dart';
import '../providers/order_details_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_items_list.dart';
import '../widgets/section_card.dart';
import '../widgets/stage_timeline.dart';
import '../widgets/stale_banner.dart';
import '../widgets/status_chip.dart';

/// الشاشة الثانية: تفاصيل طلب (مراحل التوصيل، العنوان، الأصناف).
class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderDetailsProvider(orderId));
    final snapshot = ref.watch(ordersProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: order == null
          ? const _NotFound()
          : Column(
              children: [
                if (snapshot != null && snapshot.isStale)
                  StaleBanner(lastUpdated: snapshot.lastUpdated),
                Expanded(child: _Details(order: order)),
              ],
            ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _OrderHeader(order: order),
        const SizedBox(height: 12),
        SectionCard(
          title: 'مراحل التوصيل',
          icon: Icons.local_shipping_outlined,
          child: StageTimeline(order: order),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'عنوان التوصيل',
          icon: Icons.location_on_outlined,
          child: Text(
            order.address,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'الأصناف',
          icon: Icons.shopping_bag_outlined,
          child: OrderItemsList(items: order.items, total: order.total),
        ),
      ],
    );
  }
}

class _OrderHeader extends StatelessWidget {
  const _OrderHeader({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  // رقم الطلب لاتيني: نثبّت اتجاهه عشان ما ينعكس.
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      order.id,
                      textDirection: TextDirection.ltr,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              Formatters.dateTime(order.createdAt),
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text('هذا الطلب غير موجود', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
