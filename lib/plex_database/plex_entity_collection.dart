import 'package:plex/plex_database/plex_collection.dart';
import 'package:plex/plex_database/plex_entity.dart';
import 'package:sembast/sembast.dart';

class PlexEntityCollection<T extends PlexEntity> {
  final String name;
  final PlexCollection _collection;
  late T Function(Map<String, dynamic> map) fromJson;
  late Map<String, dynamic> Function(T) toJson;

  PlexEntityCollection(this.name, Database _database, this.fromJson, this.toJson) : _collection = PlexCollection(name, _database);

  Future insert(T record) async {
    await _collection.insert(toJson.call(record));
  }

  Future insertAll(List<T> records) async {
    await _collection.insertAll(records.map((e) => toJson.call(e)).toList());
  }

  Future update(T record) async {
    var map = toJson.call(record);
    map['entityId'] = record.entityId;
    await _collection.update(map);
  }

  Future delete(T record) async {
    await _collection.deleteById(record.entityId!);
  }

  Future deleteById(int id) async {
    await _collection.deleteById(id);
  }

  Future<T?> getById(int id) async {
    var map = await _collection.getById(id);
    if(map == null) return null;
    return fromJson.call(map);
  }

  Future<List<T>> getAll() async {
    return (await _collection.getAll()).map((map) {
      var entity = fromJson.call(map);
      entity.entityId = map[PlexCollection.ID_KEY];
      return entity;
    }).toList();
  }
}
