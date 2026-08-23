import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_adv_data_table.dart';
import 'package:plex/plex_widgets/plex_app_bar.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_data_table.dart';
import 'package:plex/plex_widgets/plex_data_table_paginated.dart';
import 'package:plex_app/screens/example_chrome.dart';

List<List<PlexDataCell>> exampleTableRows() => [
      [
        PlexDataCell.text(285),
        PlexDataCell.text("Second"),
        PlexDataCell.text("Person"),
        PlexDataCell.text("EMP95313RT"),
        PlexDataCell.text("Software Engineer"),
        PlexDataCell.text("Scale"),
        PlexDataCell.text("Second Company Pvt. Ltd"),
      ],
      [
        PlexDataCell.text(29),
        PlexDataCell.text("First"),
        PlexDataCell.text("Person"),
        PlexDataCell.text("EMP953312RT"),
        PlexDataCell.text("Software Engineer"),
        PlexDataCell.text("Grade"),
        PlexDataCell.text("First Company Pvt. Ltd"),
      ],
      [
        PlexDataCell.text(280),
        PlexDataCell.text("Second"),
        PlexDataCell.text("Person"),
        PlexDataCell.text("EMP95313RT"),
        PlexDataCell.text("Software Engineer"),
        PlexDataCell.text("Scale"),
        PlexDataCell.text("Second Company Pvt. Ltd"),
      ],
    ];

List<PlexDataCell> exampleTableColumns() => [
      PlexDataCell.text("Id"),
      PlexDataCell.text("First Name"),
      PlexDataCell.text("Last Name"),
      PlexDataCell.text("Emp Code"),
      PlexDataCell.text("Designation"),
      PlexDataCell.text("Grade"),
      PlexDataCell.text("Company"),
    ];

List<List<PlexDataTableValueCell>> exampleAdvanceTableRows() {
  var data = List<List<PlexDataTableValueCell>>.empty(growable: true);
  for (var a = 0; a < 100; a++) {
    data.add(
      [
        PlexDataTableValueCell.text("Id", Random().nextInt(9999)),
        PlexDataTableValueCell.text("First", "First $a"),
        PlexDataTableValueCell.text("Last", "Last $a"),
        PlexDataTableValueCell.text("EmpCode", "EMP$a"),
        PlexDataTableValueCell.text(
            "Designation", "Engineer ${Random().nextInt(10) + 1}"),
        PlexDataTableValueCell.text(
            "Grade", "Scale ${Random().nextInt(5) + 1}"),
        PlexDataTableValueCell.text("Company", "Company $a"),
        PlexDataTableValueCell.text("1", "1 - $a"),
        PlexDataTableValueCell.text("2", "2 - $a"),
        PlexDataTableValueCell.text("3", "3 - $a"),
        PlexDataTableValueCell.text("4", "4 - $a"),
        PlexDataTableValueCell.text("5", "5 - $a"),
        PlexDataTableValueCell.text("6", "6 - $a"),
        PlexDataTableValueCell.text("7", "7 - $a"),
        PlexDataTableValueCell.text("8", "8 - $a"),
        PlexDataTableValueCell.text("9", "9 - $a"),
        PlexDataTableValueCell.text("10", "10 - $a"),
      ],
    );
  }
  return data;
}

class DataTableDemoScreen extends StatelessWidget {
  const DataTableDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;
    return Padding(
      padding: const EdgeInsets.all(PlexDim.medium),
      child: ExampleCard(
        title: "PlexDataTable",
        subtitle: "Search, print, and copy helpers",
        actions: const PlexBadge(label: "Legacy table"),
        flush: true,
        child: PlexDataTable(
          key: UniqueKey(),
          enableSearch: true,
          enablePrint: true,
          enableCopy: false,
          onRefresh: exampleTableRows,
          headerTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
          headerBackground: colors.surfaceSunken,
          alternateColor: colors.surfaceHover,
          border: TableBorder.all(color: colors.borderSubtle),
          columns: exampleTableColumns(),
          rows: exampleTableRows(),
        ),
      ),
    );
  }
}

