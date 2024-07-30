class PlexPair<T1, T2> {
  final T1 first;
  final T2 second;

  PlexPair._(this.first, this.second);

  PlexPair.create(this.first, this.second);
}

class PlexTriplet<T1, T2, T3> {
  final T1 first;
  final T2 second;
  final T2 third;

  PlexTriplet._(this.first, this.second, this.third);

  PlexTriplet.create(this.first, this.second, this.third);
}