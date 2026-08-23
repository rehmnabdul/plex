import 'package:flutter/widgets.dart';
import 'package:plex/plex_widgets/plex_adv_data_table.dart';
import 'package:plex/plex_widgets/plex_data_grid.dart';

/// Maps [PlexAdvanceDataTable] header/cell models onto [PlexDataGrid] columns.
class PlexAdvanceDataTableAdapter {
  const PlexAdvanceDataTableAdapter._();

  static List<PlexDataGridColumn<List<PlexDataTableValueCell>>> columns(
    List<PlexDataTableHeaderCell> headers,
  ) {
    return headers
        .map(
          (PlexDataTableHeaderCell header) =>
              PlexDataGridColumn<List<PlexDataTableValueCell>>(
            id: header.columnName,
            title: header.columnName,
            numeric: header.isNumber,
            sortable: header.showOrderByControl,
            searchable: header.showFilterControl,
            value: (List<PlexDataTableValueCell> row) =>
                valueFor(row, header.columnName),
            cell: (BuildContext context, List<PlexDataTableValueCell> row) {
              return _buildCell(row, header.columnName);
            },
          ),
        )
        .toList();
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

  static Widget _buildCell(
    List<PlexDataTableValueCell> row,
    String columnName,
  ) {
    final PlexDataTableValueCell? cell = cellFor(row, columnName);
    if (cell == null) return const SizedBox.shrink();
    if (cell.isWidget) {
      final Object? value = cell.value;
      if (value is Widget) return value;
      return Text(cell.cellValue ?? '');
    }
    return Text(cell.value?.toString() ?? '');
  }
}
