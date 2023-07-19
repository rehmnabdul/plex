import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_utils/plex_printer.dart';

typedef PlexDataRow = List<String>;

// ignore: must_be_immutable
class PlexDataTable extends StatefulWidget {
  PlexDataTable({Key? key, required this.columns, required this.rows, this.onRefresh, this.onLoadMore}) : super(key: key);

  ///All Column titles
  final List<String> columns;
  ///Data Rows
  final List<PlexDataRow> rows;

  ///OnRefresh Button Click Callback
  Function()? onRefresh;
  ///OnLoadMore Button Click Callback
  List<PlexDataRow> Function(int page)? onLoadMore;

  @override
  State<PlexDataTable> createState() => _PlexDataTableState();
}

class _PlexDataTableState extends State<PlexDataTable> {

  var scrollController = ScrollController(
    keepScrollOffset: true,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dim.medium, vertical: Dim.small),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.tonal(
                onPressed: () {},
                child: const Icon(Icons.refresh),
              ),
              spaceSmall(),
              FilledButton.tonal(
                onPressed: () async {
                  var path = await PlexPrinter.printExcel("Data", widget.columns, widget.rows);
                  if(path == null) {
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
              columns: [...widget.columns.map((column) => DataColumn(label: Text(column), tooltip: column))],
              rows: [
                ...widget.rows.map(
                  (row) => DataRow(
                    cells: [
                      ...row.map(
                        (data) => DataCell(
                          Text(data),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: data));
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
