import 'package:plex/plex_database/plex_entity.dart';
import 'package:plex/plex_database/plex_entity_collection.dart';

/// Represents a relation between two entity collections.
///
/// Use [hasMany] for one-to-many (e.g. Order has many OrderItems).
/// Use [belongsTo] for many-to-one (e.g. Order belongs to Customer).
class PlexRelation<T extends PlexEntity, R extends PlexEntity> {
  PlexRelation._({
    required this.ownerCollection,
    required this.relatedCollection,
    required this.foreignKey,
    required this.isHasMany,
  });

  final PlexEntityCollection<T> ownerCollection;
  final PlexEntityCollection<R> relatedCollection;
  final String foreignKey;
  final bool isHasMany;

  /// Load related entities for a [hasMany] relation.
  /// [ownerId] is the primary key of the owner (e.g. order.entityId).
  Future<List<R>> loadHasMany(int ownerId) {
    return relatedCollection
        .query()
        .where(foreignKey)
        .equals(ownerId)
        .get();
  }

  /// Load the related entity for a [belongsTo] relation.
  /// [owner] is the owner entity; [foreignKey] (set in belongsTo) is the field on owner holding the related id.
  Future<R?> loadBelongsTo(T owner) {
    final fkValue = _getFieldValue(ownerCollection, owner, foreignKey);
    if (fkValue == null) return Future.value(null);
    final id = fkValue is int ? fkValue : int.tryParse(fkValue.toString());
    if (id == null) return Future.value(null);
    return relatedCollection.getById(id);
  }
}

extension PlexRelationExtension<T extends PlexEntity> on PlexEntityCollection<T> {
  /// Define a has-many relation: each [T] has many [R] via [foreignKey] on the related collection.
  ///
  /// Example: `orderCollection.hasMany(itemCollection, 'orderId')`
  PlexRelation<T, R> hasMany<R extends PlexEntity>(
    PlexEntityCollection<R> related,
    String foreignKey,
  ) {
    return PlexRelation<T, R>._(
      ownerCollection: this,
      relatedCollection: related,
      foreignKey: foreignKey,
      isHasMany: true,
    );
  }

  /// Define a belongs-to relation: each [T] belongs to one [R] via [localForeignKey] on this entity.
  ///
  /// Example: `orderCollection.belongsTo(customerCollection, 'customerId')`
  PlexRelation<T, R> belongsTo<R extends PlexEntity>(
    PlexEntityCollection<R> related,
    String localForeignKey,
  ) {
    return PlexRelation<T, R>._(
      ownerCollection: this,
      relatedCollection: related,
      foreignKey: localForeignKey,
      isHasMany: false,
    );
  }
}

Object? _getFieldValue<T extends PlexEntity>(
  PlexEntityCollection<T> collection,
  T entity,
  String fieldName,
) {
  final map = collection.toJson(entity);
  return map[fieldName];
}
