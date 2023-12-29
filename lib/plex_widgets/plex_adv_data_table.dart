import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PlexAdvanceDataCell {
  late final bool isNumber;
  late final String columnName;
  late final dynamic value;
  late final DataCell? cell;

  ///[value] is required as it is text only cell
  PlexAdvanceDataCell.text(this.value, {this.columnName = "", bool numberField = false}) {
    value ??= "";
    isNumber = numberField || value is int || value is double;
    cell = null;
  }

  ///For custom design and handling of cell use this constructor.
  ///[value] is optional
  ///[cell] is required for custom cell
  PlexAdvanceDataCell.custom(this.value, this.cell, {this.columnName = "", bool numberField = false}) {
    if (value == null && cell == null) value = "";
    isNumber = numberField || value is int || value is double;
  }
}

class PlexAdvanceDataTable extends StatefulWidget {
  const PlexAdvanceDataTable({Key? key}) : super(key: key);

  @override
  State<PlexAdvanceDataTable> createState() => _PlexAdvanceDataTableState();
}

class _PlexAdvanceDataTableState extends State<PlexAdvanceDataTable> {
  var columns = List<GridColumn>.empty(growable: true);
  var data = List<List<PlexAdvanceDataCell>>.empty(growable: true);
  late _PlexAdvanceDataTableDataSource source;

  @override
  void initState() {
    super.initState();
    columns.add(GridColumn(columnName: "Id", label: const Text("Id")));
    columns.add(GridColumn(columnName: "First Name", label: const Text("First Name")));
    columns.add(GridColumn(columnName: "Last Name", label: const Text("Last Name")));
    columns.add(GridColumn(columnName: "Designation", label: const Text("Designation")));
    columns.add(GridColumn(columnName: "Company", label: const Text("Company")));
    data.add([PlexAdvanceDataCell.text(1), PlexAdvanceDataCell.text("Abdur"), PlexAdvanceDataCell.text("Rahman"), PlexAdvanceDataCell.text("Sr. Manager"), PlexAdvanceDataCell.text("Company Pvt .Ltd")]);
    data.add([PlexAdvanceDataCell.text(2), PlexAdvanceDataCell.text("Muhammad"), PlexAdvanceDataCell.text("Umer"), PlexAdvanceDataCell.text("Manager"), PlexAdvanceDataCell.text("Company Pvt .Ltd")]);
    source = _PlexAdvanceDataTableDataSource(data);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SfDataGrid(
            source: source,
            columns: columns,
          ),
        ],
      ),
    );
  }
}

class _PlexAdvanceDataTableDataSource extends DataGridSource {
  late List<DataGridRow> data;

  _PlexAdvanceDataTableDataSource(List<List<PlexAdvanceDataCell>> data) {
    this.data = data
        .map((e) => DataGridRow(
            cells: e
                .map((e) => DataGridCell(
                      columnName: "",
                      value: e.value.toString(),
                    ))
                .toList()))
        .toList();
  }

  @override
  List<DataGridRow> get rows => data;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row
            .getCells()
            .map((dataGridCell) => Container(
                  alignment: (dataGridCell.columnName == 'id' || dataGridCell.columnName == 'salary') ? Alignment.centerRight : Alignment.centerLeft,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(dataGridCell.value.toString()),
                ))
            .toList());
  }
}
