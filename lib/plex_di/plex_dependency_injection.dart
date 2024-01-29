class _PlexInjector<T> {
  late String tag;
  late bool singleton;
  late T injector;
  late T Function() builder;

  _PlexInjector.singleton(this.injector, this.tag) {
    this.singleton = true;
  }

  _PlexInjector.factory(this.builder, this.tag) {
    this.singleton = false;
  }

  T getValue() => singleton ? injector : builder.call();
}

final _injectors = List<_PlexInjector>.empty(growable: true);

injectSingleton<T>(T dependency, String tag) {
  if (_injectors.any((inj) => inj.tag == tag)) {
    throw Exception("This type of object is already registered in plex. If you want to register other dependency with same object Please mark it with 'Tag'");
  }
  _injectors.add(_PlexInjector.singleton(dependency, tag));
}

injectFactory<T>(T Function() builder, String tag) {
  if (_injectors.any((inj) => inj.tag == tag)) {
    throw Exception("This type of object is already registered in plex. If you want to register other dependency with same object Please mark it with 'Tag'");
  }
  _injectors.add(_PlexInjector.factory(builder, tag));
}

T fromPlex<T>(String tag) {
  return _injectors.firstWhere((element) => element.tag == tag).getValue();
}
