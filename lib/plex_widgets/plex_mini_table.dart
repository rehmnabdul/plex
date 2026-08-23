import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Cell alignment for [PlexMiniTable].
enum PlexMiniTableAlign {
  left,
  center,
  right,
}

/// Row density for [PlexMiniTable].
enum PlexMiniTableDensity {
  comfortable,
  compact,
}

/// Column definition. Cells are plain [String]s.
class PlexMiniTableColumn {
  const PlexMiniTableColumn({
    required this.id,
    required this.header,
    this.align = PlexMiniTableAlign.left,
    this.numeric = false,
    this.width,
  });

  final String id;
  final String header;
  final PlexMiniTableAlign align;
  final bool numeric;
  final double? width;
}

/// Compact read-only table for dashboard tiles.
///
/// Does not replace [PlexDataTable] or [PlexDataGrid].
class PlexMiniTable extends StatelessWidget {
  const PlexMiniTable({
    super.key,
    required this.columns,
    required this.rows,
    this.zebra = false,
    this.density = PlexMiniTableDensity.comfortable,
    this.plainHead = false,
    this.onRowTap,
    this.emptyMessage = 'Nothing to show',
  });

  final List<PlexMiniTableColumn> columns;
  final List<List<String>> rows;
  final bool zebra;
  final PlexMiniTableDensity density;
  final bool plainHead;
  final ValueChanged<int>? onRowTap;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(PlexDim.large),
        child: Center(
          child: Text(
            emptyMessage,
            style: TextStyle(
              color: colors.textMuted,
              fontSize: PlexFontSize.caption,
            ),
          ),
        ),
      );
    }

    final EdgeInsets cellPad = density == PlexMiniTableDensity.compact
        ? const EdgeInsets.symmetric(
            horizontal: PlexDim.medium,
            vertical: PlexDim.small,
          )
        : const EdgeInsets.symmetric(
            horizontal: PlexDim.medium,
            vertical: PlexDim.smallMedium,
          );

    final Map<int, TableColumnWidth> widths = <int, TableColumnWidth>{
      for (int i = 0; i < columns.length; i++)
        i: columns[i].width != null
            ? FixedColumnWidth(columns[i].width!)
            : const IntrinsicColumnWidth(),
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        columnWidths: widths,
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: plainHead ? Colors.transparent : colors.surfaceSunken,
              border: Border(bottom: BorderSide(color: colors.borderSubtle)),
            ),
            children: [
              for (final PlexMiniTableColumn column in columns)
                _cell(
                  text: column.header.toUpperCase(),
                  column: column,
                  colors: colors,
                  header: true,
                  padding: cellPad,
                ),
            ],
          ),
          for (int i = 0; i < rows.length; i++)
            TableRow(
              decoration: BoxDecoration(
                color: zebra && i.isOdd ? colors.surfaceSunken : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: i == rows.length - 1
                        ? Colors.transparent
                        : colors.borderSubtle,
                  ),
                ),
              ),
              children: [
                for (int c = 0; c < columns.length; c++)
                  TableRowInkWell(
                    onTap: onRowTap == null ? null : () => onRowTap!(i),
                    child: _cell(
                      text: c < rows[i].length ? rows[i][c] : '',
                      column: columns[c],
                      colors: colors,
                      header: false,
                      padding: cellPad,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _cell({
    required String text,
    required PlexMiniTableColumn column,
    required PlexColorTokens colors,
    required bool header,
    required EdgeInsets padding,
  }) {
    final TextAlign align = column.numeric ||
            column.align == PlexMiniTableAlign.right
        ? TextAlign.right
        : column.align == PlexMiniTableAlign.center
            ? TextAlign.center
            : TextAlign.left;

    return Padding(
      padding: padding,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: header ? colors.textMuted : colors.textPrimary,
          fontSize: header ? PlexFontSize.smallest : PlexFontSize.caption,
          fontWeight: header || column.numeric ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: header ? 0.6 : 0,
          fontFeatures:
              column.numeric ? const [FontFeature.tabularFigures()] : null,
        ),
      ),
    );
  }
}
