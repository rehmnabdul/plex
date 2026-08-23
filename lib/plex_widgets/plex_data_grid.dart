import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
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

/// Column model for [PlexDataGrid].
///
/// [value] is the cell/sort/search accessor. Optional [cell] replaces the
/// default text rendering for that column.
class PlexDataGridColumn<T> {
  const PlexDataGridColumn({
    required this.id,
    required this.title,
    required this.value,
    this.cell,
    this.sortable = true,
    this.searchable = true,
    this.numeric = false,
    this.width,
  });

  final String id;
  final String title;
  final Object? Function(T row) value;
  final Widget Function(BuildContext context, T row)? cell;
  final bool sortable;
  final bool searchable;
  final bool numeric;
  final double? width;
}

/// Plex-owned data grid (Phase 5a). Client-side sort, search, selection, and
/// pagination. Uses [PlexThemeData] tokens — not Syncfusion theming.
///
/// Does not replace [PlexAdvanceDataTable]; that widget remains for existing
/// call sites until a later mapping pass.
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

  @override
  State<PlexDataGrid<T>> createState() => _PlexDataGridState<T>();
}

class _PlexDataGridState<T> extends State<PlexDataGrid<T>> {
  static const double _selectColWidth = 44;
  static const double _defaultColWidth = 160;

  final TextEditingController _searchController = TextEditingController();
  final Set<Object> _selectedIds = <Object>{};

  String _search = '';
  PlexDataGridSort? _sort;
  int _pageIndex = 0;
  late int _pageSize;
  PlexDensity? _densityOverride;

