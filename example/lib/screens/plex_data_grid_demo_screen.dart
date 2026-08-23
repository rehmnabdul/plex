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
  });

  final int id;
  final String first;
  final String last;
  final String role;
  final int grade;
  final String status;
}

/// Phase 5a/5b demo. Prefer this over the deprecated PlexAdvanceDataTable wrapper.
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
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PlexDim.medium),
      child: PlexDataGrid<_DemoEmployee>(
        title: 'Employees',
        subtitle: 'PlexDataGrid — client-side sort, search, selection, pages',
        selectionMode: PlexDataGridSelectionMode.multiple,
        pageSize: 10,
        rowId: (_DemoEmployee row) => row.id,
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
        ],
        rows: _employees,
      ),
    );
  }
}
