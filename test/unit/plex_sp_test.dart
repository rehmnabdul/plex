import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_sp.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlexSp', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await PlexSp.instance.initialize();
    });

    test('hasKey returns false for non-existent key', () {
      expect(PlexSp.instance.hasKey('non_existent'), false);
    });

    test('setString and getString work correctly', () async {
      await PlexSp.instance.setString('test_key', 'test_value');
      expect(PlexSp.instance.getString('test_key'), 'test_value');
      expect(PlexSp.instance.hasKey('test_key'), true);
    });

    test('setString with null removes the key', () async {
      await PlexSp.instance.setString('test_key', 'test_value');
      expect(PlexSp.instance.getString('test_key'), 'test_value');

      await PlexSp.instance.setString('test_key', null);
      expect(PlexSp.instance.getString('test_key'), isNull);
      expect(PlexSp.instance.hasKey('test_key'), false);
    });

    test('setBool and getBool work correctly', () async {
      await PlexSp.instance.setBool('bool_key', true);
      expect(PlexSp.instance.getBool('bool_key'), true);

      await PlexSp.instance.setBool('bool_key', false);
      expect(PlexSp.instance.getBool('bool_key'), false);
    });

    test('setInt and getInt work correctly', () async {
      await PlexSp.instance.setInt('int_key', 42);
      expect(PlexSp.instance.getInt('int_key'), 42);
    });

    test('setList and getList work correctly', () async {
      final list = ['a', 'b', 'c'];
      await PlexSp.instance.setList('list_key', list);
      expect(PlexSp.instance.getList('list_key'), list);
    });

    test('constants are defined', () {
      expect(PlexSp.loggedInUser, 'PLEX_LOGGED_IN_USER');
      expect(PlexSp.rememberUsers, 'PLEX_REMEMBER_USERS_LIST');
    });
  });
}
