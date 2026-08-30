import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_data_grid.dart';

class _DemoEmployee {
  const _DemoEmployee({
    required this.id,
    required this.first,
    required this.last,
    required this.role,
    required this.grade,
    required this.status,
    required this.delta,
  });

  final int id;
  final String first;
  final String last;
  final String role;
  final int grade;
  final String status;
  final int delta;
}

class _SizeModeRow {
  const _SizeModeRow({
    required this.id,
    required this.fixed,
    required this.auto,
    required this.header,
    required this.cells,
    required this.fill,
    required this.wrap,
    required this.lastFill,
  });

  final String id;
  final String fixed;
  final String auto;
  final String header;
  final String cells;
  final String fill;
  final String wrap;
  final String lastFill;
}

/// PlexDataGrid demo. This is the table engine; PlexAdvanceDataTable is a deprecated wrapper.
class PlexDataGridDemoScreen extends StatelessWidget {
  const PlexDataGridDemoScreen({super.key});

  static const List<String> _roles = <String>[
    'Engineer',
    'Manager',
    'Designer'
  ];

  static const List<String> _statuses = <String>[
    'Active',
    'On leave',
    'Contract',
  ];

  static final List<_DemoEmployee> _employees = List<_DemoEmployee>.generate(
    40,
    (int i) => _DemoEmployee(
      id: i + 1,
      first: 'First ${i + 1}',
      last: 'Last ${i + 1}',
      role: _roles[i % _roles.length],
      grade: 10 + (i % 8),
      status: _statuses[i % _statuses.length],
      delta: (i % 7) - 3,
    ),
  );

