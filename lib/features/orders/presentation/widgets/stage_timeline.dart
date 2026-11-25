import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../utils/order_status_ui.dart';

enum _StepState { done, current, pending, cancelled }

class _Step {
  const _Step({
    required this.label,
    required this.icon,
    required this.color,
    required this.state,
    this.time,
  });

  final String label;
  final IconData icon;
  final Color color;
  final _StepState state;
  final DateTime? time;
}

/// خط زمني لمراحل التوصيل.
/// المرحلة اللي فيها وقت = وصلنا لها، واللي وقتها فاضي = لسه.
/// آخر مرحلة وصلنا لها تنعرض كـ "الحالية" إذا الطلب لسه شغال.
class StageTimeline extends StatelessWidget {
  const StageTimeline({super.key, required this.order});

  final Order order;

  List<_Step> _buildSteps() {
    final cancelled = order.status == OrderStatus.cancelled;

    // الطلب الملغي: نعرض بس المراحل اللي تمت، ثم خطوة الإلغاء.
    final stages =
        cancelled ? order.stages.where((s) => s.isDone).toList() : order.stages;
    final lastDone = stages.lastIndexWhere((s) => s.isDone);

    final steps = <_Step>[
      for (var i = 0; i < stages.length; i++)
        _Step(
          label: stages[i].status.label,
          icon: stages[i].status.icon,
          color: stages[i].status.color,
          time: stages[i].completedAt,
          state: !stages[i].isDone
              ? _StepState.pending
              : (order.isActive && i == lastDone)
                  ? _StepState.current
                  : _StepState.done,
        ),
    ];

    if (cancelled) {
      steps.add(
        _Step(
          label: 'تم إلغاء الطلب',
          icon: Icons.close,
          color: OrderStatus.cancelled.color,
          state: _StepState.cancelled,
        ),
      );
    }
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final steps = _buildSteps();

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          _StepRow(
            step: steps[i],
            isLast: i == steps.length - 1,
            lineColor: i == steps.length - 1
                ? Colors.transparent
                : switch (steps[i + 1].state) {
                    _StepState.pending => scheme.outlineVariant,
                    _StepState.cancelled => steps[i + 1].color,
                    _ => scheme.primary,
                  },
          ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.step,
    required this.isLast,
    required this.lineColor,
  });

  final _Step step;
  final bool isLast;
  final Color lineColor;

  static const _dotSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final isPending = step.state == _StepState.pending;
    final labelColor = switch (step.state) {
      _StepState.current || _StepState.cancelled => step.color,
      _StepState.pending => scheme.onSurfaceVariant,
      _StepState.done => scheme.onSurface,
    };
    final subtitle = step.time != null
        ? Formatters.dateTime(step.time!)
        : (isPending ? 'لم تبدأ بعد' : null);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: _dotSize,
            child: Column(
              children: [
                _Dot(step: step, size: _dotSize),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: lineColor),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    step.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: labelColor,
                      fontWeight: isPending ? FontWeight.w500 : FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.step, required this.size});

  final _Step step;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (Color background, Color iconColor, IconData icon, Color? border) =
        switch (step.state) {
      _StepState.done => (scheme.primary, Colors.white, Icons.check, null),
      _StepState.current => (step.color, Colors.white, step.icon, null),
      _StepState.cancelled => (step.color, Colors.white, step.icon, null),
      _StepState.pending => (
          Colors.transparent,
          scheme.outline,
          step.icon,
          scheme.outlineVariant,
        ),
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
        border: border == null ? null : Border.all(color: border, width: 2),
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}
