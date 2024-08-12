import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class PlexPrinter {
  PlexPrinter._();

  static printExcel(
      String title, List<dynamic> columns, List<List<dynamic>> rows) async {
    var workbook = Workbook();

    final Worksheet productionSheet = workbook.worksheets[0];
    productionSheet.name = title;
    productionSheet.showGridlines = false;
    productionSheet.enableSheetCalculations();

    var productionRowNumber = 1;
    var endColumn = columns.length;

    final Range productionRange6 = productionSheet.getRangeByIndex(
        productionRowNumber, 1, productionRowNumber, endColumn);
    productionRange6.cellStyle.fontSize = PlexFontSize.smallest;
    productionRange6.cellStyle.bold = true;
    productionRange6.cellStyle.backColorRgb = Colors.grey;

    var currentColumn = 1;
    for (var column in columns) {
      productionSheet
          .getRangeByIndex(productionRowNumber, currentColumn++)
          .setText(column.toString());
    }

    productionRowNumber++;
    for (var row in rows) {
      currentColumn = 1;
      for (var data in row) {
        productionSheet
            .getRangeByIndex(productionRowNumber, currentColumn++)
            .setText(data.toString());
      }
      productionRowNumber++;
    }

    var productionLastRow = productionRowNumber - 1;

    productionSheet
        .getRangeByIndex(1, 1, productionLastRow, endColumn)
        .autoFitColumns();
    productionSheet
        .getRangeByIndex(1, 1, productionLastRow, endColumn)
        .cellStyle
        .borders
        .bottom
        .lineStyle = LineStyle.dashed;
    productionSheet
        .getRangeByIndex(1, 1, productionLastRow, endColumn)
        .cellStyle
        .borders
        .bottom
        .colorRgb = Colors.grey;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    return await saveExcelFile(title, bytes);
  }

  static Future<String?> saveExcelFile(String title, List<int> bytes) async {
    String ext = "xlsx";
    Future<String?> fileSaveTask;
    title = "$title-${DateFormat("dd-MMM-yyyy-HHmmss").format(DateTime.now())}";
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

  static Future<String?> savePdfFile(String title, List<int> bytes) async {
    String ext = "pdf";
    Future<String?> fileSaveTask;
    title = "$title-${DateFormat("dd-MMM-yyyy-HHmmss").format(DateTime.now())}";
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      fileSaveTask = FileSaver.instance.saveAs(
        name: "$title.$ext",
        bytes: Uint8List.fromList(bytes),
        ext: ext,
        mimeType: MimeType.pdf,
      );
    } else {
      fileSaveTask = FileSaver.instance.saveFile(
        name: title,
        bytes: Uint8List.fromList(bytes),
        ext: ext,
        mimeType: MimeType.pdf,
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
