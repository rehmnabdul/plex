import 'package:path_provider/path_provider.dart';
import 'package:plex/plex_database/plex_collection.dart';
import 'package:plex/plex_database/plex_db_codec.dart';
import 'package:plex/plex_database/plex_entity.dart';
import 'package:plex/plex_database/plex_entity_collection.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class PlexDbConfig {
  String dbName;
  final bool encrypted;

  PlexDbConfig(this.dbName, {this.encrypted = false});
}

/// A database migration with a version number and an [up] function.
class PlexDbMigration {
  final int version;
  final Future<void> Function(PlexDb db) up;

  const PlexDbMigration({required this.version, required this.up});
}

/// Runs pending migrations in order. Called internally by [PlexDb.initialize].
Future<void> runMigrations(PlexDb db, List<PlexDbMigration> migrations) async {
  if (migrations.isEmpty) return;

  var currentVersion = 0;
  final stored = await db.getFromCache('_plex_schema_version');
  if (stored != null && stored['v'] != null) {
    currentVersion = (stored['v'] as num).toInt();
  }

  final sorted = List<PlexDbMigration>.from(migrations)
    ..sort((a, b) => a.version.compareTo(b.version));

  for (final m in sorted) {
    if (m.version <= currentVersion) continue;
    await m.up(db);
    currentVersion = m.version;
    await db.putInCache('_plex_schema_version', {'v': currentVersion});
  }
}

class PlexDb {
  bool get initialized => _initialized;

  final PlexDbConfig _dbConfig;
  var _initialized = false;
  Database? _database;

  PlexDb._(this._dbConfig);

  static Future<PlexDb> initialize(
    PlexDbConfig dbConfig, {
    List<PlexDbMigration> migrations = const [],
  }) async {
    var plexDb = PlexDb._(dbConfig);
    await plexDb._openDatabase();
    await runMigrations(plexDb, migrations);
    return plexDb;
  }

  Future _openDatabase() async {
    final appDocumentDir = await getApplicationCacheDirectory();
    final dbPath = "${appDocumentDir.path}/${_dbConfig.dbName}";
    SembastCodec? codec;
    if (_dbConfig.encrypted) {
      final key = await getOrCreateDbKey();
      codec = createAesEncryptionCodec(key);
    }
    _database = await databaseFactoryIo.openDatabase(dbPath, codec: codec);
    _initialized = true;
  }

  Future<void> closeDatabase() async {
    await _database?.close();
    _database = null;
  }

  PlexCollection getCollection(String name) {
    return PlexCollection(name, _database!);
  }

  PlexEntityCollection<T> getEntityCollection<T extends PlexEntity>(
    String name, {
    required T Function(Map<String, dynamic> map) fromJson,
    required Map<String, dynamic> Function(T entity) toJson,
  }) {
    return PlexEntityCollection(name, _database!, fromJson, toJson);
  }

  static const String _cacheStoreName = 'plex_http_cache';
  static final _cacheStore = stringMapStoreFactory.store(_cacheStoreName);

  /// Get a cached value by key. Returns null if not found.
  Future<Map<String, dynamic>?> getFromCache(String key) async {
    if (_database == null) return null;
    final value = await _cacheStore.record(key).get(_database!);
    return value != null ? Map<String, dynamic>.from(value as Map) : null;
  }

  /// Store a value in the cache.
  Future<void> putInCache(String key, Map<String, dynamic> value) async {
    if (_database == null) return;
    await _cacheStore.record(key).put(_database!, value);
  }

  /// Delete a cached value by key.
  Future<void> deleteFromCache(String key) async {
    if (_database == null) return;
    await _cacheStore.record(key).delete(_database!);
  }

  /// Clear cache. If [urlPattern] is provided, only keys containing the pattern are deleted.
  Future<void> clearCache({String? urlPattern}) async {
    if (_database == null) return;
    final keys = await getCacheKeys();
    for (final key in keys) {
      if (urlPattern == null || key.contains(urlPattern)) {
        await _cacheStore.record(key).delete(_database!);
      }
    }
  }

  /// List all cache keys.
  Future<List<String>> getCacheKeys() async {
    if (_database == null) return [];
    final records = await _cacheStore.find(_database!);
    return records.map((s) => s.key).toList();
  }
}
