// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// PlexModelGenerator
// **************************************************************************

extension OrderExtensions on Order {
  Order copy() {
    var copyObj = Order();
    copyObj.name = name;
    copyObj.id = id;
    copyObj.names = names;
    copyObj.amount = amount;
    return copyObj;
  }

  String asString() {
    return "Order(name: $name, id: $id, names: $names, amount: $amount)";
  }
}
