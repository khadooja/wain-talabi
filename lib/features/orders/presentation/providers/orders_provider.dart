import '../../domain/entities/orders_snapshot.dart';
import '../../data/datasources/orders_local_ds.dart';
import '../../data/datasources/orders_remote_ds.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../domain/repositories/orders_repository.dart';
import 'package:wain_talabi/features/orders/data/repositories/orders_repository_impl.dart';




/// ربط الـ Repository بمصادره. الشاشات ما تشوف هذا الكلام.
final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepositoryImpl(
    remote: OrdersRemoteDataSource(ref.watch(dioProvider)),
    local: OrdersLocalDataSource(ref.watch(sharedPreferencesProvider)),
  );
});

/// حالة قائمة الطلبات: تحميل / خطأ / بيانات (AsyncValue جاهز من Riverpod).
class OrdersNotifier extends AsyncNotifier<OrdersSnapshot> {
  OrdersRepository get _repository => ref.read(ordersRepositoryProvider);

  /// أول تحميل يصير تلقائيًا أول ما أحد يسمع للـ provider.
  @override
  Future<OrdersSnapshot> build() => _repository.getOrders();

  /// سحب للتحديث: نخلي القائمة الحالية ظاهرة بدون شاشة تحميل كاملة.
  Future<void> refresh() async {
    state = await AsyncValue.guard(_repository.getOrders);
  }

  /// زر إعادة المحاولة بعد خطأ: نرجع لحالة التحميل.
  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.getOrders);
  }
}

final ordersProvider =
    AsyncNotifierProvider<OrdersNotifier, OrdersSnapshot>(OrdersNotifier.new);
