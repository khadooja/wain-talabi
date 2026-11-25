import 'package:dio/dio.dart';
import '../models/order_model.dart';
import '../models/orders_codec.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/constants/app_constants.dart';


/// يجلب الطلبات من الشبكة، ويحوّل أي خطأ لـ AppException.
class OrdersRemoteDataSource {
  OrdersRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<OrderModel>> fetchOrders() async {
    try {
      // GitHub raw يرجّع الملف كنص عادي، فنقرأه plain ونفكّه بأنفسنا.
      final response = await _dio.get<String>(
        AppConstants.ordersUrl,
        options: Options(responseType: ResponseType.plain),
      );
      return OrdersCodec.fromBody(response.data ?? '');
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  AppException _mapError(DioException e) {
  debugPrint('...............................................................................................Dio error: ${e.type} ${e.response?.statusCode} ${e.message}');
  return switch (e.type) {
    DioExceptionType.badResponse => ServerException(e.response?.statusCode),
    _ => const NetworkException(),
  };
}
}
