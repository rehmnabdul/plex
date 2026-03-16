import 'package:flutter/foundation.dart';

/// Log levels for [PlexLogger].
enum PlexLogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
}

/// Sink for forwarding log output (e.g. to Sentry, Crashlytics).
abstract class PlexLogSink {
  void write(
    PlexLogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stack,
  });
}

/// Structured logger for the plex library.
///
/// In release builds, [verbose] and [debug] are suppressed by default.
/// Use [setLevel] to control the minimum level.
class PlexLogger {
  PlexLogger._();

  static PlexLogLevel _minLevel = PlexLogLevel.debug;
  static final List<PlexLogSink> _sinks = [];

  /// Set the minimum log level. Messages below this level are not output.
  static void setLevel(PlexLogLevel level) {
    _minLevel = level;
  }

  /// Add a sink for forwarding logs (e.g. remote logging).
  static void addSink(PlexLogSink sink) {
    _sinks.add(sink);
  }

  /// Remove a sink.
  static void removeSink(PlexLogSink sink) {
    _sinks.remove(sink);
  }

  static bool _shouldLog(PlexLogLevel level) {
    if (level.index < _minLevel.index) return false;
    if (kReleaseMode && (level == PlexLogLevel.verbose || level == PlexLogLevel.debug)) {
      return false;
    }
    return true;
  }

  static void _log(
    PlexLogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stack,
  }) {
    if (!_shouldLog(level)) return;

    final formatted = _format(level, tag, message, error: error, stack: stack);

    if (kDebugMode) {
      // ignore: avoid_print
      print(formatted);
    }

    for (final sink in _sinks) {
      sink.write(level, tag, message, error: error, stack: stack);
    }
  }

  static String _format(
    PlexLogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stack,
  }) {
    final levelStr = level.name.toUpperCase().padRight(7);
    final buffer = StringBuffer('[PLEX][$levelStr][$tag] $message');
    if (error != null) {
      buffer.write('\n  Error: $error');
    }
    if (stack != null) {
      buffer.write('\n  $stack');
    }
    return buffer.toString();
  }

  static void v(String tag, String message) => _log(PlexLogLevel.verbose, tag, message);

  static void d(String tag, String message) => _log(PlexLogLevel.debug, tag, message);

  static void i(String tag, String message) => _log(PlexLogLevel.info, tag, message);

  static void w(String tag, String message, {Object? error, StackTrace? stack}) => _log(PlexLogLevel.warning, tag, message, error: error, stack: stack);

  static void e(String tag, String message, {Object? error, StackTrace? stack}) => _log(PlexLogLevel.error, tag, message, error: error, stack: stack);
}
