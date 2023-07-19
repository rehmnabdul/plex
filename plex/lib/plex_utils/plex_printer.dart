import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_widgets/plex_data_table.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class PlexPrinter {
  PlexPrinter._();

  static printExcel(String title, List<String> columns, List<PlexDataRow> rows) async {
    var workbook = Workbook();

    final Worksheet productionSheet = workbook.worksheets[0];
    productionSheet.name = title;
    productionSheet.showGridlines = false;
    productionSheet.enableSheetCalculations();

    var productionRowNumber = 1;
    var endColumn = columns.length;

    final Range productionRange6 = productionSheet.getRangeByIndex(productionRowNumber, 1, productionRowNumber, endColumn);
    productionRange6.cellStyle.fontSize = 10;
    productionRange6.cellStyle.bold = true;
    productionRange6.cellStyle.backColorRgb = Colors.grey;

    var currentColumn = 2;
    for (var column in columns) {
      productionSheet.getRangeByIndex(productionRowNumber, currentColumn++).setText(column);
    }

    productionRowNumber++;
    for (var row in rows) {
      currentColumn = 2;
      for (var data in row) {
        productionSheet.getRangeByIndex(productionRowNumber, currentColumn++).setText(data);
      }
      productionRowNumber++;
    }

    var productionLastRow = productionRowNumber - 1;

    productionSheet.getRangeByIndex(1, 1, productionLastRow, endColumn).autoFitColumns();
    productionSheet.getRangeByIndex(1, 1, productionLastRow, endColumn).cellStyle.borders.bottom.lineStyle = LineStyle.dashed;
    productionSheet.getRangeByIndex(1, 1, productionLastRow, endColumn).cellStyle.borders.bottom.colorRgb = Colors.grey;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    String ext = "xlsx";
    Future<String?> fileSaveTask;
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      fileSaveTask = FileSaver.instance.saveAs(
        name: "$title.$ext",
        bytes: Uint8List.fromList(bytes),
        ext: ext,
        mimeType: MimeType.microsoftExcel,
      );
    } else {
      fileSaveTask = FileSaver.instance.saveFile(
        name: title,
        bytes: Uint8List.fromList(bytes),
        ext: ext,
        mimeType: MimeType.microsoftExcel,
      );
    }

    final result = await fileSaveTask;

    if (kDebugMode) {
      print(result ?? "Unable to save file");
    }

    if (result == null) {
      return null;
    }
    var filePath = File(result).absolute.path;
    return filePath;
  }
}
