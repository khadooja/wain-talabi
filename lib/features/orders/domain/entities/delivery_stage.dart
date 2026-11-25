import 'order_status.dart';

/// مرحلة واحدة من مراحل التوصيل.
/// إذا [completedAt] فاضي معناها المرحلة ما وصلنا لها.
class DeliveryStage {
  const DeliveryStage({required this.status, this.completedAt});

  final OrderStatus status;
  final DateTime? completedAt;

  bool get isDone => completedAt != null;
}
