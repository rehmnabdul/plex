// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_printer.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_adv_data_table.dart';
import 'package:plex/plex_widgets/plex_advance_data_table_adapter.dart';
import 'package:plex/plex_widgets/plex_data_grid.dart';

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

PlexWidgetController<List<List<PlexDataTableValueCell>>?> _controller({
  List<List<PlexDataTableValueCell>>? rows,
}) {
  return PlexWidgetController<List<List<PlexDataTableValueCell>>?>(
    data: rows ??
        <List<PlexDataTableValueCell>>[
          <PlexDataTableValueCell>[
            PlexDataTableValueCell.text('Name', 'Bob'),
            PlexDataTableValueCell.text('Age', 30, numberField: true),
          ],
          <PlexDataTableValueCell>[
            PlexDataTableValueCell.text('Name', 'Alice'),
            PlexDataTableValueCell.text('Age', 20, numberField: true),
          ],
        ],
  );
}

PlexAdvanceDataTable _table({
  required PlexWidgetController<List<List<PlexDataTableValueCell>>?> controller,
  List<PlexDataTableHeaderCell>? columns,
  bool showCheckboxColumn = false,
  bool enableExcelExport = false,
  bool enablePdfExport = false,
  int? pageSize,
  String Function(String columnName, List<PlexDataTableValueCell> row,
          List<List<PlexDataTableValueCell>> rows)?
      customGroupingSummary,
}) {
  return PlexAdvanceDataTable(
    title: 'People',
    controller: controller,
    showCheckboxColumn: showCheckboxColumn,
    enableExcelExport: enableExcelExport,
    enablePdfExport: enablePdfExport,
    pageSize: pageSize,
    customGroupingSummary: customGroupingSummary,
    columns: columns ??
        <PlexDataTableHeaderCell>[
          PlexDataTableHeaderCell.text('Name'),
          PlexDataTableHeaderCell.text('Age', isNumber: true),
        ],
  );
}

