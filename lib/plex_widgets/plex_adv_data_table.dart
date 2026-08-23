// ignore_for_file: deprecated_member_use_from_same_package, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_utils/plex_printer.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_advance_data_table_adapter.dart';
import 'package:plex/plex_widgets/plex_data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

enum WidthMode {
  none,
  fitByColumnName,
  fitByCellValue,
  lastColumnFill,
  fill,
  auto,
}

class PlexComparableWidget extends StatelessWidget {
  final Widget widget;
  final String value;

  const PlexComparableWidget(this.widget, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return widget;
  }

  int compareTo(PlexComparableWidget other) {
    return other.value.compareTo(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}

class PlexDataTableHeaderCell {
  final String columnName;
  final bool isNumber;
  final WidthMode widthMode;
  late final Widget? cell;

  final bool showOrderByControl;
  final bool showFilterControl;

  ///[columnName] is required as it is text only cell
  PlexDataTableHeaderCell.text(this.columnName,
      {this.isNumber = false,
      this.widthMode = WidthMode.auto,
      this.showOrderByControl = true,
      this.showFilterControl = true}) {
    cell = null;
  }

  ///For custom design and handling of cell use this constructor.
  ///[columnName] is optional
  ///[cell] is required for custom cell
  PlexDataTableHeaderCell.custom(this.columnName, this.cell,
      {this.isNumber = false,
      this.widthMode = WidthMode.auto,
      this.showOrderByControl = true,
      this.showFilterControl = true});

  ColumnWidthMode _getWidthMode() {
    switch (widthMode) {
      case WidthMode.none:
        return ColumnWidthMode.none;
      case WidthMode.fitByColumnName:
        return ColumnWidthMode.fitByColumnName;
      case WidthMode.fitByCellValue:
        return ColumnWidthMode.fitByCellValue;
      case WidthMode.lastColumnFill:
        return ColumnWidthMode.lastColumnFill;
      case WidthMode.fill:
        return ColumnWidthMode.fill;
      default:
        return ColumnWidthMode.auto;
    }
  }
}

class PlexDataTableValueCell extends DataGridCell {
  late final bool isNumber;
  late final bool isWidget;
  late final String? cellValue;

  ///[value] is required as it is text only cell
  PlexDataTableValueCell.text(String columnName, value,
      {bool numberField = false})
      : super(
          columnName: columnName,
          value: value,
        ) {
    value ??= "";
    isNumber = numberField || value is int || value is double;
    isWidget = false;
  }

  ///For custom design and handling of cell use this constructor.
  ///[value] is optional
  ///[cell] is required for custom cell
  PlexDataTableValueCell.custom(
    String columnName,
    String textValue,
    Widget widget, {
    bool numberField = false,
  }) : super(
            columnName: columnName,
            value: PlexComparableWidget(widget, textValue)) {
    cellValue = textValue;
    isWidget = true;
    isNumber = numberField || value is int || value is double;
  }

  PlexDataTableValueCell clone({dynamic newValue}) {
    if (!isWidget) {
      return PlexDataTableValueCell.text(columnName, newValue ?? value,
          numberField: isNumber);
    } else {
      return PlexDataTableValueCell.custom(
          columnName, newValue ?? cellValue, value,
          numberField: isNumber);
    }
  }
}

/// Deprecated compatibility wrapper around [PlexDataGrid].
///
/// Existing constructor parameters and [PlexDataTableHeaderCell] /
/// [PlexDataTableValueCell] models are unchanged. The visible grid is
/// [PlexDataGrid]. Excel export uses [PlexPrinter.printExcel]. PDF export
/// still uses a hidden Syncfusion [SfDataGrid] because
/// `exportToPdfDocument` requires [SfDataGridState].
///
/// Column grouping, frozen panes, and cell editing are still accepted on the
/// constructor so call sites compile; they are not mapped onto [PlexDataGrid].
@Deprecated('Use PlexDataGrid')
class PlexAdvanceDataTable extends StatefulWidget {
  @Deprecated('Use PlexDataGrid')
  const PlexAdvanceDataTable({
    super.key,
    required this.title,
    required this.columns,
    required this.controller,
    this.widthMode,
    this.pageSize,
    this.headerBackground,
    this.headerTextStyle,
    this.onRefresh,
    this.customWidgets,
    this.freezeColumns = 0,
    this.freezeRows = 0,
    this.showCheckboxColumn = true,
    this.alternateColor,
    this.enableCopy = false,
    this.enableColumnGrouping = true,
    this.initialColumnGroup,
    this.enableExcelExport = true,
    this.enablePdfExport = true,
    this.autoExpandGroups = true,
    this.groupSummary,
    this.groupSummaryFormat,
    this.customGroupingSummary,
    this.cellEditingWidget,
    this.cellEditingSubmit,
  });

  ///Title to show for the data set
  final String title;
  final int freezeColumns;
  final int freezeRows;
  final bool showCheckboxColumn;

  ///Styles
  final Color? headerBackground;
  final TextStyle? headerTextStyle;
  final Color? alternateColor;
  final WidthMode? widthMode;

  ///On Refresh Button Click
  final Function()? onRefresh;
  final List<Widget> Function(BuildContext context)? customWidgets;

  ///Enable Disable Column Grouping
  final bool enableColumnGrouping;
  final List<String>? initialColumnGroup;
  final bool autoExpandGroups;
  final String? groupSummaryFormat;
  final String Function(String summary)? groupSummary;
  final String Function(
      String columnName, DataGridRow row, List<DataGridRow> rows)?
      customGroupingSummary;

  ///Editing a Cell
  final Widget? Function(int row, int column)? cellEditingWidget;
  final Future Function(int row, int column)? cellEditingSubmit;

  ///Enable Disable Copy Field Value
  final bool enableCopy;

  ///Hide and show Print Button
  final bool enableExcelExport;
  final bool enablePdfExport;

  final int? pageSize;
  final List<PlexDataTableHeaderCell> columns;
  final PlexWidgetController<List<List<PlexDataTableValueCell>>?> controller;

  @override
  State<PlexAdvanceDataTable> createState() => _PlexAdvanceDataTableState();
}

class _PlexAdvanceDataTableState extends State<PlexAdvanceDataTable> {
  final GlobalKey<SfDataGridState> _exportKey = GlobalKey<SfDataGridState>();

  bool get _paginate => widget.pageSize != null && widget.pageSize! > 0;

  int _resolvedPageSize(List<List<PlexDataTableValueCell>> rows) {
    if (_paginate) return widget.pageSize!;
    return rows.isEmpty ? 1 : rows.length;
  }

  Future<void> _exportExcel(
    BuildContext context,
    List<List<PlexDataTableValueCell>> rows,
  ) async {
    try {
      final String? path = await PlexPrinter.printExcel(
        widget.title,
        PlexAdvanceDataTableAdapter.excelHeaders(widget.columns),
        PlexAdvanceDataTableAdapter.excelRows(widget.columns, rows),
      );
      if (!context.mounted) return;
      if (path == null) {
        context.showSnackBar("Unable to save file, Please try again...");
        return;
      }
      context.showSnackBar("Report saved at \"$path\"");
    } catch (_) {
      if (!context.mounted) return;
      context.showSnackBar("Unable to save file, Please try again...");
    }
  }

  Future<void> _exportPdf(BuildContext context) async {
    final SfDataGridState? state = _exportKey.currentState;
    if (state == null) {
      context.showSnackBar("Unable to save file, Please try again...");
      return;
    }
    try {
      final document = state.exportToPdfDocument(autoColumnWidth: true);
      final List<int> bytes = document.saveSync();
      final String? path = await PlexPrinter.savePdfFile(widget.title, bytes);
      if (!context.mounted) return;
      if (path == null) {
        context.showSnackBar("Unable to save file, Please try again...");
        return;
      }
      context.showSnackBar("Report saved at \"$path\"");
    } catch (_) {
      if (!context.mounted) return;
      context.showSnackBar("Unable to save file, Please try again...");
    }
  }

  Widget? _actions(
    BuildContext context,
    List<List<PlexDataTableValueCell>> rows,
  ) {
    final List<Widget> custom =
        widget.customWidgets?.call(context) ?? const <Widget>[];
    if (custom.isEmpty &&
        !widget.enableExcelExport &&
        !widget.enablePdfExport &&
        widget.onRefresh == null) {
      return null;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...custom,
        if (widget.enableExcelExport)
          IconButton(
            key: const Key('plex-advance-data-table-excel'),
            tooltip: 'Excel',
            onPressed: () => _exportExcel(context, rows),
            icon: const Icon(Icons.table_chart_outlined),
          ),
        if (widget.enablePdfExport)
          IconButton(
            key: const Key('plex-advance-data-table-pdf'),
            tooltip: 'Pdf',
            onPressed: () => _exportPdf(context),
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
        if (widget.onRefresh != null)
          IconButton(
            key: const Key('plex-advance-data-table-refresh'),
            tooltip: 'Refresh',
            onPressed: widget.onRefresh,
            icon: const Icon(Icons.refresh),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlexWidget(
      controller: widget.controller,
      createWidget: (BuildContext context, dynamic data) {
        final List<List<PlexDataTableValueCell>> rows =
            (data as List<List<PlexDataTableValueCell>>?) ??
                const <List<PlexDataTableValueCell>>[];
        return Column(
          children: [
            Expanded(
              child: PlexDataGrid<List<PlexDataTableValueCell>>(
                key: const Key('plex-advance-data-table-grid'),
                title: widget.title,
                columns: PlexAdvanceDataTableAdapter.columns(widget.columns),
                rows: rows,
                pageSize: _resolvedPageSize(rows),
                showFooter: _paginate,
                showSearch:
                    widget.columns.any((c) => c.showFilterControl),
                showDensityToggle: false,
                selectionMode: widget.showCheckboxColumn
                    ? PlexDataGridSelectionMode.multiple
                    : PlexDataGridSelectionMode.none,
                actions: _actions(context, rows),
              ),
            ),
            if (widget.enablePdfExport)
              Offstage(
                child: SizedBox(
                  width: 800,
                  height: 400,
                  child: SfDataGrid(
                    key: _exportKey,
                    source: _PlexAdvanceDataTableExportSource(rows),
                    columns: widget.columns
                        .map(
                          (PlexDataTableHeaderCell e) => GridColumn(
                            columnName: e.columnName,
                            columnWidthMode: e._getWidthMode(),
                            label: Text(e.columnName),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PlexAdvanceDataTableExportSource extends DataGridSource {
  _PlexAdvanceDataTableExportSource(List<List<PlexDataTableValueCell>> data) {
    _rows = data
        .map((List<PlexDataTableValueCell> e) => DataGridRow(cells: e))
        .toList();
  }

  late final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((DataGridCell dataGridCell) {
        final PlexDataTableValueCell cell =
            dataGridCell as PlexDataTableValueCell;
        if (cell.isWidget) {
          return cell.value as Widget;
        }
        return Text(dataGridCell.value.toString());
      }).toList(),
    );
  }
}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    style = style.copyWith(fontWeight: FontWeight.bold);
    return super.computeHeaderCellWidth(column, style);
  }

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}
