import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plex/plex_utils/plex_xlsx.dart';

class PlexPrinter {
  PlexPrinter._();

  /// Builds an .xlsx workbook in memory. Does not prompt to save.
  static List<int> buildExcelBytes(
      String title, List<dynamic> columns, List<List<dynamic>> rows) {
    return PlexXlsx.build(title: title, columns: columns, rows: rows);
  }

  static printExcel(
      String title, List<dynamic> columns, List<List<dynamic>> rows) async {
    return await saveExcelFile(title, buildExcelBytes(title, columns, rows));
  }

  /// Builds a simple table PDF and saves it via [savePdfFile].
  static Future<String?> printPdf(
      String title, List<dynamic> columns, List<List<dynamic>> rows) async {
    final List<int> bytes = buildTablePdf(title, columns, rows);
    return await savePdfFile(title, bytes);
  }

  /// Plex-owned table PDF (Helvetica / WinAnsi). No Syncfusion DataGrid.
  static List<int> buildTablePdf(
      String title, List<dynamic> columns, List<List<dynamic>> rows) {
    return _PlexTablePdf.build(title, columns, rows);
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
      debugPrint(result ?? "Unable to save file");
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
      debugPrint(result ?? "Unable to save file");
    }

    if (result == null) {
      return null;
    }
    var filePath = File(result).absolute.path;
    return filePath;
  }

  /// RFC 4180 CSV from headers and row values. Does not prompt to save.
  static String buildCsv(List<dynamic> columns, List<List<dynamic>> rows) {
    final StringBuffer out = StringBuffer();
    out.writeln(columns.map(_csvField).join(','));
    for (final List<dynamic> row in rows) {
      final List<String> cells = List<String>.generate(columns.length, (int i) {
        if (i >= row.length) return _csvField('');
        return _csvField(row[i]);
      });
      out.writeln(cells.join(','));
    }
    return out.toString();
  }

  static Future<String?> printCsv(
      String title, List<dynamic> columns, List<List<dynamic>> rows) async {
    final List<int> bytes = utf8.encode(buildCsv(columns, rows));
    return await saveCsvFile(title, bytes);
  }

  static Future<String?> saveCsvFile(String title, List<int> bytes) async {
    String ext = "csv";
    Future<String?> fileSaveTask;
    title = "$title-${DateFormat("dd-MMM-yyyy-HHmmss").format(DateTime.now())}";
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      fileSaveTask = FileSaver.instance.saveAs(
        name: "$title.$ext",
        bytes: Uint8List.fromList(bytes),
        ext: ext,
        mimeType: MimeType.csv,
      );
    } else {
      fileSaveTask = FileSaver.instance.saveFile(
        name: title,
        bytes: Uint8List.fromList(bytes),
        ext: ext,
        mimeType: MimeType.csv,
      );
    }

    final result = await fileSaveTask;

    if (kDebugMode) {
      debugPrint(result ?? "Unable to save file");
    }

    if (result == null) {
      return null;
    }
    var filePath = File(result).absolute.path;
    return filePath;
  }

  static String _csvField(dynamic value) {
    final String text = value?.toString() ?? '';
    if (text.contains(',') ||
        text.contains('"') ||
        text.contains('\n') ||
        text.contains('\r')) {
      return '"${text.replaceAll('"', '""')}"';
    }
    return text;
  }
}

class _PlexTablePdf {
  static const double _pageWidth = 612;
  static const double _pageHeight = 792;
  static const double _margin = 36;
  static const double _titleSize = 14;
  static const double _cellSize = 8;
  static const double _rowHeight = 12;

  static List<int> build(
    String title,
    List<dynamic> columns,
    List<List<dynamic>> rows,
  ) {
    final int colCount = math.max(columns.length, 1);
    final double colWidth = (_pageWidth - 2 * _margin) / colCount;
    final int maxChars = math.max(1, (colWidth / (_cellSize * 0.5)).floor());

    final List<String> headers = columns.isEmpty
        ? <String>['']
        : columns.map((dynamic c) => _clip(c.toString(), maxChars)).toList();
    final List<List<String>> body = rows.map((List<dynamic> row) {
      return List<String>.generate(colCount, (int i) {
        if (i >= row.length) return '';
        return _clip(row[i]?.toString() ?? '', maxChars);
      });
    }).toList();

    final double titleY = _pageHeight - _margin - _titleSize;
    final double firstRowY = titleY - 24;
    final int rowsPerPage = math.max(
      1,
      ((firstRowY - _margin) / _rowHeight).floor() - 1,
    );

    final List<List<int>> pageStreams = <List<int>>[];
    int offset = 0;
    do {
      final StringBuffer content = StringBuffer();
      _writeText(content, title, _margin, titleY, _titleSize);
      double y = firstRowY;
      _writeRow(content, headers, y, colWidth);
      y -= _rowHeight;
      final int end = math.min(offset + rowsPerPage, body.length);
      for (int i = offset; i < end; i++) {
        _writeRow(content, body[i], y, colWidth);
        y -= _rowHeight;
      }
      pageStreams.add(utf8.encode(content.toString()));
      offset = end;
    } while (offset < body.length);

    return _assemble(pageStreams);
  }

