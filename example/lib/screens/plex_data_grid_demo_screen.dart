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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PlexDim.medium),
      child: PlexDataGrid<_DemoEmployee>(
        title: 'Employees',
        subtitle:
            'Sort, search, column filters, grouping, CSV / Excel / PDF',
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
      ),
    );
  }
}
