import 'package:intl/intl.dart';

extension PlexDateUtils on DateTime {
  String toDateString() {
    return DateFormat("dd MMM yyyy").format(this);
  }

  String toDateTimeString() {
    return DateFormat("dd MMM yyyy, HH:mm").format(this);
  }

  String toTimeString() {
    return DateFormat("HH:mm").format(this);
  }
}
