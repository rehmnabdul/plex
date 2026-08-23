import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_data_grid.dart';

class _Person {
  const _Person({required this.id, required this.name, required this.age});

  final int id;
  final String name;
  final int age;
}

const List<_Person> _people = <_Person>[
  _Person(id: 1, name: 'Bob', age: 30),
  _Person(id: 2, name: 'Alice', age: 20),
  _Person(id: 3, name: 'Carol', age: 25),
];

final List<PlexDataGridColumn<_Person>> _columns =
    <PlexDataGridColumn<_Person>>[
  PlexDataGridColumn<_Person>(
    id: 'name',
    title: 'Name',
    value: (_Person row) => row.name,
  ),
  PlexDataGridColumn<_Person>(
    id: 'age',
    title: 'Age',
    numeric: true,
    value: (_Person row) => row.age,
  ),
];

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
    ),
    home: Scaffold(
      body: SizedBox(width: 900, height: 640, child: child),
    ),
  );
}

PlexDataGrid<_Person> _grid({
  List<_Person> rows = _people,
  PlexDataGridSelectionMode selectionMode = PlexDataGridSelectionMode.none,
  ValueChanged<List<_Person>>? onSelectionChanged,
  ValueChanged<PlexDataGridSort?>? onSort,
  ValueChanged<String>? onSearch,
  int pageSize = 25,
  bool loading = false,
  bool showSearch = true,
}) {
  return PlexDataGrid<_Person>(
    columns: _columns,
    rows: rows,
    rowId: (_Person row) => row.id,
    selectionMode: selectionMode,
    onSelectionChanged: onSelectionChanged,
    onSort: onSort,
    onSearch: onSearch,
    pageSize: pageSize,
    loading: loading,
    showSearch: showSearch,
  );
}

void main() {
  testWidgets('builds with rows and columns', (tester) async {
    await tester.pumpWidget(_wrap(_grid()));
    expect(find.byType(PlexDataGrid<_Person>), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Carol'), findsOneWidget);
    expect(find.text('NAME'), findsOneWidget);
    expect(find.text('AGE'), findsOneWidget);
  });

  testWidgets('sort toggles row order and calls onSort', (tester) async {
    PlexDataGridSort? lastSort;
    await tester.pumpWidget(_wrap(_grid(onSort: (PlexDataGridSort? sort) {
      lastSort = sort;
    })));

    expect(
      tester.getTopLeft(find.text('Bob')).dy <
          tester.getTopLeft(find.text('Alice')).dy,
      isTrue,
    );

    await tester.tap(find.text('NAME'));
    await tester.pump();

    expect(lastSort?.columnId, 'name');
    expect(lastSort?.direction, PlexDataGridSortDirection.ascending);
    expect(
      tester.getTopLeft(find.text('Alice')).dy <
          tester.getTopLeft(find.text('Bob')).dy,
      isTrue,
    );

    await tester.tap(find.text('NAME'));
    await tester.pump();

    expect(lastSort?.direction, PlexDataGridSortDirection.descending);
    expect(
      tester.getTopLeft(find.text('Carol')).dy <
          tester.getTopLeft(find.text('Alice')).dy,
      isTrue,
    );
  });

  testWidgets('search hides unmatched rows and calls onSearch', (tester) async {
    String? query;
    await tester.pumpWidget(_wrap(_grid(onSearch: (String value) {
      query = value;
    })));

    await tester.enterText(
        find.byKey(const Key('plex-data-grid-search')), 'Alice');
    await tester.pump();

    expect(query, 'Alice');
    expect(find.byKey(const ValueKey<Object>('plex-data-grid-row-2')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<Object>('plex-data-grid-row-1')),
        findsNothing);
    expect(find.byKey(const ValueKey<Object>('plex-data-grid-row-3')),
        findsNothing);
  });

  testWidgets('single selection keeps only one row', (tester) async {
    List<_Person> selected = <_Person>[];
    await tester.pumpWidget(
      _wrap(
        _grid(
          selectionMode: PlexDataGridSelectionMode.single,
          onSelectionChanged: (List<_Person> rows) => selected = rows,
        ),
      ),
    );

    await tester.tap(find.byType(Checkbox).at(0));
    await tester.pump();
    expect(selected.map((_Person p) => p.name), <String>['Bob']);

    await tester.tap(find.byType(Checkbox).at(1));
    await tester.pump();
    expect(selected.map((_Person p) => p.name), <String>['Alice']);
    expect(selected, hasLength(1));
  });

  testWidgets('multiple selection keeps several rows', (tester) async {
    List<_Person> selected = <_Person>[];
    await tester.pumpWidget(
      _wrap(
        _grid(
          selectionMode: PlexDataGridSelectionMode.multiple,
          onSelectionChanged: (List<_Person> rows) => selected = rows,
        ),
      ),
    );

    // Index 0 is select-all; 1 and 2 are Bob and Alice.
    await tester.tap(find.byType(Checkbox).at(1));
    await tester.pump();
    await tester.tap(find.byType(Checkbox).at(2));
    await tester.pump();

    expect(
        selected.map((_Person p) => p.name).toList(), <String>['Bob', 'Alice']);
  });

  testWidgets('pagination next and previous change the visible page',
      (tester) async {
    await tester.pumpWidget(_wrap(_grid(pageSize: 1)));

    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Alice'), findsNothing);
    expect(find.text('Page 1 of 3'), findsOneWidget);

    await tester.tap(find.byTooltip('Next page'));
    await tester.pump();

    expect(find.text('Bob'), findsNothing);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Page 2 of 3'), findsOneWidget);

    await tester.tap(find.byTooltip('Previous page'));
    await tester.pump();

    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Page 1 of 3'), findsOneWidget);
  });

  testWidgets('empty state shows title when there are no rows', (tester) async {
    await tester.pumpWidget(_wrap(_grid(rows: const <_Person>[])));
    expect(find.byKey(const Key('plex-data-grid-empty')), findsOneWidget);
    expect(find.text('No rows to show'), findsOneWidget);
    expect(find.text('Bob'), findsNothing);
  });

  testWidgets('loading shows a progress bar', (tester) async {
    await tester.pumpWidget(_wrap(_grid(loading: true)));
    expect(find.byKey(const Key('plex-data-grid-loading')), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });
}
