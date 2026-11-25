import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/orders_snapshot.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_local_ds.dart';
import '../datasources/orders_remote_ds.dart';
import '../models/order_model.dart';

/// قلب الـ offline: الشبكة أولًا، وإذا فشلت نرجع للكاش.
class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl({
    required OrdersRemoteDataSource remote,
    required OrdersLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final OrdersRemoteDataSource _remote;
  final OrdersLocalDataSource _local;

  @override
  Future<OrdersSnapshot> getOrders() async {
    try {
      final orders = _newestFirst(await _remote.fetchOrders());
      final now = DateTime.now();
      await _saveQuietly(orders, now);
      return OrdersSnapshot(orders: orders, isStale: false, lastUpdated: now);
    } on AppException {
      final cached = await _local.read();
      if (cached != null) {
        return OrdersSnapshot(
          orders: _newestFirst(cached.orders),
          isStale: true,
          lastUpdated: cached.savedAt,
        );
      }
      // ما فيه نت ولا كاش: نترك الخطأ يوصل للشاشة.
      rethrow;
    }
  }

  /// الأحدث أولًا: قاعدة عرض للزبون، وتنطبق على الشبكة والكاش.
  List<OrderModel> _newestFirst(List<OrderModel> orders) =>
      [...orders]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  /// فشل الحفظ ما لازم يخرّب عرض بيانات جات سليمة.
  Future<void> _saveQuietly(List<OrderModel> orders, DateTime at) async {
    try {
      await _local.save(orders, at);
    } catch (_) {}
  }
}
