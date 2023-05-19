import 'package:intl/intl.dart';

extension PlexDateUtils on DateTime {
  String getFormattedStringFromDate() {
    return DateFormat("dd MMM yyyy").format(this);
  }
}