  static void _writeRow(
    StringBuffer content,
    List<String> cells,
    double y,
    double colWidth,
  ) {
    for (int i = 0; i < cells.length; i++) {
      _writeText(content, cells[i], _margin + i * colWidth, y, _cellSize);
    }
  }

  static void _writeText(
    StringBuffer content,
    String text,
    double x,
    double y,
    double size,
  ) {
    content.writeln('BT');
    content.writeln('/F1 ${size.toStringAsFixed(1)} Tf');
    content
        .writeln('1 0 0 1 ${x.toStringAsFixed(2)} ${y.toStringAsFixed(2)} Tm');
    content.writeln('(${_pdfEscape(text)}) Tj');
    content.writeln('ET');
  }

  static String _clip(String text, int maxChars) {
    if (text.length <= maxChars) return text;
    if (maxChars <= 1) return text.substring(0, text.isEmpty ? 0 : 1);
    return '${text.substring(0, maxChars - 1)}~';
  }

  static String _pdfEscape(String text) {
    final StringBuffer out = StringBuffer();
    for (final int code in text.codeUnits) {
      if (code == 0x5C) {
        out.write(r'\\');
      } else if (code == 0x28) {
        out.write(r'\(');
      } else if (code == 0x29) {
        out.write(r'\)');
      } else if (code == 0x0A || code == 0x0D) {
        out.write(' ');
      } else if (code < 32 || code > 126) {
        out.write('?');
      } else {
        out.writeCharCode(code);
      }
    }
    return out.toString();
  }

  static List<int> _assemble(List<List<int>> pageStreams) {
    final int pageCount = pageStreams.length;
    final List<int> pageIds = List<int>.generate(
      pageCount,
      (int i) => 4 + i * 2,
    );

    final List<List<int>> objects = <List<int>>[
      utf8.encode('1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n'),
      utf8.encode(
        '2 0 obj\n<< /Type /Pages /Kids [${pageIds.map((int id) => '$id 0 R').join(' ')}] /Count $pageCount >>\nendobj\n',
      ),
      utf8.encode(
        '3 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n',
      ),
    ];

    for (int i = 0; i < pageCount; i++) {
      final int pageId = pageIds[i];
      final int contentId = pageId + 1;
      final List<int> stream = pageStreams[i];
      objects.add(utf8.encode(
        '$pageId 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 ${_pageWidth.toInt()} ${_pageHeight.toInt()}] /Contents $contentId 0 R /Resources << /Font << /F1 3 0 R >> >> >>\nendobj\n',
      ));
      final BytesBuilder contentObj = BytesBuilder();
      contentObj.add(utf8.encode(
        '$contentId 0 obj\n<< /Length ${stream.length} >>\nstream\n',
      ));
      contentObj.add(stream);
      contentObj.add(utf8.encode('\nendstream\nendobj\n'));
      objects.add(contentObj.toBytes());
    }

    final BytesBuilder file = BytesBuilder();
    file.add(utf8.encode('%PDF-1.4\n'));
    final List<int> offsets = List<int>.filled(objects.length + 1, 0);
    for (int i = 0; i < objects.length; i++) {
      offsets[i + 1] = file.length;
      file.add(objects[i]);
    }
    final int xrefAt = file.length;
    final StringBuffer xref = StringBuffer();
    xref.write('xref\n0 ${objects.length + 1}\n');
    xref.write('0000000000 65535 f \n');
    for (int i = 1; i <= objects.length; i++) {
      xref.write('${offsets[i].toString().padLeft(10, '0')} 00000 n \n');
    }
    file.add(utf8.encode(xref.toString()));
    file.add(utf8.encode(
      'trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n$xrefAt\n%%EOF\n',
    ));
    return file.toBytes();
  }
}