class PaginatedTableDemoScreen extends StatelessWidget {
  const PaginatedTableDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(PlexDim.medium),
      child: ExampleCard(
        title: "PlexDataTableWithPages",
        subtitle: "Paginated Material data table",
        flush: true,
        child: SizedBox(
          height: 520,
          child: _PaginatedTableBody(),
        ),
      ),
    );
  }
}

class _PaginatedTableBody extends StatelessWidget {
  const _PaginatedTableBody();

  @override
  Widget build(BuildContext context) {
    return PlexDataTableWithPages(
      columns: [
        PlexDataCell.text("Id", numberField: true),
        PlexDataCell.text("First Name"),
        PlexDataCell.text("Last Name"),
        PlexDataCell.text("Emp Code"),
        PlexDataCell.text("Designation"),
        PlexDataCell.text("Grade"),
        PlexDataCell.text("Company"),
      ],
      rows: exampleTableRows(),
    );
  }
}

class AdvanceDataTableDemoScreen extends StatelessWidget {
  const AdvanceDataTableDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gridController =
        PlexWidgetController(data: exampleAdvanceTableRows());
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(PlexDim.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ExampleCard(
            title: "PlexAdvanceDataTable",
            subtitle: "Syncfusion-backed grid — not replaced by PlexDataGrid",
            actions: PlexBadge(
              label: "Syncfusion",
              tone: PlexBadgeTone.warning,
            ),
            child: Text(
              "Keep this widget for existing call sites. New tables can use PlexDataGrid.",
            ),
          ),
          const SizedBox(height: PlexDim.medium),
          Expanded(
            child: PlexAdvanceDataTable(
              title: "Advance Data Table",
              widthMode: WidthMode.none,
              columns: [
                PlexDataTableHeaderCell.text("Id", showOrderByControl: false),
                PlexDataTableHeaderCell.text("First", showFilterControl: false),
                PlexDataTableHeaderCell.text("Last"),
                PlexDataTableHeaderCell.text("EmpCode"),
                PlexDataTableHeaderCell.text("Designation"),
                PlexDataTableHeaderCell.text("Grade"),
                PlexDataTableHeaderCell.text("Company",
                    showOrderByControl: false, showFilterControl: false),
                PlexDataTableHeaderCell.text("1"),
                PlexDataTableHeaderCell.text("2"),
                PlexDataTableHeaderCell.text("3"),
                PlexDataTableHeaderCell.text("4"),
                PlexDataTableHeaderCell.text("5"),
                PlexDataTableHeaderCell.text("6"),
                PlexDataTableHeaderCell.text("7"),
                PlexDataTableHeaderCell.text("8"),
                PlexDataTableHeaderCell.text("9"),
                PlexDataTableHeaderCell.text("10"),
              ],
              controller: gridController,
              cellEditingWidget: (row, column) {
                if ([0, 1, 2].contains(column)) {
                  controller.text = (gridController.data
                          as List<List<PlexDataTableValueCell>>)[row][column]
                      .value
                      .toString();
                  return TextField(controller: controller);
                }
                return null;
              },
              cellEditingSubmit: (row, column) async {
                var cell = (gridController.data
                    as List<List<PlexDataTableValueCell>>)[row][column];
                (gridController.data as List<List<PlexDataTableValueCell>>)[row]
                    [column] = cell.clone(newValue: controller.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExternalTableScreen extends StatelessWidget {
  const ExternalTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;
    return Scaffold(
      appBar: const PlexAppBar(
        automaticallyImplyLeading: true,
        title: Text("External Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(PlexDim.medium),
        child: ExampleCard(
          title: "Stacked route",
          subtitle: "PlexRoute.external pushes on the navigator stack",
          flush: true,
          child: PlexDataTable(
            key: UniqueKey(),
            enableSearch: true,
            enablePrint: true,
            enableCopy: false,
            onRefresh: exampleTableRows,
            headerTextStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
            headerBackground: colors.surfaceSunken,
            alternateColor: colors.surfaceHover,
            border: TableBorder.all(color: colors.borderSubtle),
            columns: exampleTableColumns(),
            rows: exampleTableRows(),
          ),
        ),
      ),
    );
  }
}
