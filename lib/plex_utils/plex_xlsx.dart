import 'package:archive/archive.dart';

/// Minimal OOXML (.xlsx) writer. Cells are inline strings so Excel/LibreOffice
/// can open the file without a sharedStrings table.
class PlexXlsx {
  PlexXlsx._();

  static List<int> build({
    required String title,
    required List<dynamic> columns,
    required List<List<dynamic>> rows,
  }) {
    final String sheetName = sanitizeSheetName(title);
    final Archive archive = Archive();
    _addXml(archive, '[Content_Types].xml', _contentTypes);
    _addXml(archive, '_rels/.rels', _packageRels);
    _addXml(archive, 'xl/workbook.xml', _workbookXml(sheetName));
    _addXml(archive, 'xl/_rels/workbook.xml.rels', _workbookRels);
    _addXml(archive, 'xl/styles.xml', _stylesXml);
    _addXml(archive, 'xl/worksheets/sheet1.xml', _sheetXml(columns, rows));
    return ZipEncoder().encode(archive);
  }

  /// Excel sheet names: max 31 chars, no `: \ / ? * [ ]`, not empty,
  /// not wrapped in a single quote.
  static String sanitizeSheetName(String title) {
    String name = title.replaceAll(RegExp(r'[:\\/?*\[\]]'), ' ').trim();
    if (name.startsWith("'")) {
      name = name.substring(1).trimLeft();
    }
    if (name.endsWith("'")) {
      name = name.substring(0, name.length - 1).trimRight();
    }
    if (name.isEmpty) {
      name = 'Sheet1';
    }
    if (name.length > 31) {
      name = name.substring(0, 31).trimRight();
      if (name.endsWith("'")) {
        name = name.substring(0, name.length - 1).trimRight();
      }
    }
    if (name.isEmpty) {
      return 'Sheet1';
    }
    return name;
  }

  static void _addXml(Archive archive, String path, String xml) {
    archive.addFile(ArchiveFile.string(path, xml));
  }

  static String _workbookXml(String sheetName) {
    return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"'
        ' xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
        '<sheets>'
        '<sheet name="${_xmlEscape(sheetName)}" sheetId="1" r:id="rId1"/>'
        '</sheets>'
        '</workbook>';
  }

  static String _sheetXml(List<dynamic> columns, List<List<dynamic>> rows) {
    final StringBuffer data = StringBuffer();
    var rowNumber = 1;
    if (columns.isNotEmpty) {
      data.write(_rowXml(rowNumber, columns, style: 1));
      rowNumber++;
    }
    for (final List<dynamic> row in rows) {
      data.write(_rowXml(rowNumber, row));
      rowNumber++;
    }
    return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
        '<sheetData>$data</sheetData>'
        '</worksheet>';
  }

  static String _rowXml(int rowNumber, List<dynamic> cells, {int? style}) {
    final StringBuffer row = StringBuffer('<row r="$rowNumber">');
    for (var i = 0; i < cells.length; i++) {
      final String ref = '${_columnLetter(i)}$rowNumber';
      final String styleAttr = style == null ? '' : ' s="$style"';
      row.write(
        '<c r="$ref"$styleAttr t="inlineStr"><is><t xml:space="preserve">'
        '${_xmlEscape(_cellText(cells[i]))}'
        '</t></is></c>',
      );
    }
    row.write('</row>');
    return row.toString();
  }

  static String _cellText(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static String _columnLetter(int index) {
    var n = index;
    var result = '';
    while (n >= 0) {
      result = String.fromCharCode(65 + (n % 26)) + result;
      n = n ~/ 26 - 1;
    }
    return result;
  }

  static String _xmlEscape(String text) {
    final StringBuffer out = StringBuffer();
    for (final int code in text.codeUnits) {
      if (code == 0x26) {
        out.write('&amp;');
      } else if (code == 0x3C) {
        out.write('&lt;');
      } else if (code == 0x3E) {
        out.write('&gt;');
      } else if (code == 0x22) {
        out.write('&quot;');
      } else if (code == 0x27) {
        out.write('&apos;');
      } else if (code == 0x9 || code == 0xA || code == 0xD || code >= 0x20) {
        out.writeCharCode(code);
      }
    }
    return out.toString();
  }

  static const String _contentTypes =
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
      '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
      '<Default Extension="xml" ContentType="application/xml"/>'
      '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
      '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
      '</Types>';

  static const String _packageRels =
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
      '</Relationships>';

  static const String _workbookRels =
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
      '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>'
      '</Relationships>';

  static const String _stylesXml =
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
      '<fonts count="2">'
      '<font><sz val="11"/><color theme="1"/><name val="Calibri"/><family val="2"/></font>'
      '<font><b/><sz val="11"/><color theme="1"/><name val="Calibri"/><family val="2"/></font>'
      '</fonts>'
      '<fills count="2">'
      '<fill><patternFill patternType="none"/></fill>'
      '<fill><patternFill patternType="gray125"/></fill>'
      '</fills>'
      '<borders count="1">'
      '<border><left/><right/><top/><bottom/><diagonal/></border>'
      '</borders>'
      '<cellStyleXfs count="1">'
      '<xf numFmtId="0" fontId="0" fillId="0" borderId="0"/>'
      '</cellStyleXfs>'
      '<cellXfs count="2">'
      '<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>'
      '<xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" applyFont="1"/>'
      '</cellXfs>'
      '</styleSheet>';
}
