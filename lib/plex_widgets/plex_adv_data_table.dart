// ignore_for_file: deprecated_member_use_from_same_package, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_utils/plex_printer.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_advance_data_table_adapter.dart';
import 'package:plex/plex_widgets/plex_data_grid.dart';

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
}

/// Cell model for [PlexAdvanceDataTable].
///
/// Public fields match the historic constructor shape (`columnName`, `value`,
/// `numberField`, custom widget). This type no longer extends Syncfusion
/// `DataGridCell`.
class PlexDataTableValueCell {
  final String columnName;
  final dynamic value;
  late final bool isNumber;
  late final bool isWidget;
  late final String? cellValue;

  ///[value] is required as it is text only cell
  PlexDataTableValueCell.text(this.columnName, this.value,
      {bool numberField = false})
      : isWidget = false,
        cellValue = null {
    isNumber = numberField || value is int || value is double;
  }

  ///For custom design and handling of cell use this constructor.
  ///[value] is optional
  ///[cell] is required for custom cell
  PlexDataTableValueCell.custom(
    this.columnName,
    String textValue,
    Widget widget, {
    bool numberField = false,
  })  : value = PlexComparableWidget(widget, textValue),
        cellValue = textValue,
        isWidget = true {
    isNumber = numberField || value is int || value is double;
  }

  PlexDataTableValueCell clone({dynamic newValue}) {
    if (!isWidget) {
      return PlexDataTableValueCell.text(columnName, newValue ?? value,
          numberField: isNumber);
    } else {
      return PlexDataTableValueCell.custom(
          columnName, (newValue ?? cellValue).toString(), value as Widget,
          numberField: isNumber);
    }
  }
}

/// Deprecated compatibility wrapper around [PlexDataGrid].
///
/// Existing constructor parameters and [PlexDataTableHeaderCell] /
/// [PlexDataTableValueCell] models still compile. The visible grid is
/// [PlexDataGrid]. Excel export uses [PlexPrinter.printExcel]. PDF export uses
/// [PlexPrinter.printPdf] (a Plex-owned table PDF, not Syncfusion).
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

  /// Unused. Column grouping is not mapped onto [PlexDataGrid].
  ///
  /// The previous Syncfusion `DataGridRow` parameter type is gone with that
  /// dependency. Plex call sites pass [PlexDataTableValueCell] rows.
  final String Function(String columnName, List<PlexDataTableValueCell> row,
      List<List<PlexDataTableValueCell>> rows)? customGroupingSummary;

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

  Future<void> _exportPdf(
    BuildContext context,
    List<List<PlexDataTableValueCell>> rows,
  ) async {
    try {
      final String? path = await PlexPrinter.printPdf(
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
            onPressed: () => _exportPdf(context, rows),
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
        return PlexDataGrid<List<PlexDataTableValueCell>>(
          key: const Key('plex-advance-data-table-grid'),
          title: widget.title,
          columns: PlexAdvanceDataTableAdapter.columns(widget.columns),
          rows: rows,
          pageSize: _resolvedPageSize(rows),
          showFooter: _paginate,
          showSearch: widget.columns.any((c) => c.showFilterControl),
          showDensityToggle: false,
          selectionMode: widget.showCheckboxColumn
              ? PlexDataGridSelectionMode.multiple
              : PlexDataGridSelectionMode.none,
          actions: _actions(context, rows),
        );
      },
    );
  }
}

/// Unused. Column sizing is handled by [PlexDataGrid].
///
/// Kept so historic `CustomColumnSizer()` call sites still compile after
/// Syncfusion `ColumnSizer` was removed.
@Deprecated('Unused. Column sizing is handled by PlexDataGrid.')
class CustomColumnSizer {
  CustomColumnSizer();
}
