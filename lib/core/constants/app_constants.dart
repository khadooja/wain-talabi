/// ثوابت التطبيق: الروابط، مفاتيح الكاش، المهلات.
class AppConstants {
  const AppConstants._();

  // TODO: غيّري USERNAME و REPO لحسابك على GitHub (الريبو لازم يكون Public).
  static const ordersUrl =
       'https://raw.githubusercontent.com/khadooja/wain-talabi/main/data/orders.json';

  /// مفتاح الكاش. الرقم v1 عشان لو غيّرنا شكل البيانات نرفعه ونتجاهل الكاش القديم.
  static const ordersCacheKey = 'orders_cache_v1';

  static const requestTimeout = Duration(seconds: 8);

  static const currencySymbol = 'ر.ي';
}
