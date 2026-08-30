import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_utils/plex_printer.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_widgets/plex_icon_button.dart';

/// Row selection behavior for [PlexDataGrid].
enum PlexDataGridSelectionMode {
  none,
  single,
  multiple,
}

/// Sort direction applied to a [PlexDataGrid] column.
enum PlexDataGridSortDirection {
  ascending,
  descending,
}

/// Active sort state for [PlexDataGrid].
class PlexDataGridSort {
  const PlexDataGridSort({
    required this.columnId,
    required this.direction,
  });

  final String columnId;
  final PlexDataGridSortDirection direction;

  @override
  bool operator ==(Object other) {
    return other is PlexDataGridSort &&
        other.columnId == columnId &&
        other.direction == direction;
  }

  @override
  int get hashCode => Object.hash(columnId, direction);
}

/// Style for a [PlexDataGrid] default text cell.
class PlexDataGridCellStyle {
  const PlexDataGridCellStyle({
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
  });

  /// Text color.
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  /// Field-by-field overlay. Non-null fields on [overlay] win.
  PlexDataGridCellStyle merge(PlexDataGridCellStyle? overlay) {
    if (overlay == null) return this;
    return PlexDataGridCellStyle(
      color: overlay.color ?? color,
      backgroundColor: overlay.backgroundColor ?? backgroundColor,
      fontSize: overlay.fontSize ?? fontSize,
      fontWeight: overlay.fontWeight ?? fontWeight,
      textAlign: overlay.textAlign ?? textAlign,
    );
  }
}

/// How a [PlexDataGrid] column gets its pixel width.
enum PlexDataGridColumnSizeMode {
  /// Pixel width from [PlexDataGridColumn.width] or 160. Current behavior. DEFAULT.
  fixed,

  /// Max of header text (uppercase as painted) vs cell text on the current page.
  auto,

  /// Header/title only (SF fitByColumnName).
  header,

  /// Cell values on the current page only (SF fitByCellValue).
  cells,

  /// Share leftover viewport width by [PlexDataGridColumn.flex] (default 1). Does not shrink below min.
  fill,

  /// This column (or the last such column) takes remaining viewport space after others.
  lastFill,
}

/// How a [PlexDataGrid] data row gets its pixel height.
enum PlexDataGridRowSizeMode {
  /// Density height (34 compact / 44 comfortable). Current behavior. DEFAULT.
  fixed,

  /// Wrap default text cells; row height = max child (at least density height).
  auto,
}

/// Column model for [PlexDataGrid].
///
/// [value] is the cell/sort/search accessor. Optional [cell] replaces the
/// default text rendering for that column. Optional [cellStyle] styles the
/// default text cell and overrides [PlexDataGrid.rowStyle] field-by-field.
///
/// Auto-fit widths ([PlexDataGridColumnSizeMode.auto], `.header`, `.cells`)
/// sample **header text plus the current page rows only** (after sort, filter,
/// and paging), not the whole dataset. See [PlexDataGridSizer].
class PlexDataGridColumn<T> {
  const PlexDataGridColumn({
    required this.id,
    required this.title,
    required this.value,
    this.cell,
    this.cellStyle,
    this.sortable = true,
    this.searchable = true,
    this.filterable = true,
    this.groupable = true,
    this.numeric = false,
    this.width,
    this.sizeMode,
    this.minWidth,
    this.maxWidth,
    this.flex = 1,
    this.rowSizeMode,
    this.editable = false,
  });

  final String id;
  final String title;
  final Object? Function(T row) value;

  /// Optional custom widget (buttons, badges, etc.). If non-null (and returns
  /// a non-null widget), it replaces default text. Sort/filter/CSV/Excel/PDF
  /// still use [value].
  final Widget? Function(BuildContext context, T row)? cell;

  /// Per-column style for the default Text cell; overrides
  /// [PlexDataGrid.rowStyle] for that cell. Conditions are Dart in the callback.
  final PlexDataGridCellStyle? Function(T row)? cellStyle;

  /// Header tap cycles ascending → descending → unsorted.
  final bool sortable;
  final bool searchable;

  /// When [PlexDataGrid.showColumnFilters] is true, this column gets a filter field.
  final bool filterable;

  /// Offered in the group-by toolbar control when [PlexDataGrid.enableGrouping] is true.
  final bool groupable;
  final bool numeric;

  /// Pixel width when [sizeMode] (or [PlexDataGrid.columnSizeMode]) is
  /// [PlexDataGridColumnSizeMode.fixed]. Ignored as a minimum for auto-fit;
  /// use [minWidth] for that. Defaults to 160 when null and mode is fixed.
  final double? width;

  /// When null, inherits [PlexDataGrid.columnSizeMode].
  final PlexDataGridColumnSizeMode? sizeMode;

  /// Lower bound after measurement / fill. Unset auto-fit uses ~48.
  final double? minWidth;

  /// Upper bound after measurement / fill. Unset auto-fit uses ~480.
  final double? maxWidth;

  /// Share of leftover viewport width when [sizeMode] is
  /// [PlexDataGridColumnSizeMode.fill].
  final double flex;

  /// When null, inherits [PlexDataGrid.rowSizeMode].
  final PlexDataGridRowSizeMode? rowSizeMode;

  /// When true and [PlexDataGrid.onCellEdited] or
  /// [PlexDataGrid.applyCellEdit] is set, default text cells can be edited.
  /// Custom [cell] widgets are not replaced.
  final bool editable;
}

/// Deterministic [TextPainter] measurements for [PlexDataGrid] column widths
/// and row heights.
///
/// Auto-width samples **header + current page rows only** (after sort, filter,
/// and paging), not the whole dataset. Custom [PlexDataGridColumn.cell]
/// widgets are measured via [PlexDataGridColumn.value] `.toString()`; arbitrary
/// widgets cannot be measured.
///
/// Extents are cached for the frame (keyed by style + text + maxWidth).
class PlexDataGridSizer {
  PlexDataGridSizer({this.fontFamily = 'Roboto'});

  final String fontFamily;

  static const double horizontalPadding = PlexDim.small * 2;
  static const double defaultMinWidth = 48;
  static const double defaultMaxWidth = 480;
  static const double defaultFixedWidth = 160;
  static const double sortIconExtra = 14;
  static const double groupIconExtra = 30;
  static const double selectColumnWidth = 44;

  final Map<Object, Size> _cache = <Object, Size>{};

  double densityRowHeight(PlexDensity density) {
    return density == PlexDensity.compact ? 34 : 44;
  }

  double densityHeaderHeight(PlexDensity density) {
    return density == PlexDensity.compact ? 38 : 44;
  }

