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
    this.alternateColor = const Color(0xFFCECECE),
  }) : super(key: key);

  ///All Column titles
  final List<PlexDataCell> columns;

  ///Data Rows
  final List<List<PlexDataCell>> rows;

  ///Styles
  final Color? headerBackground;
  final TextStyle? headerTextStyle;
  final Color? alternateColor;

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
                    color: isAlternate++ % 2 == 0 ? widget.alternateColor?.getColorState() : null,
                    cells: [
                      ...row.map(
                        (data) => DataCell(
                          data.cell?.child ?? Text(data.value ?? "N/A"),
                          onTap: data.cell?.onTap ?? () {
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
