import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plex/plex_database/plex_collection.dart';
import 'package:plex/plex_database/plex_database.dart';
import 'package:sembast/sembast_io.dart';

class _MockPathProvider extends PathProviderPlatform {
  @override
  Future<String?> getApplicationCachePath() async => Directory.systemTemp.path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    PathProviderPlatform.instance = _MockPathProvider();
  });

  group('PlexDb', () {
    late PlexDb db;

    setUp(() async {
      db = await PlexDb.initialize(PlexDbConfig('test_plex_db_${DateTime.now().millisecondsSinceEpoch}.db'));
    });

    tearDown(() async {
      await db.closeDatabase();
    });

    test('initializes successfully', () {
      expect(db.initialized, true);
    });

    test('getCollection returns PlexCollection', () {
      final collection = db.getCollection('test_collection');
      expect(collection, isA<PlexCollection>());
    });

    test('PlexCollection insert and getById', () async {
      final collection = db.getCollection('items');
      final record = {'name': 'Test', 'value': 42};

      await collection.insert(record);

      expect(record['entityId'], isNotNull);
      final id = record['entityId'] as int;

      final fetched = await collection.getById(id);
      expect(fetched, isNotNull);
      expect(fetched!['name'], 'Test');
      expect(fetched['value'], 42);
    });

    test('PlexCollection insert rejects record with existing entityId', () async {
      final collection = db.getCollection('items2');
      final record = {'entityId': 999, 'name': 'Invalid'};

      expect(
        () => collection.insert(record),
        throwsA(isA<Exception>()),
      );
    });

    test('PlexCollection getAll returns all records', () async {
      final collection = db.getCollection('items3');
      await collection.insert({'name': 'A'});
      await collection.insert({'name': 'B'});

      final all = await collection.getAll();
      expect(all.length, 2);
    });

    test('PlexCollection deleteById removes record', () async {
      final collection = db.getCollection('items4');
      final record = <String, dynamic>{'name': 'ToDelete'};
      await collection.insert(record);
      final id = record['entityId'] as int;

      await collection.deleteById(id);
      final fetched = await collection.getById(id);
      expect(fetched, isNull);
    });
  });
}
