import '../entities/orders_snapshot.dart';

/// العقد اللي تعتمد عليه الـ providers. ما تعرف إذا البيانات من شبكة أو كاش.
abstract class OrdersRepository {
  /// ترجّع آخر بيانات متاحة، أو ترمي AppException لو ما فيه شي.
  Future<OrdersSnapshot> getOrders();
}
