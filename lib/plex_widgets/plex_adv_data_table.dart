// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_assets.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_material.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_utils/plex_printer.dart';
import 'package:plex/plex_utils/plex_utils.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_selection_list.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;

enum WidthMode {
  none,
  fitByColumnName,
  fitByCellValue,
  lastColumnFill,
  fill,
  auto,
}

class PlexDataTableHeaderCell {
  final String columnName;
  final bool isNumber;
  final WidthMode widthMode;
  late final Widget? cell;

  ///[columnName] is required as it is text only cell
  PlexDataTableHeaderCell.text(this.columnName, {this.isNumber = false, this.widthMode = WidthMode.auto}) {
    cell = null;
  }

  ///For custom design and handling of cell use this constructor.
  ///[columnName] is optional
  ///[cell] is required for custom cell
  PlexDataTableHeaderCell.custom(this.columnName, this.cell, {this.isNumber = false, this.widthMode = WidthMode.auto});

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

  PlexDataTableValueCell clone({dynamic newValue}) {
    if (cell == null) {
      return PlexDataTableValueCell.text(columnName, newValue ?? value, numberField: isNumber);
    } else {
      return PlexDataTableValueCell.custom(columnName, newValue ?? value, cell, numberField: isNumber);
    }
  }
}

class PlexAdvanceDataTable extends StatefulWidget {
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
    this.freezeColumns = 0,
    this.freezeRows = 0,
    this.alternateColor,
    this.enableCopy = false,
    this.enableColumnGrouping = true,
    this.initialColumnGroup,
    this.enableExcelExport = true,
    this.enablePdfExport = true,
    this.autoExpandGroups = true,
    this.groupSummary,
    this.groupSummaryFormat,
    this.cellEditingWidget,
    this.cellEditingSubmit,
  });

  ///Title to show for the data set
  final String title;
  final int freezeColumns;
  final int freezeRows;

  ///Styles
  final Color? headerBackground;
  final TextStyle? headerTextStyle;
  final Color? alternateColor;
  final WidthMode? widthMode;

  ///On Refresh Button Click
  final Function()? onRefresh;

  ///Enable Disable Column Grouping
  final bool enableColumnGrouping;
  final List<String>? initialColumnGroup;
  final bool autoExpandGroups;
  final String? groupSummaryFormat;
  final String Function(String summary)? groupSummary;

  ///Editing a Cell
  final Widget? Function(int row, int column)? cellEditingWidget;
  final Future Function(int row, int column)? cellEditingSubmit;

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
    initializeGrouping();
  }

  void initializeDataSource() {
    source = _PlexAdvanceDataTableDataSource(
      getRows() ?? List.empty(),
      pageSize: widget.pageSize,
      alternateColor: widget.alternateColor,
      dataGridController: _dataGridController,
      groupSummary: widget.groupSummary,
      cellEditingWidget: widget.cellEditingWidget,
      cellEditingSubmit: widget.cellEditingSubmit,
    );
  }

  void initializeGrouping() {
    if (widget.initialColumnGroup == null) return;
    var oldSelection = source.groupedColumns;
    for (var item in widget.initialColumnGroup!) {
      if (oldSelection.firstWhereOrNull((column) => column.name == item) == null) {
        source.addColumnGroup(ColumnGroup(name: item, sortGroupRows: true));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlexWidget(
      controller: widget.controller,
      createWidget: (context, data) {
        initializeDataSource();
        initializeGrouping();
        return Column(
          children: [
            spaceSmall(),
            Row(
              children: [
                Expanded(child: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                if (isLargeScreen(context)) ...{
                  if (widget.enableColumnGrouping) ...{
                    FilledButton.tonalIcon(
                      onPressed: () {
                        showMultiSelection<ColumnGroup>(
                          context,
                          itemText: (item) {
                            return item.name;
                          },
                          onSelect: (items) {
                            var oldSelection = source.groupedColumns;
                            for (var column in oldSelection) {
                              if (items.firstWhereOrNull((item) => item.name == column.name) == null) {
                                source.removeColumnGroup(column);
                              }
                            }

                            oldSelection = source.groupedColumns;
                            for (var item in items) {
                              if (oldSelection.firstWhereOrNull((column) => column.name == item.name) == null) {
                                source.addColumnGroup(item);
                              }
                            }

                            source.notifyListeners();
                          },
                          initialSelection: source.groupedColumns,
                          items: widget.columns.map((e) => ColumnGroup(name: e.columnName, sortGroupRows: true)).toList(),
                        );
                      },
                      style: ButtonStyle(backgroundColor: Colors.blue.shade100.getMaterialState(), elevation: Dim.smallest.getMaterialState()),
                      icon: Image.asset(groupData, height: 25, width: 25, color: Colors.blue),
                      label: const Text('Group By', style: TextStyle(color: Colors.blue)),
                    ),
                  },
                  if (widget.enableExcelExport) ...{
                    space(8),
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
                      style: ButtonStyle(backgroundColor: Colors.green.shade100.getMaterialState(), elevation: Dim.smallest.getMaterialState()),
                      child: Image.asset(excel, width: 20, height: 20, color: Colors.green),
                    ),
                  },
                  if (widget.enablePdfExport) ...{
                    space(8),
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
                      style: ButtonStyle(backgroundColor: Colors.red.shade100.getMaterialState(), elevation: Dim.smallest.getMaterialState()),
                      child: Image.asset(pdf, width: 20, height: 20, color: Colors.redAccent),
                    ),
                  },
                  if (widget.onRefresh != null) ...{
                    space(8),
                    FilledButton.tonal(
                      onPressed: () async {
                        widget.onRefresh?.call();
                      },
                      child: const Icon(Icons.refresh),
                    ),
                  },
                } else if (isMediumScreen(context)) ...{
                  if (widget.enableColumnGrouping) ...{
                    FilledButton.tonalIcon(
                      onPressed: () {
                        showMultiSelection<ColumnGroup>(
                          context,
                          itemText: (item) {
                            return item.name;
                          },
                          onSelect: (items) {
                            var oldSelection = source.groupedColumns;
                            for (var column in oldSelection) {
                              if (items.firstWhereOrNull((item) => item.name == column.name) == null) {
                                source.removeColumnGroup(column);
                              }
                            }

                            oldSelection = source.groupedColumns;
                            for (var item in items) {
                              if (oldSelection.firstWhereOrNull((column) => column.name == item.name) == null) {
                                source.addColumnGroup(item);
                              }
                            }
                          },
                          initialSelection: source.groupedColumns,
                          items: widget.columns.map((e) => ColumnGroup(name: e.columnName, sortGroupRows: true)).toList(),
                        );
                      },
                      style: ButtonStyle(backgroundColor: Colors.blue.shade100.getMaterialState(), elevation: Dim.smallest.getMaterialState()),
                      icon: Image.asset(groupData, height: 25, width: 25, color: Colors.blue),
                      label: const Text('Group By', style: TextStyle(color: Colors.blue)),
                    ),
                  },
                  MenuAnchor(
                    menuChildren: [
                      if (widget.enableExcelExport) ...{
                        MenuItemButton(
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
                          style: ButtonStyle(backgroundColor: Colors.green.shade100.getMaterialState(), elevation: Dim.smallest.getMaterialState()),
                          leadingIcon: Image.asset(excel, width: 20, height: 20, color: Colors.green),
                          child: const Text('Excel', style: TextStyle(color: Colors.green)),
                        ),
                      },
                      if (widget.enablePdfExport) ...{
                        MenuItemButton(
                          onPressed: () async {
                            var document = key.currentState!.exportToPdfDocument(autoColumnWidth: true);
                            final List<int> bytes = document.saveSync();
                            var path = await PlexPrinter.savePdfFile(widget.title, bytes);
                            if (path == null) {
                              context.showSnackBar("Unable to save file, Please try again...");
                            }
                            context.showSnackBar("Report saved at \"$path\"");
                          },
                          style: ButtonStyle(backgroundColor: Colors.red.shade100.getMaterialState(), elevation: Dim.smallest.getMaterialState()),
                          leadingIcon: Image.asset(pdf, width: 20, height: 20, color: Colors.redAccent),
                          child: const Text('Pdf', style: TextStyle(color: Colors.redAccent)),
                        ),
                      },
                      if (widget.onRefresh != null) ...{
                        MenuItemButton(
                          onPressed: () async {
                            widget.onRefresh?.call();
                          },
                          leadingIcon: const Icon(Icons.refresh),
                          child: const Text('Refresh'),
                        ),
                      },
                    ],
                    builder: (context, controller, child) {
                      return IconButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        icon: const Icon(Icons.more_vert),
                      );
                    },
                  ),
                } else ...{
                  MenuAnchor(
                    menuChildren: [
                      if (widget.enableColumnGrouping) ...{
                        MenuItemButton(
                          style: ButtonStyle(backgroundColor: Colors.blue.shade100.getMaterialState(), elevation: Dim.smallest.getMaterialState()),
                          leadingIcon: Image.asset(groupData, height: 25, width: 25, color: Colors.blue),
                          onPressed: () {
                            showMultiSelection<ColumnGroup>(
                              context,
                              itemText: (item) {
                                return item.name;
                              },
                              onSelect: (items) {
                                var oldSelection = source.groupedColumns;
                                for (var column in oldSelection) {
                                  if (items.firstWhereOrNull((item) => item.name == column.name) == null) {
                                    source.removeColumnGroup(column);
                                  }
                                }

                                oldSelection = source.groupedColumns;
                                for (var item in items) {
                                  if (oldSelection.firstWhereOrNull((column) => column.name == item.name) == null) {
                                    source.addColumnGroup(item);
                                  }
                                }
                              },
                              initialSelection: source.groupedColumns,
                              items: widget.columns.map((e) => ColumnGroup(name: e.columnName, sortGroupRows: true)).toList(),
                            );
                          },
                          child: const Text('Group By', style: TextStyle(color: Colors.blue)),
                        ),
                      },
                      if (widget.enableExcelExport) ...{
                        MenuItemButton(
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
                          style: ButtonStyle(backgroundColor: Colors.green.shade100.getMaterialState(), elevation: Dim.smallest.getMaterialState()),
                          leadingIcon: Image.asset(excel, width: 20, height: 20, color: Colors.green),
                          child: const Text('Excel', style: TextStyle(color: Colors.green)),
                        ),
                      },
                      if (widget.enablePdfExport) ...{
                        MenuItemButton(
                          onPressed: () async {
                            var document = key.currentState!.exportToPdfDocument(autoColumnWidth: true);
                            final List<int> bytes = document.saveSync();
                            var path = await PlexPrinter.savePdfFile(widget.title, bytes);
                            if (path == null) {
                              context.showSnackBar("Unable to save file, Please try again...");
                            }
                            context.showSnackBar("Report saved at \"$path\"");
                          },
                          style: ButtonStyle(backgroundColor: Colors.red.shade100.getMaterialState(), elevation: Dim.smallest.getMaterialState()),
                          leadingIcon: Image.asset(pdf, width: 20, height: 20, color: Colors.redAccent),
                          child: const Text('Pdf', style: TextStyle(color: Colors.redAccent)),
                        ),
                      },
                      if (widget.onRefresh != null) ...{
                        MenuItemButton(
                          onPressed: () async {
                            widget.onRefresh?.call();
                          },
                          leadingIcon: const Icon(Icons.refresh),
                          child: const Text('Refresh'),
                        ),
                      },
                    ],
                    builder: (context, controller, child) {
                      return IconButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        icon: const Icon(Icons.more_vert),
                      );
                    },
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
                  allowExpandCollapseGroup: true,
                  frozenColumnsCount: widget.freezeColumns,
                  frozenRowsCount: widget.freezeRows,
                  allowFiltering: true,
                  allowSorting: true,
                  allowSwiping: false,
                  allowEditing: true,
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
                  autoExpandGroups: widget.autoExpandGroups,
                  groupCaptionTitleFormat: widget.groupSummaryFormat ?? '{ColumnName} : {Key} - {ItemsCount} Items',
                  // onCellTap: (details) {
                  //   if (details.rowColumnIndex.rowIndex == 0) return;
                  //   if (widget.enableCopy) {
                  //     var cell = source._dataGridRows[details.rowColumnIndex.rowIndex - 1].getCells()[details.rowColumnIndex.columnIndex];
                  //     debugPrint(cell.value?.toString());
                  //     context.copyToClipboard(cell.value?.toString() ?? "N/A");
                  //   }
                  // },
                  source: source,
                  columns: widget.columns
                      .map(
                        (e) => GridColumn(
                          columnName: e.columnName,
                          columnWidthMode: e._getWidthMode(),
                          label: Padding(
                            padding: const EdgeInsets.all(Dim.medium),
                            child: Text(
                              e.columnName,
                              style: widget.headerTextStyle,
                              overflow: TextOverflow.ellipsis,
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
  int isAlternate = -1;
  final DataGridController dataGridController;
  final String Function(String summary)? groupSummary;
  final Widget? Function(int row, int col)? cellEditingWidget;
  final Future Function(int row, int col)? cellEditingSubmit;

  final int? pageSize;

  _PlexAdvanceDataTableDataSource(
    List<List<PlexDataTableValueCell>> data, {
    required this.pageSize,
    required this.dataGridController,
    this.groupSummary,
    this.cellEditingWidget,
    this.cellEditingSubmit,
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

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    return cellEditingWidget?.call(rowColumnIndex.rowIndex, rowColumnIndex.columnIndex - 1);
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    await cellEditingSubmit?.call(rowColumnIndex.rowIndex, rowColumnIndex.columnIndex - 1);
  }

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
  Widget? buildGroupCaptionCellWidget(RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Text(groupSummary?.call(summaryValue) ?? summaryValue),
    );
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
