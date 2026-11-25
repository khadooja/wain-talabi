import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// تنسيق المبلغ والتاريخ بالعربي.
/// لازم نستدعي initializeDateFormatting('ar') في main قبل أول استخدام.
class Formatters {
  const Formatters._();

  static final _amount = NumberFormat.decimalPattern('ar');
  static final _date = DateFormat('d MMMM y', 'ar');
  static final _time = DateFormat('h:mm a', 'ar');

  static String number(int value) => _amount.format(value);

  static String amount(int value) =>
      '${number(value)} ${AppConstants.currencySymbol}';

  static String date(DateTime value) => _date.format(value.toLocal());

  static String time(DateTime value) => _time.format(value.toLocal());

  static String dateTime(DateTime value) => '${date(value)}، ${time(value)}';
}