  @override
  void initState() {
    super.initState();
    _pageSize = widget.pageSize;
    _densityOverride = widget.density;
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
      _pruneSelection();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Object _idFor(T row) => widget.rowId?.call(row) ?? identityHashCode(row);

  PlexDensity _resolvedDensity(PlexThemeData theme) {
    return _densityOverride ?? widget.density ?? theme.density;
  }

  double _rowHeight(PlexDensity density) {
    return density == PlexDensity.compact ? 34 : 44;
  }

  double _headerHeight(PlexDensity density) {
    return density == PlexDensity.compact ? 38 : 44;
  }

  double _columnWidth(PlexDataGridColumn<T> column) {
    return column.width ?? _defaultColWidth;
  }

  List<double> _bodyColumnWidths() {
    return <double>[
      if (widget.selectionMode != PlexDataGridSelectionMode.none)
        _selectColWidth,
      ...widget.columns.map(_columnWidth),
    ];
  }

  List<T> _filteredRows() {
    final String query = _search.trim().toLowerCase();
    if (query.isEmpty) return List<T>.from(widget.rows);
    return widget.rows.where((T row) {
      for (final PlexDataGridColumn<T> column in widget.columns) {
        if (!column.searchable) continue;
        final Object? value = column.value(row);
        if ((value?.toString() ?? '').toLowerCase().contains(query)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  List<T> _sortedRows(List<T> rows) {
    final PlexDataGridSort? sort = _sort;
    if (sort == null) return rows;
    final int columnIndex = widget.columns
        .indexWhere((PlexDataGridColumn<T> c) => c.id == sort.columnId);
    if (columnIndex < 0) return rows;
    final PlexDataGridColumn<T> column = widget.columns[columnIndex];
    rows.sort((T a, T b) {
      final int compared = _compareValues(column.value(a), column.value(b));
      return sort.direction == PlexDataGridSortDirection.ascending
          ? compared
          : -compared;
    });
    return rows;
  }

  int _compareValues(Object? a, Object? b) {
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

  int _effectivePageIndex(int total) {
    return _pageIndex.clamp(0, _pageCount(total) - 1);
  }

  List<T> _pageOf(List<T> rows) {
    if (rows.isEmpty) return <T>[];
    final int pageIndex = _effectivePageIndex(rows.length);
    final int start = pageIndex * _pageSize;
    final int end = math.min(start + _pageSize, rows.length);
    if (start >= rows.length) return <T>[];
    return rows.sublist(start, end);
  }

  int _pageCount(int total) => math.max(1, (total / _pageSize).ceil());

  void _pruneSelection() {
    final Set<Object> live = widget.rows.map(_idFor).toSet();
    _selectedIds.removeWhere((Object id) => !live.contains(id));
  }

  void _emitSelection() {
    final List<T> selected = widget.rows
        .where((T row) => _selectedIds.contains(_idFor(row)))
        .toList();
    widget.onSelectionChanged?.call(selected);
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

  Alignment _alignment(PlexDataGridColumn<T> column) {
    return column.numeric ? Alignment.centerRight : Alignment.centerLeft;
  }

  @override
  Widget build(BuildContext context) {
    final PlexThemeData theme = PlexThemeData.of(context);
    final PlexColorTokens colors = theme.colors;
    final PlexDensity density = _resolvedDensity(theme);
    final List<T> filtered = _sortedRows(_filteredRows());
    final List<T> pageRows = _pageOf(filtered);
    final int total = filtered.length;
    final int pageCount = _pageCount(total);
    final List<double> widths = _bodyColumnWidths();
    final double minWidth =
        widths.fold<double>(0, (double s, double w) => s + w);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double height = widget.height ??
            (constraints.maxHeight.isFinite ? constraints.maxHeight : 520);
        return SizedBox(
          height: height,
          width:
              constraints.maxWidth.isFinite ? constraints.maxWidth : minWidth,
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
                          pageRows: pageRows,
                          widths: widths,
                          minWidth: minWidth,
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
                constraints: const BoxConstraints(minWidth: 120, maxWidth: 280),
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
            if (widget.actions != null) widget.actions!,
          ],
        ),
      ),
    );
  }

  Widget _buildBody({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDensity density,
    required List<T> pageRows,
    required List<double> widths,
    required double minWidth,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double gridWidth = math.max(minWidth, constraints.maxWidth);
        return Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: gridWidth,
              child: Column(
                children: [
                  _buildHeader(theme, colors, density, pageRows, widths),
                  Expanded(
                    child: pageRows.isEmpty
                        ? _buildEmpty(theme, colors)
                        : ListView.builder(
                            itemCount: pageRows.length,
                            itemExtent: _rowHeight(density),
                            itemBuilder: (BuildContext context, int index) {
                              return _buildRow(
                                theme: theme,
                                colors: colors,
                                density: density,
                                row: pageRows[index],
                                widths: widths,
                              );
                            },
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

  Widget _buildHeader(
    PlexThemeData theme,
    PlexColorTokens colors,
    PlexDensity density,
    List<T> pageRows,
    List<double> widths,
  ) {
    final bool selectable =
        widget.selectionMode != PlexDataGridSelectionMode.none;
    final bool multi =
        widget.selectionMode == PlexDataGridSelectionMode.multiple;
    final bool allSelected = pageRows.isNotEmpty &&
        pageRows.every((T row) => _selectedIds.contains(_idFor(row)));
    final bool someSelected =
        pageRows.any((T row) => _selectedIds.contains(_idFor(row)));

    int widthIndex = 0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        border: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      child: SizedBox(
        height: _headerHeight(density),
        child: Row(
          children: [
            if (selectable)
              SizedBox(
                width: widths[widthIndex++],
                child: multi
                    ? Center(
                        child: Checkbox(
                          tristate: true,
                          value: allSelected
                              ? true
                              : (someSelected ? null : false),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
            for (final PlexDataGridColumn<T> column in widget.columns)
              SizedBox(
                width: widths[widthIndex++],
                child: _HeaderCell(
                  theme: theme,
                  colors: colors,
                  columnTitle: column.title,
                  numeric: column.numeric,
                  sortable: column.sortable,
                  sort: _sort?.columnId == column.id ? _sort : null,
                  onTap: column.sortable ? () => _onHeaderTap(column) : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required PlexThemeData theme,
    required PlexColorTokens colors,
    required PlexDensity density,
    required T row,
    required List<double> widths,
  }) {
    final Object id = _idFor(row);
    final bool selected = _selectedIds.contains(id);
    final bool selectable =
        widget.selectionMode != PlexDataGridSelectionMode.none;
    int widthIndex = 0;
    final Color rowColor = selected ? colors.selection : colors.surfaceCard;

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
            key: ValueKey<Object>('plex-data-grid-row-$id'),
            height: _rowHeight(density),
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
                for (final PlexDataGridColumn<T> column in widget.columns)
                  SizedBox(
                    width: widths[widthIndex++],
                    child: Align(
                      alignment: _alignment(column),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: PlexDim.small),
                        child: column.cell?.call(context, row) ??
                            Text(
                              column.value(row)?.toString() ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: column.numeric
                                  ? TextAlign.right
                                  : TextAlign.left,
                              style: TextStyle(
                                fontFamily: theme.fontFamily,
                                fontSize: PlexFontSize.body,
                                color: colors.textPrimary,
                                fontFeatures: column.numeric
                                    ? const <FontFeature>[
                                        FontFeature.tabularFigures()
                                      ]
                                    : null,
                              ),
                            ),
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
    required this.columnTitle,
    required this.numeric,
    required this.sortable,
    required this.sort,
    required this.onTap,
  });

  final PlexThemeData theme;
  final PlexColorTokens colors;
  final String columnTitle;
  final bool numeric;
  final bool sortable;
  final PlexDataGridSort? sort;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool sorted = sort != null;
    final Color textColor = sorted ? colors.textBrand : colors.textMuted;
    final Widget label = Row(
      children: [
        Expanded(
          child: Text(
            columnTitle.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
      ],
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
