import 'package:plex/plex_database/plex_collection.dart';
import 'package:plex/plex_database/plex_entity.dart';
import 'package:sembast/sembast.dart';

/// Interface for collections that support querying. Implemented by [PlexEntityCollection].
abstract class PlexQueryable<T extends PlexEntity> {
  PlexCollection get collection;
  List<T> mapFromMaps(List<Map<String, dynamic>> maps);
}

/// Fluent query builder for [PlexQueryable] (e.g. [PlexEntityCollection]).
///
/// Example:
/// ```dart
/// final orders = await db.getEntityCollection<Order>('orders', ...)
///   .query()
///   .where('status').equals('pending')
///   .where('total').greaterThan(100)
///   .orderBy('createdAt', descending: true)
///   .limit(20)
///   .get();
/// ```
class PlexQuery<T extends PlexEntity> {
  PlexQuery(this._source);

  final PlexQueryable<T> _source;
  final List<Filter> _filters = [];
  final List<SortOrder> _sortOrders = [];
  int? _limit;
  int? _offset;

  /// Start a filter on [field].
  PlexQueryField<T> where(String field) => PlexQueryField<T>(this, field);

  /// Add a raw [Filter] (for advanced use).
  PlexQuery<T> filter(Filter f) {
    _filters.add(f);
    return this;
  }

  /// Add sort order.
  PlexQuery<T> orderBy(String field, {bool descending = false}) {
    _sortOrders.add(SortOrder(field, descending));
    return this;
  }

  /// Limit number of results.
  PlexQuery<T> limit(int n) {
    _limit = n;
    return this;
  }

  /// Skip [n] results.
  PlexQuery<T> offset(int n) {
    _offset = n;
    return this;
  }

  Finder _buildFinder() {
    Filter? filter;
    if (_filters.isEmpty) {
      filter = null;
    } else if (_filters.length == 1) {
      filter = _filters.single;
    } else {
      filter = Filter.and(_filters);
    }
    return Finder(
      filter: filter,
      sortOrders: _sortOrders.isEmpty ? null : _sortOrders,
      limit: _limit,
      offset: _offset,
    );
  }

  /// Execute query and return all matching entities.
  Future<List<T>> get() async {
    final maps = await _source.collection.findWithFinder(_buildFinder());
    return _source.mapFromMaps(maps);
  }

  /// Return first matching entity or null.
  Future<T?> first() async {
    final finder = Finder(
      filter: _filters.isEmpty
          ? null
          : _filters.length == 1
              ? _filters.single
              : Filter.and(_filters),
      sortOrders: _sortOrders.isEmpty ? null : _sortOrders,
      limit: 1,
      offset: _offset,
    );
    final maps = await _source.collection.findWithFinder(finder);
    if (maps.isEmpty) return null;
    return _source.mapFromMaps(maps).first;
  }

  /// Count matching records.
  Future<int> count() async {
    return _source.collection.countWithFinder(_buildFinder());
  }

  /// Delete all matching records.
  Future<void> deleteAll() async {
    await _source.collection.deleteWithFinder(_buildFinder());
  }

  /// Stream of matching entities; emits whenever data changes.
  Stream<List<T>> watch() {
    return _source.collection
        .watchWithFinder(_buildFinder())
        .map((maps) => _source.mapFromMaps(maps));
  }
}

/// Represents a field in a query for chaining conditions.
class PlexQueryField<T extends PlexEntity> {
  PlexQueryField(this.query, this._field);

  final PlexQuery<T> query;
  final String _field;

  PlexQuery<T> equals(Object? value) =>
      query.filter(Filter.equals(_field, value));

  PlexQuery<T> notEquals(Object? value) =>
      query.filter(Filter.notEquals(_field, value));

  PlexQuery<T> greaterThan(Object value) =>
      query.filter(Filter.greaterThan(_field, value));

  PlexQuery<T> greaterThanOrEquals(Object value) =>
      query.filter(Filter.greaterThanOrEquals(_field, value));

  PlexQuery<T> lessThan(Object value) =>
      query.filter(Filter.lessThan(_field, value));

  PlexQuery<T> lessThanOrEquals(Object value) =>
      query.filter(Filter.lessThanOrEquals(_field, value));

  PlexQuery<T> contains(String value, {bool caseInsensitive = false}) =>
      query.filter(Filter.matchesRegExp(
        _field,
        RegExp(RegExp.escape(value), caseSensitive: !caseInsensitive),
      ));

  PlexQuery<T> isIn(List<Object> values) =>
      query.filter(Filter.inList(_field, values));

  PlexQuery<T> isNull() => query.filter(Filter.isNull(_field));

  PlexQuery<T> isNotNull() => query.filter(Filter.notNull(_field));
}
