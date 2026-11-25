import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

/// شريط يظهر لما نعرض بيانات من الكاش لأن النت فشل.
class StaleBanner extends StatelessWidget {
  const StaleBanner({super.key, required this.lastUpdated});

  final DateTime lastUpdated;

  static const _background = Color(0xFFFFF4E5);
  static const _foreground = Color(0xFF8A4B00);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      color: _background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_outlined, color: _foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بيانات غير محدّثة',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: _foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'تعذّر الاتصال، وهذي آخر قائمة محفوظة.\n'
                  'آخر تحديث: ${Formatters.dateTime(lastUpdated)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _foreground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
