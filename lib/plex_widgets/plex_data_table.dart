// ignore_for_file: use_build_context_synchronously, must_be_immutable, deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_material.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_utils/plex_printer.dart';
import 'package:plex/plex_l10n/plex_localization.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_widgets/plex_shimmer.dart';

class PlexDataCell {
  late final bool isNumber;
  late final dynamic value;
  late final DataCell? cell;

  ///[value] is required as it is text only cell
  PlexDataCell.text(this.value, {bool numberField = false}) {
    value ??= "";
    isNumber = numberField || value is int || value is double;
    cell = null;
  }

  ///For custom design and handling of cell use this constructor.
  ///[value] is optional
  ///[cell] is required for custom cell
  PlexDataCell.custom(this.value, this.cell, {bool numberField = false}) {
    if (value == null && cell == null) value = "";
    isNumber = numberField || value is int || value is double;
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
    this.enableCopy = true,
    this.enablePrint = true,
    this.headerBackground,
    this.headerTextStyle,
    this.alternateColor = const Color(0xFFA8A8A8),
    this.border,
    this.columnSpacing,
    this.showShimmer = true,
  }) : super(key: key ?? GlobalKey());

  ///All Column titles
  final List<PlexDataCell> columns;

  ///Data Rows
  final List<List<PlexDataCell>>? rows;

  ///Styles
  final Color? headerBackground;
  final TextStyle? headerTextStyle;
  final Color? alternateColor;
  TableBorder? border;
  double? columnSpacing;

  ///Shimmer Controls
  final bool showShimmer;

  ///Hide and show Search Field
  final bool enableSearch;

  ///Enable Disable Copy Field Value
  final bool enableCopy;

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
  List<List<PlexDataCell>>? updatedData;
  int? sortColumnIndex;
  bool sortAscending = true;
  Set<int> searchColumnIndexes = {};

  @override
  void initState() {
    super.initState();
    updatedData = widget.rows;
  }

  sortData(List<List<PlexDataCell>>? data) {
    if (sortColumnIndex == null) {
      setState(() {
        updatedData = data;
      });
      return;
    }

    data?.sort((r1, r2) {
      var value1 = !r1[sortColumnIndex!].isNumber
          ? r1[sortColumnIndex!].value
          : ((r1[sortColumnIndex!].value is int?)
              ? r1[sortColumnIndex!].value as int?
              : (r1[sortColumnIndex!].value is double?)
                  ? r1[sortColumnIndex!].value as double?
                  : null);
      var value2 = !r2[sortColumnIndex!].isNumber
          ? r2[sortColumnIndex!].value
          : ((r2[sortColumnIndex!].value is int?)
              ? r2[sortColumnIndex!].value as int?
              : (r2[sortColumnIndex!].value is double?)
                  ? r2[sortColumnIndex!].value as double?
                  : null);
      try {
        if (sortAscending) {
          return (value1).compareTo(value2);
        } else {
          return value2.compareTo(value1);
        }
      } catch (e) {
        return sortAscending ? -1 : 1;
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
      data = data?.where((r) {
        var isOk = false;
        for (var colIndex in searchIndexes) {
          if ((r[colIndex].value?.toString() ?? "").toLowerCase().contains(searchController.text.toLowerCase())) {
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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          if (widget.enableSearch) ...{
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
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
              padding: const EdgeInsets.symmetric(vertical: PlexDim.small),
              child: Row(
                children: [
                  Expanded(
                    child: widget.enableSearch
                        ? PlexFormFieldInput(
                            properties: PlexFormFieldGeneric(title: context.plexStrings.tableSearch, useMargin: false),
                            inputController: searchController,
                            inputHint: context.plexStrings.tableSearchHint,
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
                          context.plexStrings.tableData,
                          widget.columns,
                          updatedData ?? List.empty(),
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
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: widget.columnSpacing,
              border: widget.border ?? TableBorder.all(color: Colors.black38),
              headingRowColor: widget.headerBackground?.getMaterialState(),
              headingTextStyle: widget.headerTextStyle,
              sortColumnIndex: sortColumnIndex,
              sortAscending: sortAscending,
              columns: [
                ...widget.columns.asMap().entries.map(
                  (entry) {
                    final column = entry.value;
                    return DataColumn(
                      numeric: column.isNumber,
                      label: Semantics(
                        header: true,
                        label: column.value?.toString() ?? '',
                        child: Text(column.value ?? context.plexStrings.dropdownNoData),
                      ),
                      tooltip: column.value,
                      onSort: (columnIndex, ascending) {
                        sortColumnIndex = columnIndex;
                        sortAscending = ascending;
                        sortData(updatedData);
                      },
                    );
                  },
                ),
              ],
              rows: [
                if (updatedData == null) ...{
                  ...(List.generate(10, (index) => index)).map(
                    (e) => DataRow(
                      cells: [
                        ...widget.columns.map(
                          (e) => DataCell(
                            PlexShimmer(
                              child: Container(
                                color: Colors.green,
                                height: 25,
                                width: 60,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                } else ...{
                  ...?updatedData?.map(
                    (row) => DataRow(
                      color: isAlternate++ % 2 == 0 ? widget.alternateColor?.getMaterialState() : null,
                      cells: [
                        ...row.asMap().entries.map(
                          (entry) {
                            final i = entry.key;
                            final data = entry.value;
                            final columnLabel = widget.columns.length > i ? (widget.columns[i].value?.toString() ?? '') : '';
                            final cellValue = data.value?.toString() ?? context.plexStrings.dropdownNoData;
                            return DataCell(
                              Semantics(
                                label: columnLabel.isNotEmpty ? '$columnLabel: $cellValue' : cellValue,
                                child: data.cell?.child ?? Text(cellValue),
                              ),
                              onTap: data.cell?.onTap ??
                                  () {
                                    if (widget.enableCopy) {
                                      context.copyToClipboard(data.value?.toString() ?? context.plexStrings.dropdownNoData);
                                    }
                                  },
                              showEditIcon: data.cell?.showEditIcon ?? false,
                              onDoubleTap: data.cell?.onDoubleTap,
                              onLongPress: data.cell?.onLongPress,
                              onTapCancel: data.cell?.onTapCancel,
                              onTapDown: data.cell?.onTapDown,
                              placeholder: data.cell?.placeholder ?? false,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                }
              ],
            ),
          ),
          if (updatedData != null && updatedData!.isEmpty) ...{
            spaceMedium(),
            Text(context.plexStrings.tableNoData, textAlign: TextAlign.center),
          }
        ],
      ),
    );
  }
}
