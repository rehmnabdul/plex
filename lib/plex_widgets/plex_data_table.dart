// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_material.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_utils/plex_printer.dart';
import 'package:plex/plex_widgets/plex_input_widget.dart';

class PlexDataCell {
  late final String? value;
  late final DataCell? cell;

  ///[value] is required as it is text only cell
  PlexDataCell.text(String this.value) {
    cell = null;
  }

  ///For custom design and handling of cell use this constructor.
  ///[value] is optional
  ///[cell] is required for custom cell
  PlexDataCell.custom(this.value, this.cell) {
    if (value == null && cell == null) throw Exception("Either Value or DataCell must not be null");
  }
}

class PlexDataTable extends StatefulWidget {
  PlexDataTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.onRefresh,
    this.onLoadMore,
    this.enableSearch = true,
    this.enablePrint = true,
    this.headerBackground,
    this.headerTextStyle,
    this.alternateColor = const Color(0xFFA8A8A8),
    this.border,
    this.columnSpacing,
  }) : super(key: key ?? GlobalKey());

  ///All Column titles
  final List<PlexDataCell> columns;

  ///Data Rows
  final List<List<PlexDataCell>> rows;

  ///Styles
  final Color? headerBackground;
  final TextStyle? headerTextStyle;
  final Color? alternateColor;
  TableBorder? border;
  double? columnSpacing;

  ///Hide and show Search Field
  final bool enableSearch;

  ///Hide and show Print Button
  final bool enablePrint;

  ///OnRefresh Button Click Callback
  Function()? onRefresh;

  ///OnLoadMore Button Click Callback
  Function(int page)? onLoadMore;

  @override
  State<PlexDataTable> createState() => _PlexDataTableState();
}

class _PlexDataTableState extends State<PlexDataTable> {
  var scrollController = ScrollController(keepScrollOffset: true);
  var searchController = TextEditingController();
  var updatedData = List<List<PlexDataCell>>.empty();
  int? sortColumnIndex;
  bool sortAscending = true;
  Set<int> searchColumnIndexes = {};

  @override
  void initState() {
    super.initState();
    updatedData = widget.rows;
  }

  sortData(List<List<PlexDataCell>> data) {
    if (sortColumnIndex == null) {
      setState(() {
        updatedData = data;
      });
      return;
    }

    data.sort((r1, r2) {
      if (sortAscending) {
        return (r1[sortColumnIndex!].value ?? "").compareTo(r2[sortColumnIndex!].value ?? "");
      } else {
        return (r2[sortColumnIndex!].value ?? "").compareTo(r1[sortColumnIndex!].value ?? "");
      }
    });
    setState(() {
      updatedData = data;
    });
  }

  filterData() {
    var data = widget.rows;
    if (searchController.text.isNotEmpty) {
      var searchIndexes = [];
      if (searchColumnIndexes.isEmpty) {
        searchIndexes = List.generate(widget.columns.length, (index) => index);
      } else {
        searchIndexes = searchColumnIndexes.toList();
      }
      data = data.where((r) {
        var isOk = false;
        for (var colIndex in searchIndexes) {
          if ((r[colIndex].value ?? "").toLowerCase().contains(searchController.text.toLowerCase())) {
            isOk = true;
            break;
          }
        }
        return isOk;
      }).toList();
    }
    sortData(data);
  }

