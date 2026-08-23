import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_utils/plex_printer.dart';

void main() {
  test('buildExcelBytes starts with xlsx zip magic bytes', () {
    final List<int> xlsx = PlexPrinter.buildExcelBytes(
      'People',
      <dynamic>['Name', 'Age'],
      <List<dynamic>>[
        <dynamic>['Bob', 30],
      ],
    );
    expect(xlsx, isNotEmpty);
    expect(xlsx[0], 0x50);
    expect(xlsx[1], 0x4B);
  });
}
