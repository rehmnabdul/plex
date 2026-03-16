import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plex/plex_widgets/plex_data_table.dart';
import 'package:plex/plex_widgets/plex_data_table_paginated.dart';

/// Export format for [PlexTableFeatures].
enum PlexExportFormat {
  xlsx,
  pdf,
}

/// Source type for [PlexDataTableUnified].
enum PlexTableSourceType {
  list,
  paginated,
  stream,
}

/// Data source for [PlexDataTableUnified].
class PlexTableSource {
  PlexTableSource._({
    required this.type,
    this.rows,
    this.fetchFn,
    this.dataStream,
  });

  final PlexTableSourceType type;
  final List<List<PlexDataCell>>? rows;
  final Future<List<List<PlexDataCell>>> Function(int page)? fetchFn;
  final Stream<List<List<PlexDataCell>>>? dataStream;

  /// Create a source from an in-memory list.
  static PlexTableSource list(List<List<PlexDataCell>> rows) {
    return PlexTableSource._(type: PlexTableSourceType.list, rows: rows);
  }

  /// Create a source that fetches pages asynchronously.
  static PlexTableSource paginated(
    Future<List<List<PlexDataCell>>> Function(int page) fetchFn,
  ) {
    return PlexTableSource._(type: PlexTableSourceType.paginated, fetchFn: fetchFn);
  }

  /// Create a source from a stream of row lists.
  static PlexTableSource stream(Stream<List<List<PlexDataCell>>> dataStream) {
    return PlexTableSource._(type: PlexTableSourceType.stream, dataStream: dataStream);
  }
}

/// Feature flags for [PlexDataTableUnified].
class PlexTableFeatures {
  const PlexTableFeatures({
    this.search = false,
    this.export = const [],
    this.groupBy = false,
    this.editing = false,
    this.print = false,
  });

  final bool search;
  final List<PlexExportFormat> export;
  final bool groupBy;
  final bool editing;
  final bool print;
}

/// Unified data table that delegates to existing Plex table widgets.
class PlexDataTableUnified extends StatefulWidget {
  const PlexDataTableUnified({
    super.key,
    required this.source,
    required this.columns,
    this.features = const PlexTableFeatures(),
    this.title,
  });

  final PlexTableSource source;
  final List<PlexDataCell> columns;
  final PlexTableFeatures features;
  final String? title;

  @override
  State<PlexDataTableUnified> createState() => _PlexDataTableUnifiedState();
}

class _PlexDataTableUnifiedState extends State<PlexDataTableUnified> {
  List<List<PlexDataCell>>? _streamRows;
  StreamSubscription<List<List<PlexDataCell>>>? _subscription;

  @override
  void initState() {
    super.initState();
    if (widget.source.type == PlexTableSourceType.stream &&
        widget.source.dataStream != null) {
      _subscription = widget.source.dataStream!.listen((rows) {
        if (mounted) setState(() => _streamRows = rows);
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.source.type) {
      case PlexTableSourceType.list:
        return PlexDataTableWithPages(
          columns: widget.columns,
          rows: widget.source.rows ?? [],
          enableSearch: widget.features.search,
          enablePrint: widget.features.print,
          enableCopy: true,
        );
      case PlexTableSourceType.paginated:
        return _PaginatedTable(
          source: widget.source,
          columns: widget.columns,
          features: widget.features,
        );
      case PlexTableSourceType.stream:
        return PlexDataTableWithPages(
          columns: widget.columns,
          rows: _streamRows ?? [],
          enableSearch: widget.features.search,
          enablePrint: widget.features.print,
          enableCopy: true,
        );
    }
  }
}

class _PaginatedTable extends StatefulWidget {
  const _PaginatedTable({
    required this.source,
    required this.columns,
    required this.features,
  });

  final PlexTableSource source;
  final List<PlexDataCell> columns;
  final PlexTableFeatures features;

  @override
  State<_PaginatedTable> createState() => _PaginatedTableState();
}

class _PaginatedTableState extends State<_PaginatedTable> {
  List<List<PlexDataCell>> _rows = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadPage(0);
  }

  Future<void> _loadPage(int page) async {
    if (widget.source.fetchFn == null) return;
    setState(() => _loading = true);
    try {
      final rows = await widget.source.fetchFn!(page);
      if (mounted) {
        setState(() {
          if (page == 0) {
            _rows = rows;
          } else {
            _rows.addAll(rows);
          }
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlexDataTable(
      columns: widget.columns,
      rows: _loading && _rows.isEmpty ? null : _rows,
      enableSearch: widget.features.search,
      enablePrint: widget.features.print,
      enableCopy: true,
      onLoadMore: (page) => _loadPage(page),
      showShimmer: _loading && _rows.isEmpty,
    );
  }
}
