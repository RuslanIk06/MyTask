import 'package:intl/intl.dart';

// ignore: non_constant_identifier_names
String FormatDateTime(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }

  var format = DateFormat('EEE, dd-MM-yyyy');

  return format.format(dateTime);
}
