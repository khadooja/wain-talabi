import 'dart:convert';
import '../../../../core/errors/app_exception.dart';
import 'package:wain_talabi/features/orders/data/models/order_model.dart';



/// تحويل JSON الخام لقائمة طلبات. نفس الصيغة للشبكة وللكاش.
class OrdersCodec {
  const OrdersCodec._();

  /// جسم الرد: { "orders": [ ... ] }
  static List<OrderModel> fromBody(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return fromList(json['orders'] as List<dynamic>);
    } on FormatException {
      throw const DataFormatException();
    } on TypeError {
      throw const DataFormatException();
    }
  }

  static List<OrderModel> fromList(List<dynamic> list) => list
      .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
      .toList();
}
