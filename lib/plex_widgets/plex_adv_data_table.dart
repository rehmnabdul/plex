import 'package:flutter/material.dart';
import 'package:plex/plex_assets.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_utils/plex_printer.dart';
import 'package:plex/plex_widget.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;

class PlexDataTableHeaderCell {
  late final String columnName;
  late final bool isNumber;
  late final Widget? cell;

  ///[columnName] is required as it is text only cell
  PlexDataTableHeaderCell.text(this.columnName, {this.isNumber = false});

  ///For custom design and handling of cell use this constructor.
  ///[columnName] is optional
  ///[cell] is required for custom cell
  PlexDataTableHeaderCell.custom(
    this.columnName,
    this.cell, {
    this.isNumber = false,
  });
}

class PlexDataTableValueCell extends DataGridCell {
  late final bool isNumber;
  late final Widget? cell;

  ///[value] is required as it is text only cell
  PlexDataTableValueCell.text(String columnName, value, {bool numberField = false})
      : super(
          columnName: columnName,
          value: value,
        ) {
    value ??= "";
    isNumber = numberField || value is int || value is double;
    cell = null;
  }

  ///For custom design and handling of cell use this constructor.
  ///[value] is optional
  ///[cell] is required for custom cell
  PlexDataTableValueCell.custom(
    String columnName,
    value,
    this.cell, {
    bool numberField = false,
  }) : super(
          columnName: columnName,
          value: value,
        ) {
    isNumber = numberField || value is int || value is double;
  }
}

class PlexAdvanceDataTable extends StatefulWidget {
  const PlexAdvanceDataTable({
    Key? key,
    required this.title,
    required this.columns,
    required this.controller,
    this.pageSize,
    this.headerBackground,
    this.headerTextStyle,
    this.onRefresh,
    this.freezeColumns = 0,
    this.freezeRows = 0,
    this.alternateColor,
    this.enableCopy = false,
    this.enableExcelExport = true,
    this.enablePdfExport = true,
  }) : super(key: key);

  ///Title to show for the data set
  final String title;
  final int freezeColumns;
  final int freezeRows;

  ///Styles
  final Color? headerBackground;
  final TextStyle? headerTextStyle;
  final Color? alternateColor;

  ///On Refresh Button Click
  final Function()? onRefresh;

  ///Enable Disable Copy Field Value
  final bool enableCopy;

  ///Hide and show Print Button
  final bool enableExcelExport;
  final bool enablePdfExport;

  ///Hide and show Print Button
  final int? pageSize;
  final List<PlexDataTableHeaderCell> columns;
  final PlexWidgetController<List<List<PlexDataTableValueCell>>?> controller;

  @override
  State<PlexAdvanceDataTable> createState() => _PlexAdvanceDataTableState();
}

class _PlexAdvanceDataTableState extends State<PlexAdvanceDataTable> {
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  late _PlexAdvanceDataTableDataSource source;
  final DataGridController _dataGridController = DataGridController();

  List<List<PlexDataTableValueCell>>? getRows() => widget.controller.data;

  double getPages() => ((getRows()?.length ?? 0) / widget.pageSize!) + 1;

  @override
  void initState() {
    super.initState();
    initializeDataSource();
  }