void main() {
  test('PlexDataTableValueCell is a Plex type with historic fields', () {
    final PlexDataTableValueCell text =
        PlexDataTableValueCell.text('Age', 30, numberField: true);
    expect(text.columnName, 'Age');
    expect(text.value, 30);
    expect(text.isNumber, isTrue);
    expect(text.isWidget, isFalse);
    expect(text.cellValue, isNull);
    expect(text.clone(newValue: 31).value, 31);

    final PlexDataTableValueCell custom = PlexDataTableValueCell.custom(
      'Flag',
      'yes',
      const SizedBox(key: Key('plex-cell-flag')),
    );
    expect(custom.columnName, 'Flag');
    expect(custom.isWidget, isTrue);
    expect(custom.cellValue, 'yes');
    expect(custom.value, isA<PlexComparableWidget>());
  });

  test('CustomColumnSizer still constructs as a no-op', () {
    expect(CustomColumnSizer(), isA<CustomColumnSizer>());
  });

  test('PlexPrinter.buildTablePdf emits a PDF document', () {
    final List<int> bytes = PlexPrinter.buildTablePdf(
      'People',
      <dynamic>['Name', 'Age'],
      <List<dynamic>>[
        <dynamic>['Bob', 30],
        <dynamic>['Alice', 20],
      ],
    );
    final String header = String.fromCharCodes(bytes.take(8));
    expect(header.startsWith('%PDF'), isTrue);
    final String asText = String.fromCharCodes(bytes);
    expect(asText.contains('EOF'), isTrue);
    expect(asText, contains('People'));
    expect(asText, contains('Bob'));
  });
  test('adapter maps header flags onto PlexDataGrid columns', () {
    final List<PlexDataGridColumn<List<PlexDataTableValueCell>>> columns =
        PlexAdvanceDataTableAdapter.columns(
      <PlexDataTableHeaderCell>[
        PlexDataTableHeaderCell.text(
          'Id',
          isNumber: true,
          showOrderByControl: false,
        ),
        PlexDataTableHeaderCell.text(
          'Name',
          showFilterControl: false,
        ),
      ],
    );

    expect(columns, hasLength(2));
    expect(columns[0].id, 'Id');
    expect(columns[0].title, 'Id');
    expect(columns[0].numeric, isTrue);
    expect(columns[0].sortable, isFalse);
    expect(columns[0].searchable, isTrue);
    expect(columns[1].sortable, isTrue);
    expect(columns[1].searchable, isFalse);

    final List<PlexDataTableValueCell> row = <PlexDataTableValueCell>[
      PlexDataTableValueCell.text('Id', 7, numberField: true),
      PlexDataTableValueCell.text('Name', 'Zed'),
    ];
    expect(columns[0].value(row), 7);
    expect(columns[1].value(row), 'Zed');
  });

  testWidgets('constructs with legacy header and cell API', (tester) async {
    await tester.pumpWidget(
      _wrap(_table(controller: _controller())),
    );
    await tester.pump();

    expect(find.byType(PlexAdvanceDataTable), findsOneWidget);
    expect(
      find.byType(PlexDataGrid<List<PlexDataTableValueCell>>),
      findsOneWidget,
    );
    expect(find.text('People'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('NAME'), findsOneWidget);
    expect(find.text('AGE'), findsOneWidget);
  });

  testWidgets('deprecation does not throw at runtime', (tester) async {
    await tester.pumpWidget(
      _wrap(_table(controller: _controller())),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Bob'), findsOneWidget);
  });

  testWidgets('search honors showFilterControl', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _table(
          controller: _controller(),
          columns: <PlexDataTableHeaderCell>[
            PlexDataTableHeaderCell.text('Name', showFilterControl: false),
            PlexDataTableHeaderCell.text('Age', isNumber: true),
          ],
        ),
      ),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('plex-data-grid-search')),
      'Alice',
    );
    await tester.pump();

    // Name is not searchable, so "Alice" matches no row. The query stays in the
    // search field, so assert on the other row and the empty state instead.
    expect(find.text('Bob'), findsNothing);
    expect(find.byKey(const Key('plex-data-grid-empty')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('plex-data-grid-search')),
      '30',
    );
    await tester.pump();

    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Alice'), findsNothing);
  });

  testWidgets('sort honors showOrderByControl', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _table(
          controller: _controller(),
          columns: <PlexDataTableHeaderCell>[
            PlexDataTableHeaderCell.text('Name', showOrderByControl: false),
            PlexDataTableHeaderCell.text('Age', isNumber: true),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getTopLeft(find.text('Bob')).dy <
          tester.getTopLeft(find.text('Alice')).dy,
      isTrue,
    );

    await tester.tap(find.text('NAME'));
    await tester.pump();

    expect(
      tester.getTopLeft(find.text('Bob')).dy <
          tester.getTopLeft(find.text('Alice')).dy,
      isTrue,
    );

    await tester.tap(find.text('AGE'));
    await tester.pump();

    expect(
      tester.getTopLeft(find.text('Alice')).dy <
          tester.getTopLeft(find.text('Bob')).dy,
      isTrue,
    );
  });

  testWidgets('selection honors showCheckboxColumn', (tester) async {
    await tester.pumpWidget(
      _wrap(_table(controller: _controller(), showCheckboxColumn: false)),
    );
    await tester.pump();
    expect(find.byType(Checkbox), findsNothing);

    await tester.pumpWidget(
      _wrap(_table(controller: _controller(), showCheckboxColumn: true)),
    );
    await tester.pump();
    expect(find.byType(Checkbox), findsWidgets);
  });

  testWidgets('excel and pdf flags honor constructor names', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _table(
          controller: _controller(),
          enableExcelExport: false,
          enablePdfExport: false,
        ),
      ),
    );
    await tester.pump();
    expect(
        find.byKey(const Key('plex-advance-data-table-excel')), findsNothing);
    expect(find.byKey(const Key('plex-advance-data-table-pdf')), findsNothing);

    await tester.pumpWidget(
      _wrap(
        _table(
          controller: _controller(),
          enableExcelExport: true,
          enablePdfExport: false,
        ),
      ),
    );
    await tester.pump();
    expect(
      find.byKey(const Key('plex-advance-data-table-excel')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('plex-advance-data-table-pdf')), findsNothing);
  });

  testWidgets('pdf export button is wired without throwing', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _table(
          controller: _controller(),
          enablePdfExport: true,
        ),
      ),
    );
    await tester.pump();

    expect(
        find.byKey(const Key('plex-advance-data-table-pdf')), findsOneWidget);
    final IconButton button = tester.widget<IconButton>(
      find.byKey(const Key('plex-advance-data-table-pdf')),
    );
    expect(button.onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('grouping callback accepts Plex cell rows', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _table(
          controller: _controller(),
          customGroupingSummary: (
            String columnName,
            List<PlexDataTableValueCell> row,
            List<List<PlexDataTableValueCell>> rows,
          ) {
            return '${row.length}/${rows.length}/$columnName';
          },
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Bob'), findsOneWidget);
  });
}