  /// Unconstrained width of [text] with body cell styling.
  double measureCellWidth(
    String text, {
    bool numeric = false,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return _measure(
          text: text,
          fontSize: fontSize ?? PlexFontSize.body,
          fontWeight: fontWeight,
          tabular: numeric,
          fontFamily: fontFamily,
        ).width +
        horizontalPadding;
  }

  /// Wrapped height of [text] at [maxWidth] with body cell styling.
  double measureCellHeight(
    String text, {
    required double maxWidth,
    bool numeric = false,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return _measure(
      text: text,
      fontSize: fontSize ?? PlexFontSize.body,
      fontWeight: fontWeight,
      tabular: numeric,
      fontFamily: fontFamily,
      maxWidth: maxWidth,
    ).height;
  }

  /// Header label width: [title] painted uppercase + padding, plus [sortIconExtra]
  /// when [sortable] and [groupIconExtra] when [groupable].
  double measureHeaderWidth(
    String title, {
    bool sortable = false,
    bool groupable = false,
    String? fontFamily,
  }) {
    return _measure(
          text: title.toUpperCase(),
          fontSize: PlexFontSize.small,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05 * PlexFontSize.small,
          fontFamily: fontFamily,
        ).width +
        horizontalPadding +
        (sortable ? sortIconExtra : 0) +
        (groupable ? groupIconExtra : 0);
  }

  /// Preferred width of [column] before fill / lastFill leftover is applied.
  ///
  /// [pageRows] must already be the visible page (after sort/filter/paging).
  double columnIntrinsicWidth<T>({
    required PlexDataGridColumn<T> column,
    required List<T> pageRows,
    required PlexDataGridColumnSizeMode gridColumnSizeMode,
    PlexDataGridCellStyle? Function(T row)? rowStyle,
    bool groupingEnabled = false,
  }) {
    final PlexDataGridColumnSizeMode mode =
        column.sizeMode ?? gridColumnSizeMode;
    switch (mode) {
      case PlexDataGridColumnSizeMode.fixed:
        return _clampWidth(
          column.width ?? defaultFixedWidth,
          column,
          autoCaps: false,
        );
      case PlexDataGridColumnSizeMode.fill:
      case PlexDataGridColumnSizeMode.lastFill:
        return column.minWidth ??
            defaultMinWidth +
                (groupingEnabled && column.groupable ? groupIconExtra : 0);
      case PlexDataGridColumnSizeMode.header:
        return _clampWidth(
          measureHeaderWidth(
            column.title,
            sortable: column.sortable,
            groupable: groupingEnabled && column.groupable,
          ),
          column,
          autoCaps: true,
        );
      case PlexDataGridColumnSizeMode.cells:
        return _clampWidth(
          _maxCellWidth(column, pageRows, rowStyle),
          column,
          autoCaps: true,
        );
      case PlexDataGridColumnSizeMode.auto:
        return _clampWidth(
          math.max(
            measureHeaderWidth(
              column.title,
              sortable: column.sortable,
              groupable: groupingEnabled && column.groupable,
            ),
            _maxCellWidth(column, pageRows, rowStyle),
          ),
          column,
          autoCaps: true,
        );
    }
  }

  /// Body slot widths (optional leading checkbox + each data column).
  ///
  /// [viewportWidth] is the grid body width. Selection checkbox uses
  /// [selectColumnWidth] (44) and is subtracted before fill / lastFill.
  /// If non-fill columns exceed the viewport, fill / lastFill stay at their
  /// minimum and the grid scrolls horizontally.
  List<double> resolveColumnWidths<T>({
    required List<PlexDataGridColumn<T>> columns,
    required List<T> pageRows,
    required PlexDataGridColumnSizeMode gridColumnSizeMode,
    required double viewportWidth,
    bool selectable = false,
    bool groupingEnabled = false,
    PlexDataGridCellStyle? Function(T row)? rowStyle,
  }) {
    final List<double> colWidths = <double>[
      for (final PlexDataGridColumn<T> column in columns)
        columnIntrinsicWidth(
          column: column,
          pageRows: pageRows,
          gridColumnSizeMode: gridColumnSizeMode,
          rowStyle: rowStyle,
          groupingEnabled: groupingEnabled,
        ),
    ];
    final List<double> maxes = <double>[
      for (final PlexDataGridColumn<T> column in columns)
        column.maxWidth ?? double.infinity,
    ];
    final List<double> flexes = <double>[
      for (final PlexDataGridColumn<T> column in columns)
        column.flex < 0 ? 0.0 : column.flex,
    ];
    final List<int> fillIdx = <int>[];
    final List<int> lastFillIdx = <int>[];
    for (int i = 0; i < columns.length; i++) {
      final PlexDataGridColumnSizeMode mode =
          columns[i].sizeMode ?? gridColumnSizeMode;
      if (mode == PlexDataGridColumnSizeMode.fill) {
        fillIdx.add(i);
      } else if (mode == PlexDataGridColumnSizeMode.lastFill) {
        lastFillIdx.add(i);
      }
    }

    double used = (selectable ? selectColumnWidth : 0) +
        colWidths.fold<double>(0, (double s, double w) => s + w);
    double leftover =
        viewportWidth.isFinite ? math.max(0.0, viewportWidth - used) : 0.0;
    if (leftover > 0) {
      _distribute(fillIdx, colWidths, maxes, flexes, leftover);
      used = (selectable ? selectColumnWidth : 0) +
          colWidths.fold<double>(0, (double s, double w) => s + w);
      leftover =
          viewportWidth.isFinite ? math.max(0.0, viewportWidth - used) : 0.0;
      if (leftover > 0 && lastFillIdx.isNotEmpty) {
        _distribute(
          <int>[lastFillIdx.last],
          colWidths,
          maxes,
          flexes,
          leftover,
        );
      }
    }
    return <double>[
      if (selectable) selectColumnWidth,
      ...colWidths,
    ];
  }

  /// Data-row height: density when every column is [PlexDataGridRowSizeMode.fixed],
  /// otherwise max(density, wrapped default-text heights) for auto columns.
  double resolveRowHeight<T>({
    required T row,
    required List<PlexDataGridColumn<T>> columns,
    required List<double> columnWidths,
    required PlexDensity density,
    required PlexDataGridRowSizeMode gridRowSizeMode,
    PlexDataGridCellStyle? Function(T row)? rowStyle,
    bool selectable = false,
  }) {
    final double minH = densityRowHeight(density);
    int widthIndex = selectable ? 1 : 0;
    double height = minH;
    bool anyAuto = false;
    for (final PlexDataGridColumn<T> column in columns) {
      final double colW = columnWidths[widthIndex++];
      if ((column.rowSizeMode ?? gridRowSizeMode) !=
          PlexDataGridRowSizeMode.auto) {
        continue;
      }
      anyAuto = true;
      final PlexDataGridCellStyle? merged =
          _mergedStyle(column, row, rowStyle);
      final String text = column.value(row)?.toString() ?? '';
      final double maxW = math.max(0.0, colW - horizontalPadding);
      height = math.max(
        height,
        measureCellHeight(
          text,
          maxWidth: maxW,
          numeric: column.numeric,
          fontSize: merged?.fontSize,
          fontWeight: merged?.fontWeight,
        ),
      );
    }
    return anyAuto ? height : minH;
  }

  /// Header row height. [PlexDataGridRowSizeMode.auto] wraps the uppercase
  /// title and grows from the density header height.
  double resolveHeaderHeight<T>({
    required List<PlexDataGridColumn<T>> columns,
    required List<double> columnWidths,
    required PlexDensity density,
    required PlexDataGridRowSizeMode headerRowSizeMode,
    bool selectable = false,
  }) {
    final double minH = densityHeaderHeight(density);
    if (headerRowSizeMode != PlexDataGridRowSizeMode.auto) return minH;
    double height = minH;
    int widthIndex = selectable ? 1 : 0;
    for (final PlexDataGridColumn<T> column in columns) {
      final double colW = columnWidths[widthIndex++];
      final double extra = (column.sortable ? sortIconExtra : 0) +
          (column.groupable ? groupIconExtra : 0);
      final double maxW = math.max(0.0, colW - horizontalPadding - extra);
      height = math.max(
        height,
        _measure(
          text: column.title.toUpperCase(),
          fontSize: PlexFontSize.small,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05 * PlexFontSize.small,
          maxWidth: maxW,
        ).height,
      );
    }
    return height;
  }

  bool columnsUseFixedRowHeight<T>(
    List<PlexDataGridColumn<T>> columns,
    PlexDataGridRowSizeMode gridRowSizeMode,
  ) {
    for (final PlexDataGridColumn<T> column in columns) {
      if ((column.rowSizeMode ?? gridRowSizeMode) ==
          PlexDataGridRowSizeMode.auto) {
        return false;
      }
    }
    return true;
  }

  double _maxCellWidth<T>(
    PlexDataGridColumn<T> column,
    List<T> pageRows,
    PlexDataGridCellStyle? Function(T row)? rowStyle,
  ) {
    double maxW = 0;
    for (final T row in pageRows) {
      final PlexDataGridCellStyle? merged =
          _mergedStyle(column, row, rowStyle);
      final String text = column.value(row)?.toString() ?? '';
      maxW = math.max(
        maxW,
        measureCellWidth(
          text,
          numeric: column.numeric,
          fontSize: merged?.fontSize,
          fontWeight: merged?.fontWeight,
        ),
      );
    }
    return maxW;
  }

  PlexDataGridCellStyle? _mergedStyle<T>(
    PlexDataGridColumn<T> column,
    T row,
    PlexDataGridCellStyle? Function(T row)? rowStyle,
  ) {
    final PlexDataGridCellStyle? base = rowStyle?.call(row);
    final PlexDataGridCellStyle? cell = column.cellStyle?.call(row);
    if (base == null) return cell;
    return base.merge(cell);
  }

  double _clampWidth<T>(
    double width,
    PlexDataGridColumn<T> column, {
    required bool autoCaps,
  }) {
    final double minW =
        column.minWidth ?? (autoCaps ? defaultMinWidth : 0);
    final double maxW =
        column.maxWidth ?? (autoCaps ? defaultMaxWidth : double.infinity);
    if (maxW < minW) return minW;
    return width.clamp(minW, maxW);
  }

  void _distribute(
    List<int> indices,
    List<double> widths,
    List<double> maxes,
    List<double> flexes,
    double leftover,
  ) {
    if (indices.isEmpty || leftover <= 0) return;
    final List<int> growing = List<int>.from(indices);
    double remaining = leftover;
    while (remaining > 0.01 && growing.isNotEmpty) {
      final double flexSum =
          growing.fold<double>(0, (double s, int i) => s + flexes[i]);
      if (flexSum <= 0) break;
      final double perFlex = remaining / flexSum;
      double used = 0;
      final List<int> saturated = <int>[];
      for (final int i in growing) {
        final double add = perFlex * flexes[i];
        final double room = maxes[i] - widths[i];
        if (room <= 0) {
          saturated.add(i);
          continue;
        }
        final double take = math.min(add, room);
        widths[i] += take;
        used += take;
        if (take >= room - 0.01) saturated.add(i);
      }
      remaining -= used;
      growing.removeWhere(saturated.contains);
      if (used < 0.01) break;
    }
  }

  Size _measure({
    required String text,
    required double fontSize,
    FontWeight? fontWeight,
    double letterSpacing = 0,
    bool tabular = false,
    double maxWidth = double.infinity,
    String? fontFamily,
  }) {
    final String family = fontFamily ?? this.fontFamily;
    final Object key = Object.hash(
      text,
      fontSize,
      fontWeight?.index,
      letterSpacing,
      tabular,
      maxWidth,
      family,
    );
    final Size? cached = _cache[key];
    if (cached != null) return cached;
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: family,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing == 0 ? null : letterSpacing,
          fontFeatures: tabular
              ? const <FontFeature>[FontFeature.tabularFigures()]
              : null,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: maxWidth);
    final Size size = Size(painter.width, painter.height);
    painter.dispose();
    _cache[key] = size;
    return size;
  }
}

/// How a per-column filter compares the typed query to cell text.
enum PlexDataGridFilterMatch {
  contains,
  equals,
  startsWith,
  greaterThan,
  lessThan,
}

/// Active filter for one [PlexDataGrid] column.
class PlexDataGridColumnFilter {
  const PlexDataGridColumnFilter({
    required this.columnId,
    required this.query,
    this.match = PlexDataGridFilterMatch.contains,
  });

  final String columnId;
  final String query;
  final PlexDataGridFilterMatch match;
}

/// One group produced by [PlexDataGridEngine.group] / [PlexDataGridEngine.groupBy].
///
/// [rows] is every descendant leaf row in this group (not only the immediate
/// children). Nested grouping fills [children]; [depth] is 0 for top-level
/// groups. [columnId] / [value] identify the column this group was bucketed on.
class PlexDataGridGroup<T> {
  const PlexDataGridGroup({
    required this.key,
    required this.rows,
    this.columnId,
    this.value,
    this.depth = 0,
    this.children = const [],
  });

  /// Unique expand/collapse id. Nested groups use a path (`parent/col:value`).
  final String key;

  /// Column this group was created from. Null for legacy [PlexDataGridEngine.group] results.
  final String? columnId;

  /// Raw grouped cell value. Caption uses this when set; otherwise [key].
  final Object? value;
  final int depth;

  /// All descendant leaf rows in this group.
  final List<T> rows;
  final List<PlexDataGridGroup<T>> children;
}

/// One cell in a group summary row.
class PlexDataGridSummaryCell {
  const PlexDataGridSummaryCell({
    required this.columnId,
    this.text,
    this.child,
  });

  final String columnId;
  final String? text;
  final Widget? child;
}

/// Structured group summary. Return `null` to keep the default count/sum row.
/// [PlexDataGridGroup.rows] is all descendant leaf rows in that group.
typedef PlexDataGridGroupSummary<T> = List<PlexDataGridSummaryCell>? Function(
  PlexDataGridGroup<T> group,
);

/// Optional custom summary widget. Used when [PlexDataGrid.groupSummary] is
/// null or returns null. Return `null` to keep the default.
typedef PlexDataGridGroupSummaryBuilder<T> = Widget? Function(
  BuildContext context,
  PlexDataGridGroup<T> group,
);

/// Flattened body line: a group header, summary, or a data row.
class PlexDataGridLine<T> {
  const PlexDataGridLine.data(this.row)
      : isGroup = false,
        isSummary = false,
        groupKey = null,
        groupCaption = null,
        groupCount = null,
        groupExpanded = false,
        groupDepth = 0,
        group = null;

  const PlexDataGridLine.group({
    required this.groupKey,
    required this.groupCaption,
    required this.groupCount,
    required this.groupExpanded,
    this.groupDepth = 0,
    this.group,
  })  : isGroup = true,
        isSummary = false,
        row = null;

  const PlexDataGridLine.summary({
    required this.groupKey,
    this.groupDepth = 0,
    this.group,
  })  : isGroup = false,
        isSummary = true,
        row = null,
        groupCaption = null,
        groupCount = null,
        groupExpanded = false;

  final bool isGroup;
  final bool isSummary;
  final T? row;
  final String? groupKey;
  final String? groupCaption;
  final int? groupCount;
  final bool groupExpanded;
  final int groupDepth;
  final PlexDataGridGroup<T>? group;
}

/// Pure client-side search, filter, sort, group, and export helpers.
class PlexDataGridEngine {
  PlexDataGridEngine._();

  static int compareValues(Object? a, Object? b) {
    if (identical(a, b)) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    if (a is num && b is num) return a.compareTo(b);
    if (a is DateTime && b is DateTime) return a.compareTo(b);
    if (a is Comparable && b is Comparable && a.runtimeType == b.runtimeType) {
      return a.compareTo(b);
    }
    return a.toString().toLowerCase().compareTo(b.toString().toLowerCase());
  }

