import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/order_model.dart';
import '../models/orders_codec.dart';

/// آخر نسخة محفوظة مع وقت حفظها.
class CachedOrders {
  const CachedOrders({required this.orders, required this.savedAt});

  final List<OrderModel> orders;
  final DateTime savedAt;
}

/// الكاش المحلي. نحفظ كل شي في مفتاح واحد عشان القائمة ووقتها ما يختلفون.
class OrdersLocalDataSource {
  OrdersLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  Future<void> save(List<OrderModel> orders, DateTime savedAt) {
    final body = jsonEncode({
      'savedAt': savedAt.toIso8601String(),
      'orders': orders.map((o) => o.toJson()).toList(),
    });
    return _prefs.setString(AppConstants.ordersCacheKey, body);
  }

  /// ترجّع null لو ما فيه كاش، أو لو الكاش تالف (ونمسحه).
  Future<CachedOrders?> read() async {
    final raw = _prefs.getString(AppConstants.ordersCacheKey);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return CachedOrders(
        orders: OrdersCodec.fromList(map['orders'] as List<dynamic>),
        savedAt: DateTime.parse(map['savedAt'] as String),
      );
    } catch (_) {
      await _prefs.remove(AppConstants.ordersCacheKey);
      return null;
    }
  }
}
