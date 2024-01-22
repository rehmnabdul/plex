import 'package:plex/plex_annotations/plex_annotations.dart';

part 'order.plex.dart';

@plexAnnotationModel
class Order {
  late String name;
  late String id;
  late List<String> names;
  late double amount;

  Order();

  Order.withParm({
    required this.name,
    required this.id,
    required this.names,
    required this.amount,
  });
}