  static List<T> search<T>(
    List<T> rows,
    List<PlexDataGridColumn<T>> columns,
    String query,
  ) {
    final String needle = query.trim().toLowerCase();
    if (needle.isEmpty) return List<T>.from(rows);
    return rows.where((T row) {
      for (final PlexDataGridColumn<T> column in columns) {
        if (!column.searchable) continue;
        final Object? value = column.value(row);
        if ((value?.toString() ?? '').toLowerCase().contains(needle)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  static List<T> filter<T>(
    List<T> rows,
    List<PlexDataGridColumn<T>> columns,
    Map<String, PlexDataGridColumnFilter> filters,
  ) {
    if (filters.isEmpty) return List<T>.from(rows);
    return rows.where((T row) {
      for (final PlexDataGridColumnFilter filter in filters.values) {
        if (filter.query.trim().isEmpty) continue;
        final int columnIndex = columns
            .indexWhere((PlexDataGridColumn<T> c) => c.id == filter.columnId);
        if (columnIndex < 0) continue;
        final PlexDataGridColumn<T> column = columns[columnIndex];
        if (!column.filterable) continue;
        final Object? raw = column.value(row);
        final String text = (raw?.toString() ?? '').toLowerCase();
        final String needle = filter.query.trim().toLowerCase();
        final bool matches = _matchesFilter(filter.match, raw, text, needle);
        if (!matches) return false;
      }
      return true;
    }).toList();
  }

  static List<T> sort<T>(
    List<T> rows,
    List<PlexDataGridColumn<T>> columns,
    PlexDataGridSort? sort,
  ) {
    final List<T> copy = List<T>.from(rows);
    if (sort == null) return copy;
    final int columnIndex =
        columns.indexWhere((PlexDataGridColumn<T> c) => c.id == sort.columnId);
    if (columnIndex < 0) return copy;
    final PlexDataGridColumn<T> column = columns[columnIndex];
    copy.sort((T a, T b) {
      final int compared = compareValues(column.value(a), column.value(b));
      return sort.direction == PlexDataGridSortDirection.ascending
          ? compared
          : -compared;
    });
    return copy;
  }

  static bool _matchesFilter(
    PlexDataGridFilterMatch match,
    Object? raw,
    String text,
    String needle,
  ) {
    switch (match) {
      case PlexDataGridFilterMatch.equals:
        return text == needle;
      case PlexDataGridFilterMatch.startsWith:
        return text.startsWith(needle);
      case PlexDataGridFilterMatch.greaterThan:
      case PlexDataGridFilterMatch.lessThan:
        final num? cellNum = num.tryParse(text);
        final num? queryNum = num.tryParse(needle);
        if (cellNum != null && queryNum != null) {
          return match == PlexDataGridFilterMatch.greaterThan
              ? cellNum > queryNum
              : cellNum < queryNum;
        }
        final Object? rhs = queryNum ?? needle;
        final int compared = compareValues(raw, rhs);
        return match == PlexDataGridFilterMatch.greaterThan
            ? compared > 0
            : compared < 0;
      case PlexDataGridFilterMatch.contains:
        return text.contains(needle);
    }
  }

  static List<PlexDataGridGroup<T>> group<T>(
    List<T> rows,
    PlexDataGridColumn<T> column, {
    int depth = 0,
    String parentKey = '',
  }) {
    return groupBy(rows, <PlexDataGridColumn<T>>[column],
        depth: depth, parentKey: parentKey);
  }

  /// Nested grouping. [columns] order is nest order (first id is the outer group).
  /// Each group's [PlexDataGridGroup.rows] is all descendant leaf rows.
  static List<PlexDataGridGroup<T>> groupBy<T>(
    List<T> rows,
    List<PlexDataGridColumn<T>> columns, {
    int depth = 0,
    String parentKey = '',
  }) {
    if (columns.isEmpty) return <PlexDataGridGroup<T>>[];
    final PlexDataGridColumn<T> column = columns.first;
    final Map<String, List<T>> buckets = <String, List<T>>{};
    final List<String> order = <String>[];
    for (final T row in rows) {
      final String key = column.value(row)?.toString() ?? '';
      if (!buckets.containsKey(key)) {
        order.add(key);
        buckets[key] = <T>[];
      }
      buckets[key]!.add(row);
    }
    final List<PlexDataGridColumn<T>> rest = columns.sublist(1);
    return <PlexDataGridGroup<T>>[
      for (final String key in order)
        () {
          final List<T> leafRows = buckets[key]!;
          final String groupKey =
              parentKey.isEmpty ? key : '$parentKey/${column.id}:$key';
          return PlexDataGridGroup<T>(
            key: groupKey,
            columnId: column.id,
            value: key,
            depth: depth,
            rows: leafRows,
            children: rest.isEmpty
                ? const []
                : groupBy(
                    leafRows,
                    rest,
                    depth: depth + 1,
                    parentKey: groupKey,
                  ),
          );
        }(),
    ];
  }

  static String defaultGroupCaption(String key, int count) {
    final String label = key.isEmpty ? '(blank)' : key;
    return '$label ($count)';
  }

  static String formatSummaryNumber(num value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  /// Count of leaf rows, plus sum for each [PlexDataGridColumn.numeric] column.
  static List<PlexDataGridSummaryCell> defaultGroupSummary<T>(
    PlexDataGridGroup<T> group,
    List<PlexDataGridColumn<T>> columns,
  ) {
    final int count = group.rows.length;
    bool wroteCount = false;
    final List<PlexDataGridSummaryCell> cells = <PlexDataGridSummaryCell>[];
    for (final PlexDataGridColumn<T> column in columns) {
      if (column.numeric) {
        num sum = 0;
        int n = 0;
        for (final T row in group.rows) {
          final Object? value = column.value(row);
          if (value is num) {
            sum += value;
            n++;
          }
        }
        final String sumText = n == 0 ? '' : 'Sum ${formatSummaryNumber(sum)}';
        String text = sumText;
        if (!wroteCount) {
          text = '$count items${sumText.isEmpty ? '' : ' · $sumText'}';
          wroteCount = true;
        }
        cells.add(PlexDataGridSummaryCell(columnId: column.id, text: text));
      } else if (!wroteCount) {
        cells.add(
          PlexDataGridSummaryCell(
            columnId: column.id,
            text: '$count items',
          ),
        );
        wroteCount = true;
      }
    }
    return cells;
  }

  static List<PlexDataGridLine<T>> flatten<T>(
    List<PlexDataGridGroup<T>> groups, {
    required String Function(PlexDataGridGroup<T> group) caption,
    required bool Function(String key) isExpanded,
    bool showSummaries = false,
  }) {
    final List<PlexDataGridLine<T>> lines = <PlexDataGridLine<T>>[];
    void walk(List<PlexDataGridGroup<T>> nodes) {
      for (final PlexDataGridGroup<T> group in nodes) {
        final bool expanded = isExpanded(group.key);
        lines.add(
          PlexDataGridLine<T>.group(
            groupKey: group.key,
            groupCaption: caption(group),
            groupCount: group.rows.length,
            groupExpanded: expanded,
            groupDepth: group.depth,
            group: group,
          ),
        );
        if (!expanded) continue;
        if (group.children.isNotEmpty) {
          walk(group.children);
        } else {
          for (final T row in group.rows) {
            lines.add(PlexDataGridLine<T>.data(row));
          }
        }
        if (showSummaries) {
          lines.add(
            PlexDataGridLine<T>.summary(
              groupKey: group.key,
              groupDepth: group.depth,
              group: group,
            ),
          );
        }
      }
    }

    walk(groups);
    return lines;
  }

  static List<dynamic> exportHeaders<T>(List<PlexDataGridColumn<T>> columns) {
    return columns.map((PlexDataGridColumn<T> c) => c.title).toList();
  }

  static List<List<dynamic>> exportMatrix<T>(
    List<PlexDataGridColumn<T>> columns,
    List<T> rows,
  ) {
    return rows
        .map(
          (T row) => columns
              .map((PlexDataGridColumn<T> c) => c.value(row) ?? '')
              .toList(),
        )
        .toList();
  }

  static String csv<T>(List<PlexDataGridColumn<T>> columns, List<T> rows) {
    return PlexPrinter.buildCsv(
        exportHeaders(columns), exportMatrix(columns, rows));
  }
}

/// Plex-owned data grid. Client-side sort, search, per-column filter,
/// grouping, selection, pagination, and CSV / Excel / PDF export.
///
/// [PlexAdvanceDataTable] is a deprecated compatibility wrapper around
/// this widget. Prefer [PlexDataGrid] for new call sites.
///
/// Header tap on a [PlexDataGridColumn.sortable] column cycles ascending →
/// descending → unsorted (single-column sort).
///
/// Optional [PlexDataGridColumn.cell] replaces default text with any widget
/// (buttons, badges). Sort, filter, and export still use
/// [PlexDataGridColumn.value]. [rowStyle] and [PlexDataGridColumn.cellStyle]
/// style default text cells; [cellStyle] wins per column. Conditions are
/// ordinary Dart in those callbacks (`if (row.status == 'late')`).
class PlexDataGrid<T> extends StatefulWidget {
  const PlexDataGrid({
    super.key,
    required this.columns,
    required this.rows,
    this.title,
    this.subtitle,
    this.actions,
    this.density,
    this.selectionMode = PlexDataGridSelectionMode.none,
    this.onSelectionChanged,
    this.onSort,
    this.onSearch,
    this.onRowTap,
    this.rowId,
    this.pageSize = 25,
    this.pageSizeOptions = const <int>[10, 25, 50, 100],
    this.loading = false,
    this.emptyTitle = 'No rows to show',
    this.emptyMessage = 'Try clearing a filter or widening your search.',
    this.empty,
    this.showToolbar = true,
    this.showSearch = true,
    this.showDensityToggle = true,
    this.showFooter = true,
    this.height,
    this.enableCsvExport = true,
    this.enableExcelExport = true,
    this.enablePdfExport = true,
    this.showColumnFilters = false,
    this.enableGrouping = true,
    this.groupByColumnId,
    this.groupByColumnIds,
    this.autoExpandGroups = true,
    this.groupCaption,
    this.onGroupChanged,
    this.showGroupSummaries = true,
    this.groupSummary,
    this.groupSummaryBuilder,
    this.rowStyle,
    this.frozenColumnCount = 0,
    this.frozenRowCount = 0,
    this.columnSizeMode = PlexDataGridColumnSizeMode.fixed,
    this.rowSizeMode = PlexDataGridRowSizeMode.fixed,
    this.headerRowSizeMode = PlexDataGridRowSizeMode.fixed,
    this.onCellEdited,
    this.applyCellEdit,
    this.onRowsChanged,
  }) : assert(pageSize > 0, 'pageSize must be greater than 0');

  final List<PlexDataGridColumn<T>> columns;
  final List<T> rows;
  final String? title;
  final String? subtitle;
  final Widget? actions;

  /// Override for this grid. When null, uses [PlexThemeData.density].
  final PlexDensity? density;

  final PlexDataGridSelectionMode selectionMode;
  final ValueChanged<List<T>>? onSelectionChanged;
  final ValueChanged<PlexDataGridSort?>? onSort;
  final ValueChanged<String>? onSearch;
  final ValueChanged<T>? onRowTap;

  /// Stable row identity. Defaults to [identityHashCode].
  final Object Function(T row)? rowId;

  final int pageSize;
  final List<int> pageSizeOptions;
  final bool loading;
  final String emptyTitle;
  final String emptyMessage;
  final Widget? empty;
  final bool showToolbar;
  final bool showSearch;
  final bool showDensityToggle;
  final bool showFooter;
  final double? height;

  /// Toolbar CSV button. Default `true`.
  final bool enableCsvExport;

  /// Toolbar Excel button. Default `true`.
  final bool enableExcelExport;

  /// Toolbar PDF button. Default `true`.
  final bool enablePdfExport;

  /// Shows a filter row under the header (contains / equals per [PlexDataGridColumn.filterable] column).
  final bool showColumnFilters;

  /// Shows a group-by control in the toolbar. Default `true`. Users can
  /// add/remove grouping columns (header action and toolbar chips). Order of
  /// ids is nest order.
  final bool enableGrouping;

  /// Convenience for a single grouping column. Maps to a one-item
  /// [groupByColumnIds] list when [groupByColumnIds] is omitted.
  final String? groupByColumnId;

  /// Initial (and parent-controlled) grouping column ids. Empty / omitted
  /// with a null [groupByColumnId] means no grouping. First id is the outer
  /// group.
  final List<String>? groupByColumnIds;

  /// When true, groups start expanded. Default `true`.
  final bool autoExpandGroups;

  /// Caption for a group header. Defaults to `"key (count)"`.
  final String Function(
      Object? key, List<T> rows, PlexDataGridColumn<T> column)? groupCaption;

  /// Called with the full grouping column-id list. Empty list means no grouping.
  final ValueChanged<List<String>>? onGroupChanged;

  /// Initial visibility of per-group summary rows. Default `true`. The user
  /// can toggle this from the toolbar; that choice lives in widget state.
  final bool showGroupSummaries;

  /// Structured summary cells for a group. Return `null` to keep the default
  /// (count plus numeric sums). [PlexDataGridGroup.rows] is all descendant
  /// leaf rows in that group.
  final PlexDataGridGroupSummary<T>? groupSummary;

  /// Custom summary widget. Used when [groupSummary] is null or returns null.
  /// Return `null` to keep the default.
  final PlexDataGridGroupSummaryBuilder<T>? groupSummaryBuilder;

  /// Style applied to every default text cell in the row.
  final PlexDataGridCellStyle? Function(T row)? rowStyle;

  /// Leading data columns that stay put while the rest scroll horizontally.
  /// The selection checkbox is always frozen when present. `0` keeps the
  /// single-scroll layout.
  final int frozenColumnCount;

  /// First N data rows of the current page (after sort/filter/paging) that
  /// stay visible while the rest of the page scrolls vertically. The header
  /// is already frozen. `0` keeps the current layout. Combined with
  /// [frozenColumnCount] this forms a 2×2 freeze pane (top-left locked,
  /// top-right scroll-x, bottom-left scroll-y, bottom-right both).
  final int frozenRowCount;

  /// Default column width mode. Columns may override with
  /// [PlexDataGridColumn.sizeMode].
  final PlexDataGridColumnSizeMode columnSizeMode;

  /// Default data-row height mode. Columns may override with
  /// [PlexDataGridColumn.rowSizeMode].
  final PlexDataGridRowSizeMode rowSizeMode;

  /// Header label wrap / height. Independent of [rowSizeMode].
  final PlexDataGridRowSizeMode headerRowSizeMode;

  /// Fired after an editable default text cell is submitted.
  /// Does not rewrite [rows] unless [applyCellEdit] is also set.
  final void Function(T row, String columnId, String newValue)? onCellEdited;

  /// Maps a row to an updated row after an in-place edit. If null, the grid
  /// does not rewrite [rows].
  ///
  /// When set, the grid replaces that item in an internal working copy so
  /// the new value shows even if the parent is Stateless and ignores
  /// [onRowsChanged]. A parent rebuild that passes a new [rows] list (not
  /// [identical] to the previous) replaces that copy with [rows] again.
  final T Function(T row, String columnId, String newValue)? applyCellEdit;

  /// Fired with the full row list after [applyCellEdit] (same order as
  /// [rows], edited index replaced).
  final ValueChanged<List<T>>? onRowsChanged;

  @override
  State<PlexDataGrid<T>> createState() => _PlexDataGridState<T>();
}

class _PlexDataGridState<T> extends State<PlexDataGrid<T>> {
  static const double _filterRowHeight = 36;

  final TextEditingController _searchController = TextEditingController();
  final Map<String, TextEditingController> _filterControllers =
      <String, TextEditingController>{};
  final Set<Object> _selectedIds = <Object>{};
  final Map<String, PlexDataGridColumnFilter> _columnFilters =
      <String, PlexDataGridColumnFilter>{};
  final Map<String, PlexDataGridFilterMatch> _filterMatch =
      <String, PlexDataGridFilterMatch>{};
  final Map<String, bool> _groupExpanded = <String, bool>{};

  String _search = '';
  PlexDataGridSort? _sort;
  int _pageIndex = 0;
  late int _pageSize;
  PlexDensity? _densityOverride;
  late List<String> _groupByColumnIds;
  late bool _showGroupSummaries;
  late List<T> _workingRows;
  final ScrollController _frozenVertical = ScrollController();
  final ScrollController _scrollVertical = ScrollController();
  bool _syncingVertical = false;

  @override
  void initState() {
    super.initState();
    _pageSize = widget.pageSize;
    _densityOverride = widget.density;
    _groupByColumnIds = _resolveGroupByColumnIds();
    _showGroupSummaries = widget.showGroupSummaries;
    _workingRows = List<T>.from(widget.rows);
    _frozenVertical.addListener(() => _syncVertical(_frozenVertical, _scrollVertical));
    _scrollVertical.addListener(() => _syncVertical(_scrollVertical, _frozenVertical));
  }

  void _syncVertical(ScrollController source, ScrollController target) {
    if (_syncingVertical || !source.hasClients || !target.hasClients) return;
    if ((target.offset - source.offset).abs() <= 0.5) return;
    _syncingVertical = true;
    target.jumpTo(source.offset.clamp(0.0, target.position.maxScrollExtent));
    _syncingVertical = false;
  }

  @override
  void didUpdateWidget(covariant PlexDataGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageSize != widget.pageSize) {
      _pageSize = widget.pageSize;
      _pageIndex = 0;
    }
    if (oldWidget.density != widget.density) {
      _densityOverride = widget.density;
    }
    if (!identical(oldWidget.rows, widget.rows)) {
      _workingRows = List<T>.from(widget.rows);
      _pruneSelection();
    }
    if (!_listEquals(oldWidget.groupByColumnIds, widget.groupByColumnIds) ||
        oldWidget.groupByColumnId != widget.groupByColumnId) {
      _groupByColumnIds = _resolveGroupByColumnIds();
      _groupExpanded.clear();
      _pageIndex = 0;
    }
    if (oldWidget.showGroupSummaries != widget.showGroupSummaries) {
      _showGroupSummaries = widget.showGroupSummaries;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _frozenVertical.dispose();
    _scrollVertical.dispose();
    for (final TextEditingController controller in _filterControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Object _idFor(T row) => widget.rowId?.call(row) ?? identityHashCode(row);

  PlexDensity _resolvedDensity(PlexThemeData theme) {
    return _densityOverride ?? widget.density ?? theme.density;
  }

  double _rowHeight(PlexDensity density) {
    return density == PlexDensity.compact ? 34 : 44;
  }

  bool get _selectable =>
      widget.selectionMode != PlexDataGridSelectionMode.none;

  List<T> _filteredRows() {
    return PlexDataGridEngine.filter(
      PlexDataGridEngine.search(_workingRows, widget.columns, _search),
      widget.columns,
      _columnFilters,
    );
  }

  List<T> _sortedRows(List<T> rows) {
    return PlexDataGridEngine.sort(rows, widget.columns, _sort);
  }

  List<T> _exportRows() => _sortedRows(_filteredRows());

  static bool _listEquals(List<String>? a, List<String>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  List<String> _resolveGroupByColumnIds() {
    if (widget.groupByColumnIds != null) {
      return List<String>.from(widget.groupByColumnIds!);
    }
    if (widget.groupByColumnId != null && widget.groupByColumnId!.isNotEmpty) {
      return <String>[widget.groupByColumnId!];
    }
    return <String>[];
  }

  List<PlexDataGridColumn<T>> _groupColumns() {
    final List<PlexDataGridColumn<T>> columns = <PlexDataGridColumn<T>>[];
    for (final String id in _groupByColumnIds) {
      for (final PlexDataGridColumn<T> column in widget.columns) {
        if (column.id == id) {
          columns.add(column);
          break;
        }
      }
    }
    return columns;
  }

  PlexDataGridColumn<T>? _columnById(String? id) {
    if (id == null) return null;
    for (final PlexDataGridColumn<T> column in widget.columns) {
      if (column.id == id) return column;
    }
    return null;
  }

  bool _isGroupExpanded(String key) {
    return _groupExpanded[key] ?? widget.autoExpandGroups;
  }

  Object? _groupDisplayKey(PlexDataGridGroup<T> group) {
    return group.value ?? group.key;
  }

  String _groupCaption(PlexDataGridGroup<T> group) {
    final PlexDataGridColumn<T>? column = _columnById(group.columnId) ??
        (_groupColumns().isEmpty ? null : _groupColumns().first);
    final Object? display = _groupDisplayKey(group);
    if (widget.groupCaption != null && column != null) {
      return widget.groupCaption!(display, group.rows, column);
    }
    return PlexDataGridEngine.defaultGroupCaption(
      display?.toString() ?? '',
      group.rows.length,
    );
  }

  List<PlexDataGridLine<T>> _visibleLines() {
    final List<T> rows = _exportRows();
    final List<PlexDataGridColumn<T>> groupColumns = _groupColumns();
    if (groupColumns.isEmpty) {
      return <PlexDataGridLine<T>>[
        for (final T row in rows) PlexDataGridLine<T>.data(row),
      ];
    }
    final List<PlexDataGridGroup<T>> groups =
        PlexDataGridEngine.groupBy(rows, groupColumns);
    return PlexDataGridEngine.flatten(
      groups,
      caption: _groupCaption,
      isExpanded: _isGroupExpanded,
      showSummaries: _showGroupSummaries,
    );
  }

  bool get _showFilterRow =>
      widget.showColumnFilters &&
      widget.columns.any((PlexDataGridColumn<T> c) => c.filterable);

  TextEditingController _filterControllerFor(String columnId) {
    return _filterControllers.putIfAbsent(
      columnId,
      () => TextEditingController(
        text: _columnFilters[columnId]?.query ?? '',
      ),
    );
  }

  PlexDataGridFilterMatch _matchFor(String columnId) {
    return _filterMatch[columnId] ?? PlexDataGridFilterMatch.contains;
  }

  void _onColumnFilterChanged(String columnId, String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _columnFilters.remove(columnId);
      } else {
        _columnFilters[columnId] = PlexDataGridColumnFilter(
          columnId: columnId,
          query: query,
          match: _matchFor(columnId),
        );
      }
      _pageIndex = 0;
    });
  }

  static const List<PlexDataGridFilterMatch> _matchCycle =
      <PlexDataGridFilterMatch>[
    PlexDataGridFilterMatch.contains,
    PlexDataGridFilterMatch.equals,
    PlexDataGridFilterMatch.startsWith,
    PlexDataGridFilterMatch.greaterThan,
    PlexDataGridFilterMatch.lessThan,
  ];

  String _matchTooltip(PlexDataGridFilterMatch match) {
    switch (match) {
      case PlexDataGridFilterMatch.equals:
        return 'Match: equals';
      case PlexDataGridFilterMatch.startsWith:
        return 'Match: starts with';
      case PlexDataGridFilterMatch.greaterThan:
        return 'Match: greater than';
      case PlexDataGridFilterMatch.lessThan:
        return 'Match: less than';
      case PlexDataGridFilterMatch.contains:
        return 'Match: contains';
    }
  }

  IconData _matchIcon(PlexDataGridFilterMatch match) {
    switch (match) {
      case PlexDataGridFilterMatch.equals:
        return Icons.drag_handle;
      case PlexDataGridFilterMatch.startsWith:
        return Icons.short_text;
      case PlexDataGridFilterMatch.greaterThan:
        return Icons.keyboard_arrow_up;
      case PlexDataGridFilterMatch.lessThan:
        return Icons.keyboard_arrow_down;
      case PlexDataGridFilterMatch.contains:
        return Icons.filter_alt;
    }
  }

  void _toggleFilterMatch(String columnId) {
    setState(() {
      final int i = _matchCycle.indexOf(_matchFor(columnId));
      final PlexDataGridFilterMatch next =
          _matchCycle[(i < 0 ? 0 : i + 1) % _matchCycle.length];
      _filterMatch[columnId] = next;
      final PlexDataGridColumnFilter? existing = _columnFilters[columnId];
      if (existing != null) {
        _columnFilters[columnId] = PlexDataGridColumnFilter(
          columnId: columnId,
          query: existing.query,
          match: next,
        );
      }
    });
  }

  void _toggleGroup(String key) {
    setState(() {
      _groupExpanded[key] = !_isGroupExpanded(key);
    });
  }

  void _setGroupByColumnIds(List<String> ids) {
    setState(() {
      _groupByColumnIds = List<String>.from(ids);
      _groupExpanded.clear();
      _pageIndex = 0;
    });
    widget.onGroupChanged?.call(List<String>.unmodifiable(_groupByColumnIds));
  }

  void _addGroupColumn(String? id) {
    if (id == null || id.isEmpty) return;
    if (_groupByColumnIds.contains(id)) return;
    _setGroupByColumnIds(<String>[..._groupByColumnIds, id]);
  }

  void _removeGroupColumn(String id) {
    _setGroupByColumnIds(
      _groupByColumnIds.where((String existing) => existing != id).toList(),
    );
  }

  void _toggleGroupColumn(String id) {
    if (_groupByColumnIds.contains(id)) {
      _removeGroupColumn(id);
    } else {
      _addGroupColumn(id);
    }
  }

  void _toggleSummaries() {
    setState(() => _showGroupSummaries = !_showGroupSummaries);
  }

  List<PlexDataGridColumn<T>> _remainingGroupableColumns() {
    return widget.columns
        .where(
          (PlexDataGridColumn<T> column) =>
              column.groupable && !_groupByColumnIds.contains(column.id),
        )
        .toList();
  }

  String get _exportTitle => widget.title ?? 'Data';

  Future<void> _exportCsv() async {
    await _runExport(() {
      return PlexPrinter.printCsv(
        _exportTitle,
        PlexDataGridEngine.exportHeaders(widget.columns),
        PlexDataGridEngine.exportMatrix(widget.columns, _exportRows()),
      );
    });
  }

  Future<void> _exportExcel() async {
    await _runExport(() {
      return PlexPrinter.printExcel(
        _exportTitle,
        PlexDataGridEngine.exportHeaders(widget.columns),
        PlexDataGridEngine.exportMatrix(widget.columns, _exportRows()),
      );
    });
  }

  Future<void> _exportPdf() async {
    await _runExport(() {
      return PlexPrinter.printPdf(
        _exportTitle,
        PlexDataGridEngine.exportHeaders(widget.columns),
        PlexDataGridEngine.exportMatrix(widget.columns, _exportRows()),
      );
    });
  }

  Future<void> _runExport(Future<String?> Function() action) async {
    try {
      final String? path = await action();
      if (!mounted) return;
      if (path == null) {
        context.showSnackBar('Unable to save file, Please try again...');
        return;
      }
      context.showSnackBar('Report saved at "$path"');
    } catch (_) {
      if (!mounted) return;
      context.showSnackBar('Unable to save file, Please try again...');
    }
  }

  int _effectivePageIndex(int total) {
    return _pageIndex.clamp(0, _pageCount(total) - 1);
  }

  List<E> _pageOf<E>(List<E> rows) {
    if (rows.isEmpty) return <E>[];
    final int pageIndex = _effectivePageIndex(rows.length);
    final int start = pageIndex * _pageSize;
    final int end = math.min(start + _pageSize, rows.length);
    if (start >= rows.length) return <E>[];
    return rows.sublist(start, end);
  }

  int _pageCount(int total) => math.max(1, (total / _pageSize).ceil());

  void _pruneSelection() {
    final Set<Object> live = _workingRows.map(_idFor).toSet();
    _selectedIds.removeWhere((Object id) => !live.contains(id));
  }

  void _emitSelection() {
    final List<T> selected = _workingRows
        .where((T row) => _selectedIds.contains(_idFor(row)))
        .toList();
    widget.onSelectionChanged?.call(selected);
  }

  void _commitCellEdit(T row, String columnId, String newValue) {
    widget.onCellEdited?.call(row, columnId, newValue);
    final T Function(T, String, String)? apply = widget.applyCellEdit;
    if (apply == null) return;
    final T updated = apply(row, columnId, newValue);
    int index = _workingRows.indexWhere((T r) => identical(r, row));
    if (index < 0) {
      final Object id = _idFor(row);
      index = _workingRows.indexWhere((T r) => _idFor(r) == id);
    }
    if (index < 0) return;
    setState(() {
      _workingRows[index] = updated;
    });
    widget.onRowsChanged?.call(List<T>.from(_workingRows));
  }

  /// Prefix of [pageLines] containing the first [PlexDataGrid.frozenRowCount]
  /// data rows. Group/summary lines before that count stay with the prefix.
  List<PlexDataGridLine<T>> _frozenPageLines(
    List<PlexDataGridLine<T>> pageLines,
  ) {
    final int want = widget.frozenRowCount;
    if (want <= 0 || pageLines.isEmpty) {
      return <PlexDataGridLine<T>>[];
    }
    int dataSeen = 0;
    final List<PlexDataGridLine<T>> frozen = <PlexDataGridLine<T>>[];
    for (final PlexDataGridLine<T> line in pageLines) {
      if (dataSeen >= want) break;
      frozen.add(line);
      if (line.row != null) dataSeen++;
    }
    return frozen;
  }

  void _onSearchChanged(String value) {
    setState(() {
      _search = value;
      _pageIndex = 0;
    });
    widget.onSearch?.call(value);
  }

  void _onHeaderTap(PlexDataGridColumn<T> column) {
    if (!column.sortable) return;
    setState(() {
      if (_sort?.columnId != column.id) {
        _sort = PlexDataGridSort(
          columnId: column.id,
          direction: PlexDataGridSortDirection.ascending,
        );
      } else if (_sort!.direction == PlexDataGridSortDirection.ascending) {
        _sort = PlexDataGridSort(
          columnId: column.id,
          direction: PlexDataGridSortDirection.descending,
        );
      } else {
        _sort = null;
      }
      _pageIndex = 0;
    });
    widget.onSort?.call(_sort);
  }

  void _toggleRow(T row) {
    final Object id = _idFor(row);
    setState(() {
      if (widget.selectionMode == PlexDataGridSelectionMode.single) {
        if (_selectedIds.contains(id) && _selectedIds.length == 1) {
          _selectedIds.clear();
        } else {
          _selectedIds
            ..clear()
            ..add(id);
        }
      } else {
        if (!_selectedIds.remove(id)) {
          _selectedIds.add(id);
        }
      }
    });
    _emitSelection();
  }

  void _togglePage(List<T> pageRows) {
    final bool allSelected = pageRows.isNotEmpty &&
        pageRows.every((T row) => _selectedIds.contains(_idFor(row)));
    setState(() {
      if (allSelected) {
        for (final T row in pageRows) {
          _selectedIds.remove(_idFor(row));
        }
      } else {
        for (final T row in pageRows) {
          _selectedIds.add(_idFor(row));
        }
      }
    });
    _emitSelection();
  }

  void _goToPage(int index, int pageCount) {
    final int next = index.clamp(0, pageCount - 1);
    if (next == _pageIndex) return;
    setState(() => _pageIndex = next);
  }

  Alignment _alignment(PlexDataGridColumn<T> column, [TextAlign? textAlign]) {
    if (textAlign == TextAlign.right || textAlign == TextAlign.end) {
      return Alignment.centerRight;
    }
    if (textAlign == TextAlign.center) {
      return Alignment.center;
    }
    if (textAlign == TextAlign.left || textAlign == TextAlign.start) {
      return Alignment.centerLeft;
    }
    return column.numeric ? Alignment.centerRight : Alignment.centerLeft;
  }

  @override
  Widget build(BuildContext context) {
    final PlexThemeData theme = PlexThemeData.of(context);
    final PlexColorTokens colors = theme.colors;
    final PlexDensity density = _resolvedDensity(theme);
    final List<PlexDataGridLine<T>> lines = _visibleLines();
    final List<PlexDataGridLine<T>> pageLines = _pageOf(lines);
    final List<T> pageRows = <T>[
      for (final PlexDataGridLine<T> line in pageLines)
        if (line.row != null) line.row as T,
    ];
    final int total = lines.length;
    final int pageCount = _pageCount(total);
    final PlexDataGridSizer sizer =
        PlexDataGridSizer(fontFamily: theme.fontFamily);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double height = widget.height ??
            (constraints.maxHeight.isFinite ? constraints.maxHeight : 520);
        final double width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : sizer
                .resolveColumnWidths(
                  columns: widget.columns,
                  pageRows: pageRows,
                  gridColumnSizeMode: widget.columnSizeMode,
                  viewportWidth: 0,
                  selectable: _selectable,
                  groupingEnabled: widget.enableGrouping,
                  rowStyle: widget.rowStyle,
                )
                .fold<double>(0, (double s, double w) => s + w);
        return SizedBox(
          height: height,
          width: width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(PlexRadius.lg),
              border: Border.all(color: colors.borderDefault),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(PlexRadius.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.loading)
                    LinearProgressIndicator(
                      key: const Key('plex-data-grid-loading'),
                      minHeight: 2,
                      color: colors.brandPrimary,
                      backgroundColor: colors.statusInfoSoft,
                    ),
                  if (widget.showToolbar) _buildToolbar(theme, colors, density),
                  Expanded(
                    child: Stack(
                      children: [
                        _buildBody(
                          theme: theme,
                          colors: colors,
                          density: density,
                          pageLines: pageLines,
                          pageRows: pageRows,
                          sizer: sizer,
                        ),
                        if (widget.loading && pageRows.isNotEmpty)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: ColoredBox(
                                color:
                                    colors.surfaceCard.withValues(alpha: 0.55),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.showFooter)
                    _buildFooter(
                      theme,
                      colors,
                      total,
                      pageCount,
                      _effectivePageIndex(total),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolbar(
    PlexThemeData theme,
    PlexColorTokens colors,
    PlexDensity density,
  ) {
    final bool compact = density == PlexDensity.compact;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PlexDim.smallMedium,
          vertical: PlexDim.small,
        ),
        child: Wrap(
          spacing: PlexDim.small,
          runSpacing: PlexDim.small,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (widget.title != null || widget.subtitle != null)
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title != null)
                      Text(
                        widget.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: theme.fontFamily,
                          fontSize: PlexFontSize.bodyLarge,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: theme.fontFamily,
                          fontSize: PlexFontSize.caption,
                          color: colors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
            if (_selectedIds.isNotEmpty)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.statusInfoSoft,
                  borderRadius: BorderRadius.circular(PlexRadius.pill),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: PlexDim.smallMedium,
                    right: PlexDim.mini,
                    top: PlexDim.mini,
                    bottom: PlexDim.mini,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_selectedIds.length} selected',
                        style: TextStyle(
                          fontFamily: theme.fontFamily,
                          fontSize: PlexFontSize.caption,
                          fontWeight: FontWeight.w600,
                          color: colors.statusInfoInk,
                        ),
                      ),
                      PlexIconButton(
                        icon: const Icon(Icons.close),
                        size: PlexButtonSize.sm,
                        label: 'Clear selection',
                        onPressed: () {
                          setState(() => _selectedIds.clear());
                          _emitSelection();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.showSearch)
              SizedBox(
                width: 200,
                height: 32,
                child: TextField(
                  key: const Key('plex-data-grid-search'),
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: TextStyle(
                    fontFamily: theme.fontFamily,
                    fontSize: PlexFontSize.body,
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search',
                    hintStyle: TextStyle(color: colors.textMuted),
                    prefixIcon:
                        Icon(Icons.search, size: 16, color: colors.textMuted),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: PlexDim.small,
                      vertical: PlexDim.smallest,
                    ),
                    filled: true,
                    fillColor: colors.surfaceCard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(PlexRadius.md),
                      borderSide: BorderSide(color: colors.borderDefault),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(PlexRadius.md),
                      borderSide: BorderSide(color: colors.borderDefault),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(PlexRadius.md),
                      borderSide: BorderSide(color: colors.borderFocus),
                    ),
                  ),
                ),
              ),
            if (widget.showDensityToggle)
              PlexIconButton(
                icon:
                    Icon(compact ? Icons.density_small : Icons.density_medium),
                variant: PlexIconButtonVariant.outline,
                size: PlexButtonSize.sm,
                label: 'Toggle row density',
                onPressed: () {
                  setState(() {
                    _densityOverride =
                        compact ? PlexDensity.comfortable : PlexDensity.compact;
                  });
                },
              ),
            if (widget.enableGrouping) ...[
              for (final String id in _groupByColumnIds)
                InputChip(
                  key: Key('plex-data-grid-group-chip-$id'),
                  label: Text(_columnById(id)?.title ?? id),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onDeleted: () => _removeGroupColumn(id),
                ),
              if (_remainingGroupableColumns().isNotEmpty)
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    key: const Key('plex-data-grid-group-by'),
                    hint: const Text('Add group'),
                    value: null,
                    isDense: true,
                    items: <DropdownMenuItem<String>>[
                      for (final PlexDataGridColumn<T> column
                          in _remainingGroupableColumns())
                        DropdownMenuItem<String>(
                          value: column.id,
                          child: Text('Group: ${column.title}'),
                        ),
                    ],
                    onChanged: _addGroupColumn,
                  ),
                ),
              if (_groupByColumnIds.isNotEmpty)
                PlexIconButton(
                  key: const Key('plex-data-grid-summaries-toggle'),
                  icon: Icon(
                    _showGroupSummaries
                        ? Icons.functions
                        : Icons.functions_outlined,
                  ),
                  variant: PlexIconButtonVariant.outline,
                  size: PlexButtonSize.sm,
                  label:
                      _showGroupSummaries ? 'Hide summaries' : 'Show summaries',
                  onPressed: _toggleSummaries,
                ),
            ],
            if (widget.enableCsvExport)
              PlexIconButton(
                key: const Key('plex-data-grid-csv'),
                icon: const Icon(Icons.grid_on_outlined),
                variant: PlexIconButtonVariant.outline,
                size: PlexButtonSize.sm,
                label: 'CSV',
                onPressed: _exportCsv,
              ),
            if (widget.enableExcelExport)
              PlexIconButton(
                key: const Key('plex-data-grid-excel'),
                icon: const Icon(Icons.table_chart_outlined),
                variant: PlexIconButtonVariant.outline,
                size: PlexButtonSize.sm,
                label: 'Excel',
                onPressed: _exportExcel,
              ),
            if (widget.enablePdfExport)
              PlexIconButton(
                key: const Key('plex-data-grid-pdf'),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                variant: PlexIconButtonVariant.outline,
                size: PlexButtonSize.sm,
                label: 'Pdf',
                onPressed: _exportPdf,
              ),
            if (widget.actions != null) widget.actions!,
          ],
        ),
      ),
    );
  }

  Widget _buildPageLine({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDensity density,
    required PlexDataGridLine<T> line,
    required List<double> widths,
    List<PlexDataGridColumn<T>>? columns,
    bool? includeSelection,
    String keyPrefix = '',
    bool leading = true,
    double? rowHeight,
  }) {
    if (line.isGroup) {
      return _buildGroupRow(
        theme: theme,
        colors: colors,
        density: density,
        line: line,
        widths: widths,
        includeSelection: includeSelection,
        leading: leading,
      );
    }
    if (line.isSummary) {
      return _buildSummaryRow(
        theme: theme,
        colors: colors,
        density: density,
        line: line,
        widths: widths,
        columns: columns,
        includeSelection: includeSelection,
        leading: leading,
      );
    }
    return _buildRow(
      theme: theme,
      colors: colors,
      density: density,
      row: line.row as T,
      widths: widths,
      keyPrefix: keyPrefix,
      columns: columns,
      includeSelection: includeSelection,
      height: rowHeight,
    );
  }

  Widget _buildFrozenRowBand({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDensity density,
    required List<PlexDataGridLine<T>> lines,
    required List<double> widths,
    List<PlexDataGridColumn<T>>? columns,
    bool? includeSelection,
    String keyPrefix = '',
    bool leading = true,
    List<double>? lineHeights,
  }) {
    if (lines.isEmpty) return const SizedBox.shrink();
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < lines.length; i++)
            _buildPageLine(
              theme: theme,
              colors: colors,
              density: density,
              line: lines[i],
              widths: widths,
              columns: columns,
              includeSelection: includeSelection,
              keyPrefix: keyPrefix,
              leading: leading,
              rowHeight: lineHeights?[i],
            ),
        ],
      ),
    );
  }

