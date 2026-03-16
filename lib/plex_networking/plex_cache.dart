import 'package:plex/plex_database/plex_database.dart';

/// Configuration for HTTP response caching.
class PlexCacheConfig {
  /// Maximum age before a cached response is considered stale.
  final Duration maxAge;

  /// Optional maximum stale duration. If set, responses older than [maxAge]
  /// but within [maxStale] may still be served when network is unavailable.
  final Duration? maxStale;

  /// Optional custom cache key generator. Defaults to url + sorted query params.
  final String Function(String url, Map<String, dynamic>? query)? cacheKey;

  const PlexCacheConfig({
    this.maxAge = const Duration(minutes: 5),
    this.maxStale,
    this.cacheKey,
  });
}

/// Cache layer for GET responses using PlexDb/Sembast.
class PlexCacheLayer {
  final PlexCacheConfig config;
  final PlexDb db;

  PlexCacheLayer(this.config, this.db);

  String _buildCacheKey(String url, Map<String, dynamic>? query) {
    if (config.cacheKey != null) {
      return config.cacheKey!(url, query);
    }
    if (query == null || query.isEmpty) return url;
    final sorted = query.keys.toList()..sort();
    final queryStr = sorted.map((k) => '$k=${query[k]}').join('&');
    return '$url?$queryStr';
  }

  /// Get cached response if fresh. Returns the cached body string or null if miss/stale.
  Future<String?> get(String url, Map<String, dynamic>? query) async {
    if (!db.initialized) return null;
    final key = _buildCacheKey(url, query);
    final cached = await db.getFromCache(key);
    if (cached == null) return null;
    final cachedAt = cached['cachedAt'] as int?;
    if (cachedAt == null) return null;
    final age = DateTime.now().millisecondsSinceEpoch - cachedAt;
    if (age <= config.maxAge.inMilliseconds) {
      return cached['body'] as String?;
    }
    if (config.maxStale != null && age <= (config.maxAge + config.maxStale!).inMilliseconds) {
      return cached['body'] as String?;
    }
    return null;
  }

  /// Store a successful GET response. [body] is the raw response string (e.g. JSON).
  Future<void> put(String url, Map<String, dynamic>? query, String body) async {
    if (!db.initialized) return;
    final key = _buildCacheKey(url, query);
    await db.putInCache(key, {
      'url': url,
      'body': body,
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Clear cache entries. If [urlPattern] is provided, only matching keys are cleared.
  Future<void> clear({String? urlPattern}) async {
    await db.clearCache(urlPattern: urlPattern);
  }
}
