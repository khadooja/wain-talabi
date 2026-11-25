import 'package:flutter_test/flutter_test.dart';
import 'package:wain_talabi/core/errors/app_exception.dart';
import 'package:wain_talabi/features/orders/data/models/order_model.dart';
import 'package:wain_talabi/features/orders/domain/entities/order_status.dart';
import 'package:wain_talabi/features/orders/data/datasources/orders_local_ds.dart';
import 'package:wain_talabi/features/orders/data/datasources/orders_remote_ds.dart';
import 'package:wain_talabi/features/orders/data/repositories/orders_repository_impl.dart' show OrdersRepositoryImpl;


/// مصدر شبكة مزيّف: يرجّع قائمة، أو يرمي الخطأ المحدد.
class FakeRemote implements OrdersRemoteDataSource {
  FakeRemote({this.orders = const [], this.error});

  final List<OrderModel> orders;
  final AppException? error;

  @override
  Future<List<OrderModel>> fetchOrders() async {
    final failure = error;
    if (failure != null) throw failure;
    return orders;
  }
}

/// كاش مزيّف في الذاكرة.
class FakeLocal implements OrdersLocalDataSource {
  FakeLocal({this.stored, this.failOnSave = false});

  CachedOrders? stored;
  final bool failOnSave;

  @override
  Future<void> save(List<OrderModel> orders, DateTime savedAt) async {
    if (failOnSave) throw Exception('disk full');
    stored = CachedOrders(orders: orders, savedAt: savedAt);
  }

  @override
  Future<CachedOrders?> read() async => stored;
}

OrderModel order(String id, DateTime createdAt) => OrderModel(
      id: id,
      createdAt: createdAt,
      total: 1000,
      status: OrderStatus.received,
      address: 'صنعاء',
      items: const [],
      stages: const [],
    );

void main() {
  final cachedAt = DateTime(2026, 11, 24, 10);

  CachedOrders cachedOrders() => CachedOrders(
        orders: [order('X', DateTime(2026, 11, 24))],
        savedAt: cachedAt,
      );

  group('OrdersRepositoryImpl', () {
    test('الشبكة تنجح: يرجّع بيانات محدّثة، مرتبة الأحدث أولًا، ويحفظها', () async {
      final local = FakeLocal();
      final repository = OrdersRepositoryImpl(
        remote: FakeRemote(
          orders: [
            order('A', DateTime(2026, 11, 20)),
            order('B', DateTime(2026, 11, 25)),
          ],
        ),
        local: local,
      );

      final snapshot = await repository.getOrders();

      expect(snapshot.isStale, isFalse);
      expect(snapshot.orders.map((o) => o.id), ['B', 'A']);
      expect(local.stored, isNotNull);
      expect(local.stored!.savedAt, snapshot.lastUpdated);
      expect(local.stored!.orders.map((o) => o.id), ['B', 'A']);
    });

    test('الشبكة تفشل وفيه كاش: يرجّع الكاش كبيانات غير محدّثة', () async {
      final cached = cachedOrders();
      final local = FakeLocal(stored: cached);
      final repository = OrdersRepositoryImpl(
        remote: FakeRemote(error: const NetworkException()),
        local: local,
      );

      final snapshot = await repository.getOrders();

      expect(snapshot.isStale, isTrue);
      expect(snapshot.orders.map((o) => o.id), ['X']);
      expect(snapshot.lastUpdated, cachedAt);
      // الكاش ما انلمس.
      expect(local.stored, same(cached));
    });

    test('خطأ من السيرفر وفيه كاش: برضو يرجّع الكاش', () async {
      final repository = OrdersRepositoryImpl(
        remote: FakeRemote(error: const ServerException(500)),
        local: FakeLocal(stored: cachedOrders()),
      );

      final snapshot = await repository.getOrders();

      expect(snapshot.isStale, isTrue);
      expect(snapshot.orders.map((o) => o.id), ['X']);
    });

    test('الشبكة تفشل وما فيه كاش: يرمي الخطأ الأصلي', () async {
      final repository = OrdersRepositoryImpl(
        remote: FakeRemote(error: const NetworkException()),
        local: FakeLocal(),
      );

      await expectLater(
        repository.getOrders(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('فشل حفظ الكاش ما يخرّب عرض البيانات الجديدة', () async {
      final repository = OrdersRepositoryImpl(
        remote: FakeRemote(orders: [order('A', DateTime(2026, 11, 25))]),
        local: FakeLocal(failOnSave: true),
      );

      final snapshot = await repository.getOrders();

      expect(snapshot.isStale, isFalse);
      expect(snapshot.orders.map((o) => o.id), ['A']);
    });
  });
}