  void initializeDataSource() {
    source = _PlexAdvanceDataTableDataSource(
      getRows() ?? List.empty(),
      pageSize: widget.pageSize,
      alternateColor: widget.alternateColor,
      dataGridController: _dataGridController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlexWidget(
      controller: widget.controller,
      createWidget: (context, data) {
        initializeDataSource();
        return Column(
          children: [
            spaceSmall(),
            Row(
              children: [
                Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Container()),
                if (widget.enableExcelExport) ...{
                  spaceSmall(),
                  FilledButton.tonal(
                    onPressed: () async {
                      final xl.Workbook workbook = key.currentState!.exportToExcelWorkbook();
                      workbook.worksheets[0].getRangeByIndex(1, 1, workbook.worksheets[0].rows.count, workbook.worksheets[0].columns.count).autoFit();
                      final List<int> bytes = workbook.saveAsStream();
                      var path = await PlexPrinter.saveExcelFile(widget.title, bytes);

                      if (path == null) {
                        context.showSnackBar("Unable to save file, Please try again...");
                      }
                      context.showSnackBar("Report saved at \"$path\"");
                    },
                    child: Image.asset(excel, width: 20, height: 20, color: Colors.green),
                  ),
                },
                if (widget.enablePdfExport) ...{
                  spaceSmall(),
                  FilledButton.tonal(
                    onPressed: () async {
                      var document = key.currentState!.exportToPdfDocument(autoColumnWidth: true);
                      final List<int> bytes = document.saveSync();
                      var path = await PlexPrinter.savePdfFile(widget.title, bytes);
                      if (path == null) {
                        context.showSnackBar("Unable to save file, Please try again...");
                      }
                      context.showSnackBar("Report saved at \"$path\"");
                    },
                    child: Image.asset(pdf, width: 20, height: 20, color: Colors.redAccent),
                  ),
                },
                if (widget.onRefresh != null) ...{
                  spaceSmall(),
                  FilledButton.tonal(
                    onPressed: () async {
                      widget.onRefresh?.call();
                    },
                    child: const Icon(Icons.refresh),
                  ),
                },
              ],
            ),
            spaceSmall(),
            Expanded(
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: widget.headerBackground,
                  filterIconColor: widget.headerTextStyle?.color?.withOpacity(0.8),
                  filterIconHoverColor: widget.headerTextStyle?.color,
                  sortIconColor: widget.headerTextStyle?.color?.withOpacity(0.8),
                  selectionColor: PlexTheme.selectionColor,
                ),
                child: SfDataGrid(
                  key: key,
                  allowColumnsResizing: false,
                  allowColumnsDragging: false,
                  frozenColumnsCount: widget.freezeColumns,
                  frozenRowsCount: widget.freezeRows,
                  allowFiltering: true,
                  allowSorting: true,
                  allowSwiping: false,
                  allowEditing: false,
                  showSortNumbers: true,
                  showCheckboxColumn: true,
                  selectionMode: SelectionMode.multiple,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  gridLinesVisibility: GridLinesVisibility.both,
                  allowMultiColumnSorting: true,
                  showVerticalScrollbar: true,
                  showHorizontalScrollbar: true,
                  isScrollbarAlwaysShown: true,
                  navigationMode: GridNavigationMode.cell,
                  onCellTap: (details) {
                    if (details.rowColumnIndex.rowIndex == 0) return;
                    if (widget.enableCopy) {
                      var cell = source._dataGridRows[details.rowColumnIndex.rowIndex - 1].getCells()[details.rowColumnIndex.columnIndex];
                      debugPrint(cell.value?.toString());
                      context.copyToClipboard(cell.value?.toString() ?? "N/A");
                    }
                  },
                  source: source,
                  columns: widget.columns
                      .map(
                        (e) => GridColumn(
                          columnName: e.columnName,
                          columnWidthMode: ColumnWidthMode.auto,
                          label: Padding(
                            padding: const EdgeInsets.all(Dim.medium),
                            child: Text(
                              e.columnName,
                              style: widget.headerTextStyle,
                              softWrap: true,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            if (widget.pageSize != null) ...{
              SfDataPager(
                delegate: source,
                pageCount: getPages(),
                direction: Axis.horizontal,
              ),
            },
          ],
        );
      },
    );
  }
}

class _PlexAdvanceDataTableDataSource extends DataGridSource {
  late List<DataGridRow> _data;
  List<DataGridRow> _dataGridRows = [];
  Color? _alternateColor;
  final DataGridController dataGridController;

  final int? pageSize;

  _PlexAdvanceDataTableDataSource(
    List<List<PlexDataTableValueCell>> data, {
    required this.pageSize,
    required this.dataGridController,
    Color? alternateColor,
  }) {
    _data = data.map((e) => DataGridRow(cells: e)).toList();
    _dataGridRows = pageSize != null && pageSize! <= data.length ? _data.getRange(0, pageSize!).toList(growable: false) : _data;
    _alternateColor = alternateColor;
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  bool shouldRecalculateColumnWidths() {
    return true;
  }

  int isAlternate = -1;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: isAlternate++ % 2 == 0 ? _alternateColor : null,
        cells: row.getCells().map((dataGridCell) {
          var cell = dataGridCell as PlexDataTableValueCell;
          return cell.cell ??
              Padding(
                padding: const EdgeInsets.all(Dim.medium - 1),
                child: Text(
                  dataGridCell.value.toString(),
                  textAlign: cell.isNumber ? TextAlign.right : TextAlign.left,
                  softWrap: true,
                ),
              );
        }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (pageSize == null) return false;
    int startIndex = newPageIndex * pageSize!;
    int endIndex = startIndex + pageSize!;
    if (startIndex < _data.length) {
      if (endIndex <= _data.length) {
        _dataGridRows = _data.getRange(startIndex, endIndex).toList(growable: false);
      } else {
        _dataGridRows = _data.getRange(startIndex, _data.length).toList(growable: false);
      }
    } else {
      _dataGridRows = [];
    }
    notifyListeners();

    return true;
  }
}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    style = style.copyWith(fontWeight: FontWeight.bold);
    return super.computeHeaderCellWidth(column, style);
  }

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue, TextStyle textStyle) {
    textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}