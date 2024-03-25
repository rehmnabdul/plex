import 'package:path_provider/path_provider.dart';
import 'package:plex/plex_database/plex_collection.dart';
import 'package:plex/plex_database/plex_entity.dart';
import 'package:plex/plex_database/plex_entity_collection.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class PlexDbConfig {
  String dbName;

  PlexDbConfig(this.dbName);
}

class PlexDb {
  bool get initialized => _initialized;

  final PlexDbConfig _dbConfig;
  var _initialized = false;
  Database? _database;

  PlexDb._(this._dbConfig);

  static Future<PlexDb> initialize(PlexDbConfig dbConfig) async {
    var plexDb = PlexDb._(dbConfig);
    await plexDb._openDatabase();
    return plexDb;
  }

  Future _openDatabase() async {
    final appDocumentDir = await getApplicationCacheDirectory();
    final dbPath = "${appDocumentDir.path}/${_dbConfig.dbName}";
    _database = await databaseFactoryIo.openDatabase(dbPath);
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
}
