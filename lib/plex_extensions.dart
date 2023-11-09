import 'package:intl/intl.dart';

extension ListExtensions<T> on List<T> {
  List<T> sortAndReturn([int Function(T a, T b)? compare]) {
    sort(compare);
    return this;
  }

  Map<S, List<T>> groupBy<S>(S Function(T) key) {
    var map = <S, List<T>>{};
    for (var element in this) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}

extension DateUtils on DateTime {
  String toFormattedString({String? format}) {
    if (format == null) return toString();
    return DateFormat(format).format(this);
  }

  String toDDMMMHHmmss() {
    return DateFormat("dd MMM HH:mm:ss").format(this);
  }

  String toMMMDDYYYY() {
    return DateFormat("MMM dd, yyyy").format(this);
  }

  String getDifferenceString() {
    var diff = DateTime.now().difference(this);
    if (diff.inHours <= 0) {
      if (diff.inMinutes <= 0) {
        return "${diff.inSeconds} seconds";
      }
      return "${diff.inMinutes} minutes";
    }
    return "${diff.inHours} hours";
  }
}

extension StringUtils on String {
  DateTime? toDate() {
    if (isEmpty) return null;
    try {
      return DateTime.parse(this);
    } catch (_) {
      return null;
    }
  }
}
