import 'package:flutter/widgets.dart';
import 'package:plex/plex_widgets/plex_adv_data_table.dart';
import 'package:plex/plex_widgets/plex_data_grid.dart';

/// Maps [PlexAdvanceDataTable] header/cell models onto [PlexDataGrid] columns.
class PlexAdvanceDataTableAdapter {
  const PlexAdvanceDataTableAdapter._();

  /// Maps Advance [WidthMode] onto [PlexDataGridColumnSizeMode].
  static PlexDataGridColumnSizeMode sizeModeFor(WidthMode mode) {
    switch (mode) {
      case WidthMode.none:
        return PlexDataGridColumnSizeMode.fixed;
      case WidthMode.auto:
        return PlexDataGridColumnSizeMode.auto;
      case WidthMode.fill:
        return PlexDataGridColumnSizeMode.fill;
      case WidthMode.lastColumnFill:
        return PlexDataGridColumnSizeMode.lastFill;
      case WidthMode.fitByColumnName:
        return PlexDataGridColumnSizeMode.header;
      case WidthMode.fitByCellValue:
        return PlexDataGridColumnSizeMode.cells;
    }
  }

  static List<PlexDataGridColumn<List<PlexDataTableValueCell>>> columns(
    List<PlexDataTableHeaderCell> headers, {
    WidthMode? tableWidthMode,
  }) {
    return <PlexDataGridColumn<List<PlexDataTableValueCell>>>[
      for (int i = 0; i < headers.length; i++)
        PlexDataGridColumn<List<PlexDataTableValueCell>>(
          id: headers[i].columnName,
          title: headers[i].columnName,
          numeric: headers[i].isNumber,
          sortable: headers[i].showOrderByControl,
          searchable: headers[i].showFilterControl,
          filterable: headers[i].showFilterControl,
          groupable: true,
          sizeMode: _columnSizeMode(
            headers[i],
            tableWidthMode: tableWidthMode,
            isLast: i == headers.length - 1,
          ),
          value: (List<PlexDataTableValueCell> row) =>
              valueFor(row, headers[i].columnName),
          cell: (BuildContext context, List<PlexDataTableValueCell> row) {
            return _buildCell(row, headers[i].columnName);
          },
        ),
    ];
  }

  /// Per-header [WidthMode] wins, except table-level `fill` / `lastColumnFill`
  /// still apply when headers keep the Advance default (`auto`).
  static PlexDataGridColumnSizeMode _columnSizeMode(
    PlexDataTableHeaderCell header, {
    WidthMode? tableWidthMode,
    required bool isLast,
  }) {
    if (tableWidthMode == WidthMode.lastColumnFill && isLast) {
      return PlexDataGridColumnSizeMode.lastFill;
    }
    if (tableWidthMode == WidthMode.fill &&
        header.widthMode == WidthMode.auto) {
      return PlexDataGridColumnSizeMode.fill;
    }
    return sizeModeFor(header.widthMode);
  }

  static PlexDataTableValueCell? cellFor(
    List<PlexDataTableValueCell> row,
    String columnName,
  ) {
    for (final PlexDataTableValueCell cell in row) {
      if (cell.columnName == columnName) return cell;
    }
    return null;
  }

  static Object? valueFor(
    List<PlexDataTableValueCell> row,
    String columnName,
  ) {
    final PlexDataTableValueCell? cell = cellFor(row, columnName);
    if (cell == null) return null;
    if (cell.isWidget) return cell.cellValue;
    return cell.value;
  }

  static List<dynamic> excelHeaders(List<PlexDataTableHeaderCell> headers) {
    return headers.map((PlexDataTableHeaderCell h) => h.columnName).toList();
  }

  static List<List<dynamic>> excelRows(
    List<PlexDataTableHeaderCell> headers,
    List<List<PlexDataTableValueCell>> rows,
  ) {
    return rows.map((List<PlexDataTableValueCell> row) {
      return headers.map((PlexDataTableHeaderCell header) {
        final PlexDataTableValueCell? cell = cellFor(row, header.columnName);
        if (cell == null) return '';
        if (cell.isWidget) return cell.cellValue ?? '';
        return cell.value;
      }).toList();
    }).toList();
  }

  static Widget? _buildCell(
    List<PlexDataTableValueCell> row,
    String columnName,
  ) {
    final PlexDataTableValueCell? cell = cellFor(row, columnName);
    if (cell == null || !cell.isWidget) return null;
    final Object? value = cell.value;
    if (value is PlexComparableWidget) return value.widget;
    if (value is Widget) return value;
    return null;
  }
}
