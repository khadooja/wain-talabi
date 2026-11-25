/// أخطاء التطبيق. الطبقات العليا ما تتعامل مع DioException أبدًا، فقط مع هذي.
/// [message] رسالة جاهزة للعرض على الزبون.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;
}

/// ما فيه إنترنت، أو الشبكة ضعيفة وانتهت المهلة.
class NetworkException extends AppException {
  const NetworkException()
      : super('تعذّر الاتصال بالإنترنت. تأكد من الشبكة وحاول مرة ثانية.');
}

/// السيرفر ردّ بخطأ (404 أو 500 ...).
class ServerException extends AppException {
  const ServerException(this.statusCode)
      : super('صار خطأ من جهة الخادم. حاول بعد شوي.');

  final int? statusCode;
}

/// البيانات وصلت لكن شكلها غير صالح.
class DataFormatException extends AppException {
  const DataFormatException() : super('البيانات المستلمة غير صالحة.');
}