  static const List<_SizeModeRow> _sizeModeRows = <_SizeModeRow>[
    _SizeModeRow(
      id: '1',
      fixed: 'A',
      auto: 'Auto sizes to this long current-page cell string',
      header: 'OK',
      cells: 'Cells mode follows this long cell, not the short title',
      fill: 'Share leftover',
      wrap: 'This fixed-width cell wraps onto extra lines so the row grows',
      lastFill: 'Takes leftover',
    ),
    _SizeModeRow(
      id: '2',
      fixed: 'B',
      auto: 'Shorter auto cell',
      header: 'Yes',
      cells: 'Another long cells-mode value on the current page',
      fill: 'Flex 1',
      wrap: 'More wrapping text on the second row of this demo',
      lastFill: 'Last fill',
    ),
    _SizeModeRow(
      id: '3',
      fixed: 'C',
      auto: 'Medium auto cell text',
      header: 'No',
      cells: 'Short cell',
      fill: 'Fill',
      wrap: 'Third wrap sample with enough words to break lines',
      lastFill: 'End',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PlexDim.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSizeModeGrid(),
          const SizedBox(height: PlexDim.medium),
          Expanded(child: _buildEmployeesGrid()),
        ],
      ),
    );
  }

  Widget _buildSizeModeGrid() {
    return PlexDataGrid<_SizeModeRow>(
      title: 'Column & row size modes',
      subtitle:
          'fixed / auto (header + current page) / header / cells / fill / lastFill. Wrap column uses rowSizeMode.auto at a fixed width.',
      height: 280,
      pageSize: 3,
      showSearch: false,
      showDensityToggle: false,
      showFooter: false,
      showColumnFilters: false,
      enableGrouping: false,
      rowId: (_SizeModeRow row) => row.id,
      columns: [
        PlexDataGridColumn<_SizeModeRow>(
          id: 'fixed',
          title: 'Fixed 72',
          width: 72,
          sizeMode: PlexDataGridColumnSizeMode.fixed,
          sortable: false,
          filterable: false,
          groupable: false,
          value: (_SizeModeRow row) => row.fixed,
        ),
        PlexDataGridColumn<_SizeModeRow>(
          id: 'auto',
          title: 'Auto',
          sizeMode: PlexDataGridColumnSizeMode.auto,
          sortable: false,
          filterable: false,
          groupable: false,
          value: (_SizeModeRow row) => row.auto,
        ),
        PlexDataGridColumn<_SizeModeRow>(
          id: 'header',
          title: 'Very long header title (header mode)',
          sizeMode: PlexDataGridColumnSizeMode.header,
          sortable: false,
          filterable: false,
          groupable: false,
          value: (_SizeModeRow row) => row.header,
        ),
        PlexDataGridColumn<_SizeModeRow>(
          id: 'cells',
          title: 'Cells',
          sizeMode: PlexDataGridColumnSizeMode.cells,
          sortable: false,
          filterable: false,
          groupable: false,
          value: (_SizeModeRow row) => row.cells,
        ),
        PlexDataGridColumn<_SizeModeRow>(
          id: 'fill',
          title: 'Fill',
          sizeMode: PlexDataGridColumnSizeMode.fill,
          flex: 1,
          sortable: false,
          filterable: false,
          groupable: false,
          value: (_SizeModeRow row) => row.fill,
        ),
        PlexDataGridColumn<_SizeModeRow>(
          id: 'wrap',
          title: 'Wrap',
          width: 96,
          sizeMode: PlexDataGridColumnSizeMode.fixed,
          rowSizeMode: PlexDataGridRowSizeMode.auto,
          sortable: false,
          filterable: false,
          groupable: false,
          value: (_SizeModeRow row) => row.wrap,
        ),
        PlexDataGridColumn<_SizeModeRow>(
          id: 'lastFill',
          title: 'Last fill',
          sizeMode: PlexDataGridColumnSizeMode.lastFill,
          sortable: false,
          filterable: false,
          groupable: false,
          value: (_SizeModeRow row) => row.lastFill,
        ),
      ],
      rows: _sizeModeRows,
    );
  }

  Widget _buildEmployeesGrid() {
    return PlexDataGrid<_DemoEmployee>(
      title: 'Employees',
      subtitle:
          'Freeze first column and first data row, edit First, filters: contains/equals/startsWith/gt/lt',
      frozenColumnCount: 1,
      frozenRowCount: 1,
      onCellEdited: (_DemoEmployee row, String columnId, String value) {},
      selectionMode: PlexDataGridSelectionMode.multiple,
      pageSize: 10,
      rowId: (_DemoEmployee row) => row.id,
      showColumnFilters: true,
      enableGrouping: true,
      groupByColumnIds: const <String>['role', 'status'],
      // group.rows is all descendant leaf rows. Return null for default count/sum.
      groupSummary: (PlexDataGridGroup<_DemoEmployee> group) {
        return <PlexDataGridSummaryCell>[
          PlexDataGridSummaryCell(
            columnId: 'first',
            text: '${group.rows.length} items',
          ),
        ];
      },
      enableCsvExport: true,
      enableExcelExport: true,
      enablePdfExport: true,
      rowStyle: (_DemoEmployee row) {
        if (row.status == 'On leave') {
          return const PlexDataGridCellStyle(color: Color(0xFFB45309));
        }
        if (row.status == 'Contract') {
          return const PlexDataGridCellStyle(color: Color(0xFF5B21B6));
        }
        return null;
      },
      columns: [
        PlexDataGridColumn<_DemoEmployee>(
          id: 'id',
          title: 'Id',
          numeric: true,
          width: 80,
          value: (_DemoEmployee row) => row.id,
        ),
        PlexDataGridColumn<_DemoEmployee>(
          id: 'first',
          title: 'First',
          editable: true,
          value: (_DemoEmployee row) => row.first,
        ),
        PlexDataGridColumn<_DemoEmployee>(
          id: 'last',
          title: 'Last',
          value: (_DemoEmployee row) => row.last,
        ),
        PlexDataGridColumn<_DemoEmployee>(
          id: 'role',
          title: 'Role',
          value: (_DemoEmployee row) => row.role,
        ),
        PlexDataGridColumn<_DemoEmployee>(
          id: 'grade',
          title: 'Grade',
          numeric: true,
          width: 100,
          value: (_DemoEmployee row) => row.grade,
          cellStyle: (_DemoEmployee row) => row.grade >= 16
              ? const PlexDataGridCellStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF047857),
                )
              : null,
        ),
        PlexDataGridColumn<_DemoEmployee>(
          id: 'delta',
          title: 'Delta',
          numeric: true,
          width: 90,
          value: (_DemoEmployee row) => row.delta,
          cellStyle: (_DemoEmployee row) => row.delta < 0
              ? const PlexDataGridCellStyle(color: Color(0xFFB91C1C))
              : null,
        ),
        PlexDataGridColumn<_DemoEmployee>(
          id: 'status',
          title: 'Status',
          width: 120,
          value: (_DemoEmployee row) => row.status,
          cell: (BuildContext context, _DemoEmployee row) {
            PlexBadgeTone tone = PlexBadgeTone.info;
            if (row.status == 'Active') {
              tone = PlexBadgeTone.success;
            } else if (row.status == 'On leave') {
              tone = PlexBadgeTone.warning;
            }
            return PlexBadge(label: row.status, tone: tone, dot: true);
          },
        ),
        PlexDataGridColumn<_DemoEmployee>(
          id: 'action',
          title: 'Action',
          width: 72,
          sortable: false,
          filterable: false,
          groupable: false,
          value: (_DemoEmployee row) => row.id,
          cell: (BuildContext context, _DemoEmployee row) {
            return IconButton(
              tooltip: 'Edit',
              iconSize: 18,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  SnackBar(content: Text('Edit employee ${row.id}')),
                );
              },
            );
          },
        ),
      ],
      rows: _employees,
    );
  }
}
