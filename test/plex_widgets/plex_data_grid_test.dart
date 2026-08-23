import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_printer.dart';
import 'package:plex/plex_widgets/plex_data_grid.dart';

class _Person {
  const _Person({
    required this.id,
    required this.name,
    required this.age,
    this.dept = 'Eng',
    this.role = 'Staff',
  });

  final int id;
  final String name;
  final int age;
  final String dept;
  final String role;
}

const List<_Person> _people = <_Person>[
  _Person(id: 1, name: 'Bob', age: 30, dept: 'Eng', role: 'Dev'),
  _Person(id: 2, name: 'Alice', age: 20, dept: 'Eng', role: 'Dev'),
  _Person(id: 3, name: 'Carol', age: 25, dept: 'HR', role: 'Staff'),
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
  List<PlexDataGridColumn<_Person>>? columns,
  PlexDataGridSelectionMode selectionMode = PlexDataGridSelectionMode.none,
  ValueChanged<List<_Person>>? onSelectionChanged,
  ValueChanged<PlexDataGridSort?>? onSort,
  ValueChanged<String>? onSearch,
  int pageSize = 25,
  bool loading = false,
  bool showSearch = true,
  bool showColumnFilters = false,
  bool enableGrouping = false,
  String? groupByColumnId,
  List<String>? groupByColumnIds,
  bool autoExpandGroups = true,
  bool showGroupSummaries = true,
  PlexDataGridGroupSummary<_Person>? groupSummary,
  bool enableCsvExport = false,
  bool enableExcelExport = false,
  bool enablePdfExport = false,
  PlexDataGridCellStyle? Function(_Person row)? rowStyle,
}) {
  return PlexDataGrid<_Person>(
    columns: columns ?? _columns,
    rows: rows,
    rowId: (_Person row) => row.id,
    selectionMode: selectionMode,
    onSelectionChanged: onSelectionChanged,
    onSort: onSort,
    onSearch: onSearch,
    pageSize: pageSize,
    loading: loading,
    showSearch: showSearch,
    showColumnFilters: showColumnFilters,
    enableGrouping: enableGrouping,
    groupByColumnId: groupByColumnId,
    groupByColumnIds: groupByColumnIds,
    autoExpandGroups: autoExpandGroups,
    showGroupSummaries: showGroupSummaries,
    groupSummary: groupSummary,
    enableCsvExport: enableCsvExport,
    enableExcelExport: enableExcelExport,
    enablePdfExport: enablePdfExport,
    rowStyle: rowStyle,
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

  test('engine search, column filter, sort, csv, and grouping', () {
    final List<_Person> searched = PlexDataGridEngine.search(
      _people,
      _columns,
      'a',
    );
    expect(searched.map((_Person p) => p.name), <String>['Alice', 'Carol']);

    final List<_Person> filtered = PlexDataGridEngine.filter(
      _people,
      _columns,
      <String, PlexDataGridColumnFilter>{
        'name': const PlexDataGridColumnFilter(
          columnId: 'name',
          query: 'Alice',
          match: PlexDataGridFilterMatch.equals,
        ),
      },
    );
    expect(filtered.map((_Person p) => p.name), <String>['Alice']);

    final List<_Person> sorted = PlexDataGridEngine.sort(
      List<_Person>.from(_people),
      _columns,
      const PlexDataGridSort(
        columnId: 'name',
        direction: PlexDataGridSortDirection.ascending,
      ),
    );
    expect(sorted.map((_Person p) => p.name), <String>['Alice', 'Bob', 'Carol']);

    final List<PlexDataGridGroup<_Person>> groups = PlexDataGridEngine.group(
      _people,
      _deptColumns.last,
    );
    expect(groups, hasLength(2));
    expect(groups.first.key, 'Eng');
    expect(groups.first.rows, hasLength(2));
    expect(groups.last.key, 'HR');
    expect(groups.last.rows, hasLength(1));

    final List<PlexDataGridLine<_Person>> collapsed =
        PlexDataGridEngine.flatten(
      groups,
      caption: (PlexDataGridGroup<_Person> g) =>
          PlexDataGridEngine.defaultGroupCaption(g.key, g.rows.length),
      isExpanded: (String key) => false,
    );
    expect(collapsed, hasLength(2));
    expect(collapsed.every((PlexDataGridLine<_Person> l) => l.isGroup), isTrue);
    expect(collapsed.first.groupCaption, 'Eng (2)');

    final List<PlexDataGridLine<_Person>> expanded =
        PlexDataGridEngine.flatten(
      groups,
      caption: (PlexDataGridGroup<_Person> g) =>
          PlexDataGridEngine.defaultGroupCaption(g.key, g.rows.length),
      isExpanded: (String key) => true,
    );
    expect(
      expanded.where((PlexDataGridLine<_Person> l) => !l.isGroup),
      hasLength(3),
    );

    final String csv = PlexDataGridEngine.csv(_columns, _people);
    expect(csv, contains('Name,Age'));
    expect(csv, contains('Bob'));
    expect(csv, contains('30'));
  });

  test('printer csv quotes commas and pdf/excel bytes look valid', () {
    final String csv = PlexPrinter.buildCsv(
      <dynamic>['Name', 'Note'],
      <List<dynamic>>[
        <dynamic>['Bob', 'hello, world'],
        <dynamic>['Alice', 'say "hi"'],
      ],
    );
    expect(csv, contains('"hello, world"'));
    expect(csv, contains('"say ""hi"""'));

    final List<int> pdf = PlexPrinter.buildTablePdf(
      'People',
      <dynamic>['Name', 'Age'],
      <List<dynamic>>[
        <dynamic>['Bob', 30],
      ],
    );
    expect(String.fromCharCodes(pdf.take(5)), '%PDF-');

    final List<int> xlsx = PlexPrinter.buildExcelBytes(
      'People',
      <dynamic>['Name', 'Age'],
      <List<dynamic>>[
        <dynamic>['Bob', 30],
      ],
    );
    expect(xlsx[0], 0x50);
    expect(xlsx[1], 0x4B);
  });

  testWidgets('column filter and search apply together', (tester) async {
    await tester.pumpWidget(_wrap(_grid(showColumnFilters: true)));
    await tester.enterText(
      find.byKey(const Key('plex-data-grid-column-filter-name')),
      'a',
    );
    await tester.pump();
    expect(find.byKey(const ValueKey<Object>('plex-data-grid-row-1')),
        findsNothing);
    expect(find.byKey(const ValueKey<Object>('plex-data-grid-row-2')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<Object>('plex-data-grid-row-3')),
        findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('plex-data-grid-search')),
      'Carol',
    );
    await tester.pump();
    expect(find.byKey(const ValueKey<Object>('plex-data-grid-row-2')),
        findsNothing);
    expect(find.byKey(const ValueKey<Object>('plex-data-grid-row-3')),
        findsOneWidget);
  });

  testWidgets('grouping collapses rows under group headers', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _grid(
          columns: _deptColumns,
          enableGrouping: true,
          groupByColumnId: 'dept',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Eng (2)'), findsOneWidget);
    expect(find.text('HR (1)'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Carol'), findsOneWidget);

    await tester.tap(find.byKey(const Key('plex-data-grid-group-Eng')));
    await tester.pump();

    expect(find.text('Eng (2)'), findsOneWidget);
    expect(find.text('Bob'), findsNothing);
    expect(find.text('Alice'), findsNothing);
    expect(find.text('Carol'), findsOneWidget);
  });

  test('nested groupBy flattens outer then inner groups', () {
    final List<PlexDataGridGroup<_Person>> nested = PlexDataGridEngine.groupBy(
      _people,
      <PlexDataGridColumn<_Person>>[_nestedColumns[2], _nestedColumns[3]],
    );
    expect(nested, hasLength(2));
    expect(nested.first.key, 'Eng');
    expect(nested.first.columnId, 'dept');
    expect(nested.first.rows, hasLength(2));
    expect(nested.first.children, hasLength(1));
    expect(nested.first.children.first.key, 'Eng/role:Dev');
    expect(nested.first.children.first.value, 'Dev');
    expect(nested.first.children.first.rows, hasLength(2));
    expect(nested.last.children.first.value, 'Staff');

    final List<PlexDataGridLine<_Person>> lines = PlexDataGridEngine.flatten(
      nested,
      caption: (PlexDataGridGroup<_Person> g) =>
          PlexDataGridEngine.defaultGroupCaption(
        (g.value ?? g.key).toString(),
        g.rows.length,
      ),
      isExpanded: (String key) => true,
      showSummaries: true,
    );
    expect(
      lines.map((PlexDataGridLine<_Person> l) => l.isGroup).toList(),
      <bool>[
        true,
        true,
        false,
        false,
        false,
        false,
        true,
        true,
        false,
        false,
        false,
      ],
    );
    expect(lines[0].groupCaption, 'Eng (2)');
    expect(lines[1].groupCaption, 'Dev (2)');
    expect(lines[1].groupKey, 'Eng/role:Dev');
    expect(lines[2].isSummary, isFalse);
    expect(lines[4].isSummary, isTrue);
    expect(lines[5].isSummary, isTrue);
    expect(lines[5].groupKey, 'Eng');
  });

  test('default group summary counts rows and sums numeric columns', () {
    final List<PlexDataGridGroup<_Person>> groups = PlexDataGridEngine.group(
      _people,
      _deptColumns.last,
    );
    final List<PlexDataGridSummaryCell> eng =
        PlexDataGridEngine.defaultGroupSummary(groups.first, _deptColumns);
    expect(
      eng.map((PlexDataGridSummaryCell c) => '${c.columnId}:${c.text}'),
      containsAll(<String>['name:2 items', 'age:Sum 50']),
    );
  });

  testWidgets('nested grouping shows inner group headers', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _grid(
          columns: _nestedColumns,
          enableGrouping: true,
          groupByColumnIds: const <String>['dept', 'role'],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Eng (2)'), findsOneWidget);
    expect(find.text('Dev (2)'), findsOneWidget);
    expect(find.text('HR (1)'), findsOneWidget);
    expect(find.text('Staff (1)'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.byKey(const Key('plex-data-grid-group-Eng/role:Dev')),
        findsOneWidget);

    await tester.tap(find.byKey(const Key('plex-data-grid-group-Eng')));
    await tester.pump();
    expect(find.text('Dev (2)'), findsNothing);
    expect(find.text('Bob'), findsNothing);
    expect(find.text('Carol'), findsOneWidget);
  });

  testWidgets('group summaries are visible by default and hide from the toolbar',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        _grid(
          columns: _deptColumns,
          enableGrouping: true,
          groupByColumnId: 'dept',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('2 items'), findsOneWidget);
    expect(find.text('Sum 50'), findsOneWidget);
    expect(find.text('1 items'), findsOneWidget);
    expect(find.text('Sum 25'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);

    await tester.tap(find.byKey(const Key('plex-data-grid-summaries-toggle')));
    await tester.pump();

    expect(find.text('2 items'), findsNothing);
    expect(find.text('Sum 50'), findsNothing);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Eng (2)'), findsOneWidget);
  });

  testWidgets('custom groupSummary receives leaf rows and replaces default',
      (tester) async {
    final List<PlexDataGridGroup<_Person>> captured =
        <PlexDataGridGroup<_Person>>[];
    await tester.pumpWidget(
      _wrap(
        _grid(
          columns: _deptColumns,
          enableGrouping: true,
          groupByColumnId: 'dept',
          groupSummary: (PlexDataGridGroup<_Person> group) {
            captured.add(group);
            return <PlexDataGridSummaryCell>[
              PlexDataGridSummaryCell(
                columnId: 'name',
                text: 'custom-${group.rows.length}',
              ),
            ];
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.text('custom-2'), findsOneWidget);
    expect(find.text('custom-1'), findsOneWidget);
    expect(find.text('2 items'), findsNothing);
    expect(captured, isNotEmpty);
    expect(
      captured.first.rows.map((_Person p) => p.name).toList(),
      <String>['Bob', 'Alice'],
    );
  });

  testWidgets('export buttons appear when flags are on', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _grid(
          enableCsvExport: true,
          enableExcelExport: true,
          enablePdfExport: true,
        ),
      ),
    );
    expect(find.byKey(const Key('plex-data-grid-csv')), findsOneWidget);
    expect(find.byKey(const Key('plex-data-grid-excel')), findsOneWidget);
    expect(find.byKey(const Key('plex-data-grid-pdf')), findsOneWidget);
  });

  testWidgets('custom button in a column fires callback', (tester) async {
    int taps = 0;
    final List<PlexDataGridColumn<_Person>> columns =
        <PlexDataGridColumn<_Person>>[
      ..._columns,
      PlexDataGridColumn<_Person>(
        id: 'action',
        title: 'Action',
        value: (_Person row) => row.id,
        cell: (BuildContext context, _Person row) {
          return TextButton(
            onPressed: () => taps++,
            child: Text('Edit ${row.name}'),
          );
        },
      ),
    ];

    await tester.pumpWidget(_wrap(_grid(columns: columns)));
    await tester.tap(find.text('Edit Bob'));
    await tester.pump();
    expect(taps, 1);

    final List<List<dynamic>> matrix =
        PlexDataGridEngine.exportMatrix(columns, _people);
    expect(matrix.first, <dynamic>['Bob', 30, 1]);
    expect(matrix.first.every((dynamic cell) => cell is! Widget), isTrue);

    final String csv = PlexDataGridEngine.csv(columns, _people);
    expect(csv, contains('Bob,30,1'));
    expect(csv, isNot(contains('Edit Bob')));
  });

  testWidgets('rowStyle applies to default text cells', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _grid(
          rowStyle: (_Person row) => row.name == 'Bob'
              ? const PlexDataGridCellStyle(color: Colors.red)
              : null,
        ),
      ),
    );

    expect(tester.widget<Text>(find.text('Bob')).style?.color, Colors.red);
    expect(tester.widget<Text>(find.text('Alice')).style?.color, isNot(Colors.red));
    expect(tester.widget<Text>(find.text('Carol')).style?.color, isNot(Colors.red));
  });

  testWidgets('cellStyle overrides rowStyle for that column', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _grid(
          rowStyle: (_Person row) => row.name == 'Bob'
              ? const PlexDataGridCellStyle(color: Colors.blue)
              : null,
          columns: <PlexDataGridColumn<_Person>>[
            PlexDataGridColumn<_Person>(
              id: 'name',
              title: 'Name',
              value: (_Person row) => row.name,
              cellStyle: (_Person row) => row.name == 'Bob'
                  ? const PlexDataGridCellStyle(color: Colors.green)
                  : null,
            ),
            PlexDataGridColumn<_Person>(
              id: 'age',
              title: 'Age',
              numeric: true,
              value: (_Person row) => row.age,
            ),
          ],
        ),
      ),
    );

    expect(tester.widget<Text>(find.text('Bob')).style?.color, Colors.green);
    expect(tester.widget<Text>(find.text('30')).style?.color, Colors.blue);
  });

  testWidgets('condition: negative numbers red', (tester) async {
    const List<_Person> rows = <_Person>[
      _Person(id: 10, name: 'Pos', age: 5),
      _Person(id: 11, name: 'Neg', age: -7),
    ];
    await tester.pumpWidget(
      _wrap(
        _grid(
          rows: rows,
          columns: <PlexDataGridColumn<_Person>>[
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
              cellStyle: (_Person row) => row.age < 0
                  ? const PlexDataGridCellStyle(
                      color: Colors.red,
                      fontSize: 18,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );

    final Text negative = tester.widget<Text>(find.text('-7'));
    expect(negative.style?.color, Colors.red);
    expect(negative.style?.fontSize, 18);

    final Text positive = tester.widget<Text>(find.text('5'));
    expect(positive.style?.color, isNot(Colors.red));
    expect(positive.style?.fontSize, isNot(18));
  });
}

final List<PlexDataGridColumn<_Person>> _deptColumns =
    <PlexDataGridColumn<_Person>>[
  ..._columns,
  PlexDataGridColumn<_Person>(
    id: 'dept',
    title: 'Dept',
    value: (_Person row) => row.dept,
  ),
];

final List<PlexDataGridColumn<_Person>> _nestedColumns =
    <PlexDataGridColumn<_Person>>[
  ..._deptColumns,
  PlexDataGridColumn<_Person>(
    id: 'role',
    title: 'Role',
    value: (_Person row) => row.role,
  ),
];