  @override
  Widget build(BuildContext context) {
    int isAlternate = -1;
    return Column(
      children: [
        if (widget.enableSearch) ...{
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dim.medium, vertical: Dim.small),
              child: Row(
                children: [
                  SegmentedButton<int>(
                    segments: [
                      for (var i = 0; i < widget.columns.length; i++) ...{ButtonSegment(value: i, label: Text(widget.columns[i].value!), enabled: true)},
                    ],
                    selected: searchColumnIndexes,
                    emptySelectionAllowed: true,
                    multiSelectionEnabled: true,
                    onSelectionChanged: (selection) {
                      searchColumnIndexes = selection;
                      filterData();
                    },
                  ),
                ],
              ),
            ),
          ),
        },
        if (widget.enableSearch || widget.enablePrint || widget.onRefresh != null) ...{
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dim.small),
            child: Row(
              children: [
                Expanded(
                  child: widget.enableSearch
                      ? PlexInputWidget(
                          margin: EdgeInsets.zero,
                          type: PlexInputWidget.typeInput,
                          inputController: searchController,
                          title: "Search...",
                          inputHint: "Type here to search whole data...",
                          inputOnChange: (value) {
                            filterData();
                          },
                        )
                      : Container(),
                ),
                if (widget.onRefresh != null) ...{
                  spaceMedium(),
                  FilledButton.tonal(
                    onPressed: () {
                      widget.onRefresh?.call();
                    },
                    child: const Icon(Icons.refresh),
                  ),
                },
                if (widget.enablePrint) ...{
                  spaceMedium(),
                  FilledButton.tonal(
                    onPressed: () async {
                      var path = await PlexPrinter.printExcel(
                        "Data",
                        widget.columns,
                        updatedData,
                      );
                      if (path == null) {
                        context.showSnackBar(path);
                      }
                      context.showSnackBar("Report saved at \"$path\"");
                    },
                    child: const Icon(Icons.print),
                  ),
                },
              ],
            ),
          ),
        },
        SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: widget.columnSpacing,
              border: widget.border ?? TableBorder.all(color: Colors.black38),
              headingRowColor: widget.headerBackground?.getColorState(),
              headingTextStyle: widget.headerTextStyle,
              sortColumnIndex: sortColumnIndex,
              sortAscending: sortAscending,
              columns: [
                ...widget.columns.map(
                  (column) => DataColumn(
                    label: Text(column.value ?? "N/A"),
                    tooltip: column.value,
                    onSort: (columnIndex, ascending) {
                      sortColumnIndex = columnIndex;
                      sortAscending = ascending;
                      sortData(updatedData);
                    },
                  ),
                ),
              ],
              rows: [
                ...updatedData.map(
                  (row) => DataRow(
                    color: isAlternate++ % 2 == 0 ? widget.alternateColor?.getColorState() : null,
                    cells: [
                      ...row.map(
                        (data) => DataCell(
                          data.cell?.child ?? Text(data.value ?? "N/A"),
                          onTap: data.cell?.onTap ??
                              () {
                                Clipboard.setData(ClipboardData(text: data.value ?? "N/A"));
                                context.showSnackBar("Text copied on clipboard");
                              },
                          showEditIcon: data.cell?.showEditIcon ?? false,
                          onDoubleTap: data.cell?.onDoubleTap,
                          onLongPress: data.cell?.onLongPress,
                          onTapCancel: data.cell?.onTapCancel,
                          onTapDown: data.cell?.onTapDown,
                          placeholder: data.cell?.placeholder ?? false,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PlexDataTableWithPages extends StatefulWidget {
  PlexDataTableWithPages({
    super.key,
    required this.columns,
    required this.rows,
    this.perPageRows = 10,
    this.onRefresh,
    this.enableSearch = true,
    this.enablePrint = true,
    this.headerBackground,
    this.headerTextStyle,
    this.alternateColor = const Color(0xFFA8A8A8),
    this.border,
    this.columnSpacing,
  });

  ///No Of Rows Per Page
  final int perPageRows;

  ///All Column titles
  final List<PlexDataCell> columns;

  ///Data Rows
  final List<List<PlexDataCell>> rows;

  ///Styles
  final Color? headerBackground;
  final TextStyle? headerTextStyle;
  final Color? alternateColor;
  TableBorder? border;
  double? columnSpacing;

  ///Hide and show Search Field
  final bool enableSearch;

  ///Hide and show Print Button
  final bool enablePrint;

  ///OnRefresh Button Click Callback
  Function()? onRefresh;

  @override
  State<StatefulWidget> createState() => PlexDataTableWithPagesState();
}

class PlexDataTableWithPagesState extends State<PlexDataTableWithPages> {
  _PaginationDataTableSource? _dataSource;
  var scrollController = ScrollController(keepScrollOffset: true);
  var searchController = TextEditingController();
  var updatedData = List<List<PlexDataCell>>.empty();
  int? sortColumnIndex;
  bool sortAscending = true;
  Set<int> searchColumnIndexes = {};

  @override
  void initState() {
    super.initState();
    updatedData = widget.rows;
    _dataSource = _PaginationDataTableSource(context, dataList: updatedData, alternateColor: widget.alternateColor);
  }

  sortData(List<List<PlexDataCell>> data) {
    if (sortColumnIndex == null) {
      setState(() {
        updatedData = data;
        _dataSource = _PaginationDataTableSource(context, dataList: updatedData, alternateColor: widget.alternateColor);
      });
      return;
    }

    data.sort((r1, r2) {
      if (sortAscending) {
        return (r1[sortColumnIndex!].value ?? "").compareTo(r2[sortColumnIndex!].value ?? "");
      } else {
        return (r2[sortColumnIndex!].value ?? "").compareTo(r1[sortColumnIndex!].value ?? "");
      }
    });
    setState(() {
      updatedData = data;
      _dataSource = _PaginationDataTableSource(context, dataList: updatedData, alternateColor: widget.alternateColor);
    });
  }

  filterData() {
    var data = widget.rows;
    if (searchController.text.isNotEmpty) {
      var searchIndexes = [];
      if (searchColumnIndexes.isEmpty) {
        searchIndexes = List.generate(widget.columns.length, (index) => index);
      } else {
        searchIndexes = searchColumnIndexes.toList();
      }
      data = data.where((r) {
        var isOk = false;
        for (var colIndex in searchIndexes) {
          if ((r[colIndex].value ?? "").toLowerCase().contains(searchController.text.toLowerCase())) {
            isOk = true;
            break;
          }
        }
        return isOk;
      }).toList();
    }
    sortData(data);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.enableSearch) ...{
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dim.medium, vertical: Dim.small),
              child: Row(
                children: [
                  SegmentedButton<int>(
                    segments: [
                      for (var i = 0; i < widget.columns.length; i++) ...{ButtonSegment(value: i, label: Text(widget.columns[i].value!), enabled: true)},
                    ],
                    selected: searchColumnIndexes,
                    emptySelectionAllowed: true,
                    multiSelectionEnabled: true,
                    onSelectionChanged: (selection) {
                      searchColumnIndexes = selection;
                      filterData();
                    },
                  ),
                ],
              ),
            ),
          ),
        },
        if (widget.enableSearch || widget.enablePrint || widget.onRefresh != null) ...{
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dim.small),
            child: Row(
              children: [
                Expanded(
                  child: widget.enableSearch
                      ? PlexInputWidget(
                          margin: EdgeInsets.zero,
                          type: PlexInputWidget.typeInput,
                          inputController: searchController,
                          title: "Search...",
                          inputHint: "Type here to search whole data...",
                          inputOnChange: (value) {
                            filterData();
                          },
                        )
                      : Container(),
                ),
                if (widget.onRefresh != null) ...{
                  spaceMedium(),
                  FilledButton.tonal(
                    onPressed: () {
                      widget.onRefresh?.call();
                    },
                    child: const Icon(Icons.refresh),
                  ),
                },
                if (widget.enablePrint) ...{
                  spaceMedium(),
                  FilledButton.tonal(
                    onPressed: () async {
                      var path = await PlexPrinter.printExcel(
                        "Data",
                        widget.columns,
                        updatedData,
                      );
                      if (path == null) {
                        context.showSnackBar(path);
                      }
                      context.showSnackBar("Report saved at \"$path\"");
                    },
                    child: const Icon(Icons.print),
                  ),
                },
              ],
            ),
          ),
        },
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaginatedDataTable(
                  key: UniqueKey(),
                  rowsPerPage: widget.perPageRows,
                  columnSpacing: widget.columnSpacing ?? 56,
                  showFirstLastButtons: true,
                  sortColumnIndex: sortColumnIndex,
                  sortAscending: sortAscending,
                  columns: [
                    ...widget.columns.map(
                      (column) => DataColumn(
                        label: Text(column.value ?? "N/A"),
                        tooltip: column.value,
                        onSort: (columnIndex, ascending) {
                          sortColumnIndex = columnIndex;
                          sortAscending = ascending;
                          sortData(updatedData);
                        },
                      ),
                    ),
                  ],
                  source: _dataSource!,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PaginationDataTableSource extends DataTableSource {
  final BuildContext context;
  final List<List<PlexDataCell>> dataList;
  final Color? alternateColor;
  int isAlternate = -1;

  _PaginationDataTableSource(
    this.context, {
    required this.dataList,
    required this.alternateColor,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= dataList.length) {
      return null;
    }
    final data = dataList[index];

    return DataRow(
      color: isAlternate++ % 2 == 0 ? alternateColor?.getColorState() : null,
      cells: [
        ...data.map(
          (data) => DataCell(
            data.cell?.child ?? Text(data.value ?? "N/A"),
            onTap: data.cell?.onTap ??
                () {
                  Clipboard.setData(ClipboardData(text: data.value ?? "N/A"));
                  context.showSnackBar("Text copied on clipboard");
                },
            showEditIcon: data.cell?.showEditIcon ?? false,
            onDoubleTap: data.cell?.onDoubleTap,
            onLongPress: data.cell?.onLongPress,
            onTapCancel: data.cell?.onTapCancel,
            onTapDown: data.cell?.onTapDown,
            placeholder: data.cell?.placeholder ?? false,
          ),
        )
      ],
    );
  }

  @override
  int get rowCount => dataList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