  Widget _buildScrollingLines({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDensity density,
    required List<PlexDataGridLine<T>> pageLines,
    required List<PlexDataGridLine<T>> scrollingLines,
    required List<double> widths,
    ScrollController? controller,
    List<PlexDataGridColumn<T>>? columns,
    bool? includeSelection,
    String keyPrefix = '',
    bool leading = true,
    List<double>? lineHeights,
  }) {
    if (pageLines.isEmpty) return _buildEmpty(theme, colors);
    return ListView.builder(
      controller: controller,
      primary: controller == null ? null : false,
      itemCount: scrollingLines.length,
      itemExtent: lineHeights == null ? _rowHeight(density) : null,
      itemBuilder: (BuildContext context, int index) {
        return _buildPageLine(
          theme: theme,
          colors: colors,
          density: density,
          line: scrollingLines[index],
          widths: widths,
          columns: columns,
          includeSelection: includeSelection,
          keyPrefix: keyPrefix,
          leading: leading,
          rowHeight: lineHeights?[index],
        );
      },
    );
  }

  Widget _buildBody({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDensity density,
    required List<PlexDataGridLine<T>> pageLines,
    required List<T> pageRows,
    required PlexDataGridSizer sizer,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double viewport =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 0;
        final List<double> widths = sizer.resolveColumnWidths(
          columns: widget.columns,
          pageRows: pageRows,
          gridColumnSizeMode: widget.columnSizeMode,
          viewportWidth: viewport,
          selectable: _selectable,
          groupingEnabled: widget.enableGrouping,
          rowStyle: widget.rowStyle,
        );
        final double minWidth =
            widths.fold<double>(0, (double s, double w) => s + w);
        final bool fixedRows = sizer.columnsUseFixedRowHeight(
          widget.columns,
          widget.rowSizeMode,
        );
        final List<double>? lineHeights = fixedRows
            ? null
            : <double>[
                for (final PlexDataGridLine<T> line in pageLines)
                  line.row == null
                      ? sizer.densityRowHeight(density)
                      : sizer.resolveRowHeight(
                          row: line.row as T,
                          columns: widget.columns,
                          columnWidths: widths,
                          density: density,
                          gridRowSizeMode: widget.rowSizeMode,
                          rowStyle: widget.rowStyle,
                          selectable: _selectable,
                        ),
              ];
        final double headerHeight = sizer.resolveHeaderHeight(
          columns: widget.columns,
          columnWidths: widths,
          density: density,
          headerRowSizeMode: widget.headerRowSizeMode,
          selectable: _selectable,
        );
        final int frozen =
            widget.frozenColumnCount.clamp(0, widget.columns.length);
        final List<PlexDataGridLine<T>> frozenLines =
            _frozenPageLines(pageLines);
        final List<PlexDataGridLine<T>> scrollingLines = frozenLines.isEmpty
            ? pageLines
            : pageLines.sublist(frozenLines.length);
        final List<double>? frozenHeights =
            lineHeights?.sublist(0, frozenLines.length);
        final List<double>? scrollHeights =
            lineHeights?.sublist(frozenLines.length);
        if (frozen > 0) {
          return _buildFrozenBody(
            theme: theme,
            colors: colors,
            density: density,
            pageLines: pageLines,
            pageRows: pageRows,
            frozenLines: frozenLines,
            scrollingLines: scrollingLines,
            widths: widths,
            frozen: frozen,
            headerHeight: headerHeight,
            frozenHeights: frozenHeights,
            scrollHeights: scrollHeights,
          );
        }
        final double gridWidth = constraints.maxWidth.isFinite
            ? math.max(minWidth, constraints.maxWidth)
            : minWidth;
        return Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: gridWidth,
              child: Column(
                children: [
                  _buildHeader(
                    theme,
                    colors,
                    density,
                    pageRows,
                    widths,
                    headerHeight: headerHeight,
                  ),
                  if (frozenLines.isNotEmpty)
                    _buildFrozenRowBand(
                      theme: theme,
                      colors: colors,
                      density: density,
                      lines: frozenLines,
                      widths: widths,
                      lineHeights: frozenHeights,
                    ),
                  Expanded(
                    child: _buildScrollingLines(
                      theme: theme,
                      colors: colors,
                      density: density,
                      pageLines: pageLines,
                      scrollingLines: scrollingLines,
                      widths: widths,
                      lineHeights: scrollHeights,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFrozenBody({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDensity density,
    required List<PlexDataGridLine<T>> pageLines,
    required List<T> pageRows,
    required List<PlexDataGridLine<T>> frozenLines,
    required List<PlexDataGridLine<T>> scrollingLines,
    required List<double> widths,
    required int frozen,
    required double headerHeight,
    List<double>? frozenHeights,
    List<double>? scrollHeights,
  }) {
    final bool selectable =
        widget.selectionMode != PlexDataGridSelectionMode.none;
    final List<PlexDataGridColumn<T>> frozenCols =
        widget.columns.take(frozen).toList();
    final List<PlexDataGridColumn<T>> scrollCols =
        widget.columns.skip(frozen).toList();
    final int frozenSlots = (selectable ? 1 : 0) + frozen;
    final List<double> frozenWidths = widths.take(frozenSlots).toList();
    final List<double> scrollWidths = widths.skip(frozenSlots).toList();
    final double frozenWidth =
        frozenWidths.fold<double>(0, (double a, double b) => a + b);
    final double scrollWidth =
        scrollWidths.fold<double>(0, (double a, double b) => a + b);

    // 2×2 freeze panes when [frozenLines] is non-empty: top-left locked,
    // top-right scroll-x (with this pane's horizontal view), bottom-left
    // scroll-y, bottom-right both. Vertical controllers stay synced.
    Widget pane({
      required ScrollController controller,
      required List<PlexDataGridColumn<T>> columns,
      required List<double> paneWidths,
      required bool includeSelection,
      required String keyPrefix,
      required bool leading,
    }) {
      return Column(
        children: [
          _buildHeader(
            theme,
            colors,
            density,
            pageRows,
            paneWidths,
            columns: columns,
            includeSelection: includeSelection,
            headerHeight: headerHeight,
          ),
          if (frozenLines.isNotEmpty)
            _buildFrozenRowBand(
              theme: theme,
              colors: colors,
              density: density,
              lines: frozenLines,
              widths: paneWidths,
              columns: columns,
              includeSelection: includeSelection,
              keyPrefix: keyPrefix,
              leading: leading,
              lineHeights: frozenHeights,
            ),
          Expanded(
            child: _buildScrollingLines(
              theme: theme,
              colors: colors,
              density: density,
              pageLines: pageLines,
              scrollingLines: scrollingLines,
              widths: paneWidths,
              controller: controller,
              columns: columns,
              includeSelection: includeSelection,
              keyPrefix: keyPrefix,
              leading: leading,
              lineHeights: scrollHeights,
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            border: Border(right: BorderSide(color: colors.borderDefault)),
          ),
          child: SizedBox(
            width: frozenWidth,
            child: pane(
              controller: _frozenVertical,
              columns: frozenCols,
              paneWidths: frozenWidths,
              includeSelection: selectable,
              keyPrefix: 'f-',
              leading: true,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: math.max(1, scrollWidth),
              child: pane(
                controller: _scrollVertical,
                columns: scrollCols,
                paneWidths: scrollWidths,
                includeSelection: false,
                keyPrefix: '',
                leading: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    PlexThemeData theme,
    PlexColorTokens colors,
    PlexDensity density,
    List<T> pageRows,
    List<double> widths, {
    List<PlexDataGridColumn<T>>? columns,
    bool? includeSelection,
    required double headerHeight,
  }) {
    final List<PlexDataGridColumn<T>> headerColumns = columns ?? widget.columns;
    final bool selectable = includeSelection ??
        widget.selectionMode != PlexDataGridSelectionMode.none;
    final bool multi =
        widget.selectionMode == PlexDataGridSelectionMode.multiple;
    final bool allSelected = pageRows.isNotEmpty &&
        pageRows.every((T row) => _selectedIds.contains(_idFor(row)));
    final bool someSelected =
        pageRows.any((T row) => _selectedIds.contains(_idFor(row)));

    int widthIndex = 0;
    final bool wrapHeader =
        widget.headerRowSizeMode == PlexDataGridRowSizeMode.auto;
    final Widget headerRow = SizedBox(
      height: headerHeight,
      child: Row(
        children: [
          if (selectable)
            SizedBox(
              width: widths[widthIndex++],
              child: multi
                  ? Center(
                      child: Checkbox(
                        tristate: true,
                        value:
                            allSelected ? true : (someSelected ? null : false),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(color: colors.borderStrong),
                        fillColor: WidgetStateProperty.resolveWith(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return colors.brandPrimary;
                            }
                            return colors.surfaceCard;
                          },
                        ),
                        checkColor: colors.textInverse,
                        onChanged: pageRows.isEmpty
                            ? null
                            : (_) => _togglePage(pageRows),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          for (final PlexDataGridColumn<T> column in headerColumns)
            SizedBox(
              width: widths[widthIndex++],
              child: _HeaderCell(
                theme: theme,
                colors: colors,
                columnId: column.id,
                columnTitle: column.title,
                numeric: column.numeric,
                sortable: column.sortable,
                sort: _sort?.columnId == column.id ? _sort : null,
                onTap: column.sortable ? () => _onHeaderTap(column) : null,
                groupable: widget.enableGrouping && column.groupable,
                grouped: _groupByColumnIds.contains(column.id),
                onToggleGroup: widget.enableGrouping && column.groupable
                    ? () => _toggleGroupColumn(column.id)
                    : null,
                wrap: wrapHeader,
              ),
            ),
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        border: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          headerRow,
          if (_showFilterRow)
            _buildFilterRow(
              theme,
              colors,
              selectable,
              widths,
              columns: headerColumns,
            ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(
    PlexThemeData theme,
    PlexColorTokens colors,
    bool selectable,
    List<double> widths, {
    List<PlexDataGridColumn<T>>? columns,
  }) {
    final List<PlexDataGridColumn<T>> filterColumns = columns ?? widget.columns;
    int widthIndex = 0;
    return SizedBox(
      height: _filterRowHeight,
      child: Row(
        children: [
          if (selectable) SizedBox(width: widths[widthIndex++]),
          for (final PlexDataGridColumn<T> column in filterColumns)
            SizedBox(
              width: widths[widthIndex++],
              child: column.filterable
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 3,
                      ),
                      child: TextField(
                        key: Key('plex-data-grid-column-filter-${column.id}'),
                        controller: _filterControllerFor(column.id),
                        onChanged: (String value) =>
                            _onColumnFilterChanged(column.id, value),
                        style: TextStyle(
                          fontFamily: theme.fontFamily,
                          fontSize: PlexFontSize.caption,
                          color: colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Filter',
                          hintStyle: TextStyle(color: colors.textMuted),
                          suffixIcon: IconButton(
                            key: Key(
                              'plex-data-grid-column-filter-match-${column.id}',
                            ),
                            tooltip: _matchTooltip(_matchFor(column.id)),
                            icon: Icon(
                              _matchIcon(_matchFor(column.id)),
                              size: 14,
                            ),
                            onPressed: () => _toggleFilterMatch(column.id),
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          filled: true,
                          fillColor: colors.surfaceCard,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(PlexRadius.sm),
                            borderSide: BorderSide(color: colors.borderDefault),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(PlexRadius.sm),
                            borderSide: BorderSide(color: colors.borderDefault),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(PlexRadius.sm),
                            borderSide: BorderSide(color: colors.borderFocus),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }

  Widget _buildGroupRow({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDensity density,
    required PlexDataGridLine<T> line,
    required List<double> widths,
    bool? includeSelection,
    bool leading = true,
  }) {
    final bool selectable = includeSelection ??
        widget.selectionMode != PlexDataGridSelectionMode.none;
    final double spanWidth = widths
        .skip(selectable ? 1 : 0)
        .fold<double>(0, (double s, double w) => s + w);
    final bool expanded = line.groupExpanded;
    return Material(
      color: colors.surfaceSunken,
      child: InkWell(
        key: leading ? Key('plex-data-grid-group-${line.groupKey}') : null,
        onTap: () => _toggleGroup(line.groupKey ?? ''),
        hoverColor: colors.surfaceHover,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.borderSubtle)),
          ),
          child: SizedBox(
            height: _rowHeight(density),
            child: Row(
              children: [
                if (selectable)
                  SizedBox(
                    width: widths.first,
                    child: Center(
                      child: Icon(
                        expanded ? Icons.expand_more : Icons.chevron_right,
                        size: 18,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                SizedBox(
                  width: spanWidth,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: PlexDim.small + line.groupDepth * 16,
                      right: PlexDim.small,
                    ),
                    child: Row(
                      children: [
                        if (leading && !selectable)
                          Icon(
                            expanded ? Icons.expand_more : Icons.chevron_right,
                            size: 18,
                            color: colors.textMuted,
                          ),
                        if (leading && !selectable) const SizedBox(width: 4),
                        if (leading)
                          Expanded(
                            child: Text(
                              line.groupCaption ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: theme.fontFamily,
                                fontSize: PlexFontSize.body,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PlexDataGridSummaryCell> _resolvedSummaryCells(
    PlexDataGridGroup<T> group,
    List<PlexDataGridSummaryCell>? structured,
  ) {
    if (structured != null) return structured;
    return PlexDataGridEngine.defaultGroupSummary(group, widget.columns);
  }

  Widget _buildSummaryRow({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDensity density,
    required PlexDataGridLine<T> line,
    required List<double> widths,
    List<PlexDataGridColumn<T>>? columns,
    bool? includeSelection,
    bool leading = true,
  }) {
    final PlexDataGridGroup<T>? group = line.group;
    final bool selectable = includeSelection ??
        widget.selectionMode != PlexDataGridSelectionMode.none;
    final List<PlexDataGridSummaryCell>? structured =
        group == null ? null : widget.groupSummary?.call(group);
    final Widget? customWidget = group == null || structured != null
        ? null
        : widget.groupSummaryBuilder?.call(context, group);

    return Material(
      color: colors.surfaceSunken,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.borderSubtle)),
        ),
        child: SizedBox(
          key: leading ? Key('plex-data-grid-summary-${line.groupKey}') : null,
          height: _rowHeight(density),
          child: customWidget != null
              ? (leading
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: PlexDim.small + line.groupDepth * 16,
                        right: PlexDim.small,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: customWidget,
                      ),
                    )
                  : const SizedBox.shrink())
              : Row(
                  children: [
                    if (selectable) SizedBox(width: widths.first),
                    ..._summaryCellBoxes(
                      theme: theme,
                      colors: colors,
                      line: line,
                      widths: widths,
                      skipFirst: selectable,
                      structured: structured,
                      columns: columns,
                      indentFirst: leading,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _summaryCellBoxes({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDataGridLine<T> line,
    required List<double> widths,
    required bool skipFirst,
    List<PlexDataGridSummaryCell>? structured,
    List<PlexDataGridColumn<T>>? columns,
    bool indentFirst = true,
  }) {
    final List<PlexDataGridColumn<T>> cols = columns ?? widget.columns;
    final PlexDataGridGroup<T>? group = line.group;
    final List<PlexDataGridSummaryCell> cells = group == null
        ? const <PlexDataGridSummaryCell>[]
        : _resolvedSummaryCells(group, structured);
    final Map<String, PlexDataGridSummaryCell> byId =
        <String, PlexDataGridSummaryCell>{
      for (final PlexDataGridSummaryCell cell in cells) cell.columnId: cell,
    };
    int widthIndex = skipFirst ? 1 : 0;
    return <Widget>[
      for (int i = 0; i < cols.length; i++)
        SizedBox(
          width: widths[widthIndex++],
          child: Align(
            alignment: _alignment(cols[i]),
            child: Padding(
              padding: EdgeInsets.only(
                left: (indentFirst && i == 0 ? line.groupDepth * 16 : 0) +
                    PlexDim.small,
                right: PlexDim.small,
              ),
              child: _summaryCellChild(
                theme,
                colors,
                cols[i],
                byId[cols[i].id],
              ),
            ),
          ),
        ),
    ];
  }

  Widget _summaryCellChild(
    PlexThemeData theme,
    PlexColorTokens colors,
    PlexDataGridColumn<T> column,
    PlexDataGridSummaryCell? cell,
  ) {
    if (cell?.child != null) return cell!.child!;
    final String text = cell?.text ?? '';
    if (text.isEmpty) return const SizedBox.shrink();
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: column.numeric ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        fontFamily: theme.fontFamily,
        fontSize: PlexFontSize.caption,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        color: colors.textMuted,
        fontFeatures: column.numeric
            ? const <FontFeature>[FontFeature.tabularFigures()]
            : null,
      ),
    );
  }

  Widget _buildRow({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDensity density,
    required T row,
    required List<double> widths,
    String keyPrefix = '',
    List<PlexDataGridColumn<T>>? columns,
    bool? includeSelection,
    double? height,
  }) {
    final Object id = _idFor(row);
    final bool selected = _selectedIds.contains(id);
    final bool selectable = includeSelection ??
        widget.selectionMode != PlexDataGridSelectionMode.none;
    final List<PlexDataGridColumn<T>> rowColumns = columns ?? widget.columns;
    int widthIndex = 0;
    final PlexDataGridCellStyle? rowStyle = widget.rowStyle?.call(row);
    final Color rowColor = selected
        ? colors.selection
        : (rowStyle?.backgroundColor ?? colors.surfaceCard);

    return Material(
      color: rowColor,
      child: InkWell(
        onTap: widget.onRowTap == null ? null : () => widget.onRowTap!(row),
        hoverColor: colors.surfaceHover,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.borderSubtle)),
          ),
          child: SizedBox(
            key: ValueKey<Object>('plex-data-grid-row-$keyPrefix$id'),
            height: height ?? _rowHeight(density),
            child: Row(
              children: [
                if (selectable)
                  SizedBox(
                    width: widths[widthIndex++],
                    child: Center(
                      child: Checkbox(
                        value: selected,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(color: colors.borderStrong),
                        fillColor: WidgetStateProperty.resolveWith(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return colors.brandPrimary;
                            }
                            return colors.surfaceCard;
                          },
                        ),
                        checkColor: colors.textInverse,
                        onChanged: (_) => _toggleRow(row),
                      ),
                    ),
                  ),
                for (final PlexDataGridColumn<T> column in rowColumns)
                  _buildDataCell(
                    theme: theme,
                    colors: colors,
                    row: row,
                    column: column,
                    width: widths[widthIndex++],
                    rowStyle: rowStyle,
                    selected: selected,
                    wrap: (column.rowSizeMode ?? widget.rowSizeMode) ==
                        PlexDataGridRowSizeMode.auto,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required T row,
    required PlexDataGridColumn<T> column,
    required double width,
    required PlexDataGridCellStyle? rowStyle,
    required bool selected,
    bool wrap = false,
  }) {
    final PlexDataGridCellStyle? cellStyle = column.cellStyle?.call(row);
    final PlexDataGridCellStyle? merged =
        rowStyle == null ? cellStyle : rowStyle.merge(cellStyle);
    final Widget? custom = column.cell?.call(context, row);
    final TextAlign textAlign = merged?.textAlign ??
        (column.numeric ? TextAlign.right : TextAlign.left);
    final Object rowId = _idFor(row);
    final TextStyle textStyle = TextStyle(
      fontFamily: theme.fontFamily,
      fontSize: merged?.fontSize ?? PlexFontSize.body,
      fontWeight: merged?.fontWeight,
      color: merged?.color ?? colors.textPrimary,
      fontFeatures: column.numeric
          ? const <FontFeature>[FontFeature.tabularFigures()]
          : null,
    );
    final bool canEdit = custom == null &&
        column.editable &&
        (widget.onCellEdited != null || widget.applyCellEdit != null);
    late final Widget content;
    if (custom != null) {
      content = custom;
    } else if (canEdit) {
      String draft = column.value(row)?.toString() ?? '';
      bool submitted = false;
      void submit(String value) {
        if (submitted) return;
        submitted = true;
        _commitCellEdit(row, column.id, value);
      }

      content = Focus(
        onFocusChange: (bool focused) {
          if (!focused) submit(draft);
        },
        child: TextFormField(
          key: Key('plex-data-grid-edit-${column.id}-$rowId'),
          initialValue: draft,
          style: textStyle,
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (String value) => draft = value,
          onFieldSubmitted: submit,
        ),
      );
    } else {
      content = Text(
        column.value(row)?.toString() ?? '',
        maxLines: wrap ? null : 1,
        overflow: wrap ? TextOverflow.clip : TextOverflow.ellipsis,
        softWrap: wrap,
        textAlign: textAlign,
        style: textStyle,
      );
    }
    Widget cell = Align(
      alignment: _alignment(column, merged?.textAlign),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: PlexDim.small),
        child: content,
      ),
    );
    final Color? cellBackground = selected ? null : merged?.backgroundColor;
    if (cellBackground != null) {
      cell = ColoredBox(color: cellBackground, child: cell);
    }
    return SizedBox(width: width, child: cell);
  }

  Widget _buildEmpty(PlexThemeData theme, PlexColorTokens colors) {
    if (widget.empty != null) return Center(child: widget.empty);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PlexDim.largeMinus),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 28, color: colors.textMuted),
            const SizedBox(height: PlexDim.small),
            Text(
              widget.emptyTitle,
              key: const Key('plex-data-grid-empty'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: PlexFontSize.bodyLarge,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: PlexDim.smallest),
            Text(
              widget.emptyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: PlexFontSize.body,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(
    PlexThemeData theme,
    PlexColorTokens colors,
    int total,
    int pageCount,
    int pageIndex,
  ) {
    final int from = total == 0 ? 0 : pageIndex * _pageSize + 1;
    final int to = math.min((pageIndex + 1) * _pageSize, total);
    final List<int> sizes = List<int>.of(widget.pageSizeOptions);
    if (!sizes.contains(_pageSize)) {
      sizes.add(_pageSize);
    }
    sizes.sort();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        border: Border(top: BorderSide(color: colors.borderDefault)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PlexDim.smallMedium,
          vertical: PlexDim.small,
        ),
        child: Wrap(
          spacing: PlexDim.medium,
          runSpacing: PlexDim.small,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rows',
                  style: TextStyle(
                    fontFamily: theme.fontFamily,
                    fontSize: PlexFontSize.body,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(width: PlexDim.small),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _pageSize,
                    isDense: true,
                    style: TextStyle(
                      fontFamily: theme.fontFamily,
                      fontSize: PlexFontSize.body,
                      color: colors.textPrimary,
                    ),
                    items: [
                      for (final int size in sizes)
                        DropdownMenuItem<int>(
                            value: size, child: Text('$size')),
                    ],
                    onChanged: (int? value) {
                      if (value == null) return;
                      setState(() {
                        _pageSize = value;
                        _pageIndex = 0;
                      });
                    },
                  ),
                ),
              ],
            ),
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontFamily: theme.fontFamily,
                  fontSize: PlexFontSize.body,
                  color: colors.textMuted,
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures()
                  ],
                ),
                children: [
                  TextSpan(
                    text: '$from–$to',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const TextSpan(text: ' of '),
                  TextSpan(
                    text: '$total',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlexIconButton(
                  icon: const Icon(Icons.first_page),
                  variant: PlexIconButtonVariant.outline,
                  size: PlexButtonSize.sm,
                  label: 'First page',
                  enabled: pageIndex > 0,
                  onPressed: () => _goToPage(0, pageCount),
                ),
                const SizedBox(width: PlexDim.mini),
                PlexIconButton(
                  icon: const Icon(Icons.chevron_left),
                  variant: PlexIconButtonVariant.outline,
                  size: PlexButtonSize.sm,
                  label: 'Previous page',
                  enabled: pageIndex > 0,
                  onPressed: () => _goToPage(pageIndex - 1, pageCount),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: PlexDim.small),
                  child: Text(
                    'Page ${pageIndex + 1} of $pageCount',
                    key: const Key('plex-data-grid-page-label'),
                    style: TextStyle(
                      fontFamily: theme.fontFamily,
                      fontSize: PlexFontSize.body,
                      color: colors.textMuted,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures()
                      ],
                    ),
                  ),
                ),
                PlexIconButton(
                  icon: const Icon(Icons.chevron_right),
                  variant: PlexIconButtonVariant.outline,
                  size: PlexButtonSize.sm,
                  label: 'Next page',
                  enabled: pageIndex + 1 < pageCount,
                  onPressed: () => _goToPage(pageIndex + 1, pageCount),
                ),
                const SizedBox(width: PlexDim.mini),
                PlexIconButton(
                  icon: const Icon(Icons.last_page),
                  variant: PlexIconButtonVariant.outline,
                  size: PlexButtonSize.sm,
                  label: 'Last page',
                  enabled: pageIndex + 1 < pageCount,
                  onPressed: () => _goToPage(pageCount - 1, pageCount),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.theme,
    required this.colors,
    required this.columnId,
    required this.columnTitle,
    required this.numeric,
    required this.sortable,
    required this.sort,
    required this.onTap,
    this.groupable = false,
    this.grouped = false,
    this.onToggleGroup,
    this.wrap = false,
  });

  final PlexThemeData theme;
  final PlexColorTokens colors;
  final String columnId;
  final String columnTitle;
  final bool numeric;
  final bool sortable;
  final PlexDataGridSort? sort;
  final VoidCallback? onTap;
  final bool groupable;
  final bool grouped;
  final VoidCallback? onToggleGroup;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final bool sorted = sort != null;
    final Color textColor = sorted ? colors.textBrand : colors.textMuted;
    final Widget label = ClipRect(
      child: Row(
        children: [
          Expanded(
            child: Text(
              columnTitle.toUpperCase(),
              maxLines: wrap ? null : 1,
              overflow: wrap ? TextOverflow.clip : TextOverflow.ellipsis,
              softWrap: wrap,
              textAlign: numeric ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: PlexFontSize.small,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.05 * PlexFontSize.small,
                color: textColor,
              ),
            ),
          ),
          if (sortable) ...[
            const SizedBox(width: PlexDim.mini),
            Icon(
              sort?.direction == PlexDataGridSortDirection.descending
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 12,
              color: textColor,
            ),
          ],
          if (onToggleGroup != null) ...[
            const SizedBox(width: 2),
            IconButton(
              key: Key('plex-data-grid-header-group-$columnId'),
              tooltip: grouped
                  ? 'Remove group: $columnTitle'
                  : 'Group by $columnTitle',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              icon: Icon(
                grouped ? Icons.account_tree : Icons.account_tree_outlined,
                size: 14,
                color: grouped ? colors.textBrand : colors.textMuted,
              ),
              onPressed: onToggleGroup,
            ),
          ],
        ],
      ),
    );

    return Semantics(
      button: sortable,
      label: sortable ? 'Sort $columnTitle' : columnTitle,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PlexDim.small),
          child: Align(
            alignment: numeric ? Alignment.centerRight : Alignment.centerLeft,
            child: label,
          ),
        ),
      ),
    );
  }
}
