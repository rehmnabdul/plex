import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';

class PlexCollection {
  // ignore: non_constant_identifier_names
  static const String ID_KEY = "entityId";
  final String name;
  final Database _database;
  final StoreRef _collection;

  PlexCollection(this.name, this._database) : _collection = intMapStoreFactory.store(name);

  Future insert(Map<String, dynamic> record) async {
    if (record.containsKey(ID_KEY) && record[ID_KEY] != null) throw Exception("'entityId' must be 'null' to insert the record in collection");
    var entityId = await _collection.generateKey(_database);
    record[ID_KEY] = entityId;
    await _collection.record(entityId).add(_database, record);
  }

  Future insertAll(List<Map<String, dynamic>> records) async {
    if (records.any((e) => e.containsKey(ID_KEY) && e[ID_KEY] != null)) throw Exception("'entityId' must be 'null' to insert the record in collection");
    for (var element in records) {
      await insert(element);
    }
  }

  Future update(Map<String, dynamic> record) async {
    if (!record.containsKey(ID_KEY) || record[ID_KEY] == null) throw Exception("'entityId' must be not be 'null'");
    final finder = Finder(filter: Filter.byKey(record[ID_KEY] as int));
    await _collection.update(_database, record, finder: finder);
  }

  Future delete(Map<String, dynamic> record) async {
    if (!record.containsKey(ID_KEY) || record[ID_KEY] == null) throw Exception("'entityId' must be not be 'null'");
    await deleteById(record[ID_KEY] as int);
  }

  Future deleteById(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _collection.delete(_database, finder: finder);
  }

  Future<Map<String, dynamic>?> getById(int id) async {
    final recordSnapshot = await _collection.find(_database, finder: Finder(filter: Filter.byKey(id)));
    if (recordSnapshot.isEmpty) return null;
    var entity = recordSnapshot.first.value as Map<String, dynamic>;
    return Map<String, dynamic>.from(entity);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final recordSnapshot = await _collection.find(_database);
    return recordSnapshot.map((snapshot) {
      var entity = snapshot.value as Map<String, dynamic>;
      return cloneMap(entity);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> find({
    int? limit,
    int? offset,
  }) async {
    return findWithFinder(Finder(limit: limit, offset: offset));
  }

  /// Find records matching the given [finder].
  Future<List<Map<String, dynamic>>> findWithFinder(Finder finder) async {
    final recordSnapshot = await _collection.find(_database, finder: finder);
    return recordSnapshot.map((snapshot) {
      var map = cloneMap(snapshot.value as Map<String, dynamic>);
      map[ID_KEY] = snapshot.key as int?;
      return map;
    }).toList();
  }

  /// Stream of records matching the given [finder]; emits whenever data changes.
  Stream<List<Map<String, dynamic>>> watchWithFinder(Finder finder) {
    return _collection
        .query(finder: finder)
        .onSnapshots(_database)
        .map((snapshots) => snapshots.map((snapshot) {
              var map = cloneMap(snapshot.value as Map<String, dynamic>);
              map[ID_KEY] = snapshot.key as int?;
              return Map<String, dynamic>.from(map);
            }).toList());
  }

  /// Count records matching the given [finder].
  Future<int> countWithFinder(Finder finder) async {
    return _collection.query(finder: finder).count(_database);
  }

  /// Delete all records matching the given [finder].
  Future<int> deleteWithFinder(Finder finder) async {
    return _collection.delete(_database, finder: finder);
  }
}
