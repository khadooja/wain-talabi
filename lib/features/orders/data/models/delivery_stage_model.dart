import 'order_status_mapper.dart';
import 'package:wain_talabi/features/orders/domain/entities/delivery_stage.dart';



class DeliveryStageModel extends DeliveryStage {
  const DeliveryStageModel({required super.status, super.completedAt});

  factory DeliveryStageModel.fromJson(Map<String, dynamic> json) {
    final completedAt = json['completedAt'] as String?;
    return DeliveryStageModel(
      status: OrderStatusMapper.fromCode(json['status'] as String),
      completedAt: completedAt == null ? null : DateTime.parse(completedAt),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': OrderStatusMapper.toCode(status),
        'completedAt': completedAt?.toIso8601String(),
      };
}
