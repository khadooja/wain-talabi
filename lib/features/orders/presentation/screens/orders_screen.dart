import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/orders_snapshot.dart';
import '../providers/orders_provider.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/order_card.dart';
import '../widgets/pull_to_refresh_center.dart';
import '../widgets/stale_banner.dart';
import 'order_details_screen.dart';

/// الشاشة الأولى. ما فيها منطق: تراقب الحالة وترسم.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ordersProvider);
    final notifier = ref.read(ordersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => PullToRefreshCenter(
          onRefresh: notifier.refresh,
          child: ErrorView(
            message: error is AppException
                ? error.message
                : 'صار خطأ غير متوقع. حاول مرة ثانية.',
            onRetry: notifier.retry,
          ),
        ),
        data: (snapshot) => _OrdersContent(
          snapshot: snapshot,
          onRefresh: notifier.refresh,
          onOpenOrder: (id) => _openOrder(context, id),
        ),
      ),
    );
  }

  void _openOrder(BuildContext context, String orderId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OrderDetailsScreen(orderId: orderId),
      ),
    );
  }
}

class _OrdersContent extends StatelessWidget {
  const _OrdersContent({
    required this.snapshot,
    required this.onRefresh,
    required this.onOpenOrder,
  });

  final OrdersSnapshot snapshot;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onOpenOrder;

  @override
  Widget build(BuildContext context) {
    final orders = snapshot.orders;

    return Column(
      children: [
        if (snapshot.isStale) StaleBanner(lastUpdated: snapshot.lastUpdated),
        Expanded(
          child: orders.isEmpty
              ? PullToRefreshCenter(
                  onRefresh: onRefresh,
                  child: const EmptyView(),
                )
              : RefreshIndicator(
                  onRefresh: onRefresh,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final order = orders[index];
                      return OrderCard(
                        order: order,
                        onTap: () => onOpenOrder(order.id),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
