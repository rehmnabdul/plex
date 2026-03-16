import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_networking/plex_networking.dart';

void main() {
  group('PlexNetworking', () {
    test('PlexSuccess parses JSON body', () {
      final success = PlexSuccess('{"key": "value"}');
      expect(success.response, isA<Map>());
      expect((success.response as Map)['key'], 'value');
    });

    test('PlexSuccess handles empty string body', () {
      final success = PlexSuccess('');
      expect(success.response, '');
    });

    test('PlexSuccess handles plain text body', () {
      final success = PlexSuccess('plain text');
      expect(success.response, 'plain text');
    });

    test('PlexError holds code and message', () {
      final error = PlexError<int>(404, 'Not Found');
      expect(error.code, 404);
      expect(error.message, 'Not Found');
    });

    test('PlexApiResult success structure', () {
      final result = PlexApiResult(true, 200, 'OK', {'data': 1});
      expect(result.success, true);
      expect(result.code, 200);
      expect(result.message, 'OK');
      expect(result.data, {'data': 1});
      expect(result.isLastPage, false);
    });

    test('PlexApiResult with isLastPage', () {
      final result = PlexApiResult(false, 400, 'Error', null, isLastPage: true);
      expect(result.isLastPage, true);
    });

    test('setBasePath accepts null and can be reset', () {
      PlexNetworking.instance.setBasePath(null);
      // When base path is null, any relative URL request will eventually throw.
      // The exact behavior depends on network availability; we verify setBasePath accepts null.
      PlexNetworking.instance.setBasePath('https://api.example.com');
      PlexNetworking.instance.setBasePath(null);
    });
  });
}
