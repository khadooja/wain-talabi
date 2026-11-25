import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/order_item.dart';

/// أصناف الطلب مع إجمالي كل صنف والمجموع في الآخر.
class OrderItemsList extends StatelessWidget {
  const OrderItemsList({super.key, required this.items, required this.total});

  final List<OrderItem> items;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    '${Formatters.number(item.quantity)}×',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: theme.textTheme.bodyMedium),
                      if (item.quantity > 1)
                        Text(
                          '${Formatters.amount(item.unitPrice)} للواحد',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: muted),
                        ),
                    ],
                  ),
                ),
                Text(
                  Formatters.amount(item.lineTotal),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        const Divider(height: 24),
        Row(
          children: [
            Text(
              'الإجمالي',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              Formatters.amount(total),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
