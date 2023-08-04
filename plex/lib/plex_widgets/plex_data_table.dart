// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_material.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_utils/plex_printer.dart';

class PlexDataCell {
  late final String? value;
  late final DataCell? cell;

  PlexDataCell(String this.value) {
    cell = null;
  }

  PlexDataCell.cell(this.value, this.cell) {
    if (value == null && cell == null) throw Exception("Either Value or DataCell must not be null");
  }
}

// ignore: must_be_immutable
class PlexDataTable extends StatefulWidget {
  PlexDataTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.onRefresh,
    this.onLoadMore,
    this.headerBackground,
    this.headerTextStyle,
    this.alternateColor = true,
  }) : super(key: key);

  ///All Column titles
  final List<PlexDataCell> columns;

  ///Data Rows
  final List<List<PlexDataCell>> rows;

  ///Styles
  final Color? headerBackground;
  final TextStyle? headerTextStyle;
  final bool alternateColor;

  ///OnRefresh Button Click Callback
  Function()? onRefresh;

  ///OnLoadMore Button Click Callback
  List<PlexDataCell> Function(int page)? onLoadMore;

  @override
  State<PlexDataTable> createState() => _PlexDataTableState();
}

class _PlexDataTableState extends State<PlexDataTable> {
  var scrollController = ScrollController(
    keepScrollOffset: true,
  );

  @override
  Widget build(BuildContext context) {
    int isAlternate = 0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dim.medium, vertical: Dim.small),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onRefresh != null) ...{
                FilledButton.tonal(
                  onPressed: () {
                    widget.onRefresh?.call();
                  },
                  child: const Icon(Icons.refresh),
                ),
                spaceSmall(),
              },
              FilledButton.tonal(
                onPressed: () async {
                  var path = await PlexPrinter.printExcel(
                    "Data",
                    widget.columns,
                    widget.rows,
                  );
                  if (path == null) {
                    context.showSnackBar(path);
                  }
                  context.showSnackBar("Report saved at \"$path\"");
                },
                child: const Icon(Icons.print),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: widget.headerBackground?.getColorState(),
              headingTextStyle: widget.headerTextStyle,
              columns: [...widget.columns.map((column) => DataColumn(label: Text(column.value ?? "N/A"), tooltip: column.value))],
              rows: [
                ...widget.rows.map(
                  (row) => DataRow(
                    color: isAlternate++ % 2 == 0 ? const Color(0xFF9B9B9B).getColorState() : null,
                    cells: [
                      ...row.map(
                        (data) => data.cell != null ? data.cell! : DataCell(
                          Text(data.value ?? "N/A"),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: data.value ?? "N/A"));
                            context.showSnackBar("Text copied on clipboard");
                          },
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
