class _PlexInjector<T> {
  late String tag;
  late bool singleton;
  T? injector;
  T Function(dynamic parm)? builder;

  _PlexInjector.singleton(this.injector, this.tag) {
    this.singleton = true;
  }

  _PlexInjector.singletonLazy(this.builder, this.tag) {
    this.singleton = true;
  }

  _PlexInjector.factory(this.builder, this.tag) {
    this.singleton = false;
  }

  T getValue({dynamic parm}) {
    if (singleton) {
      injector ??= builder!.call(parm);
      return injector!;
    }
    return builder!.call(parm);
  }
}

final _injectors = List<_PlexInjector>.empty(growable: true);

injectSingleton<T>(T dependency, String tag) {
  if (_injectors.any((inj) => inj.tag == tag)) {
    throw Exception("This type of object is already registered in plex. If you want to register other dependency with same object Please mark it with 'Tag'");
  }
  _injectors.add(_PlexInjector.singleton(dependency, tag));
}

injectSingletonLazy<T>(T Function(dynamic parm) builder, String tag) {
  if (_injectors.any((inj) => inj.tag == tag)) {
    throw Exception("This type of object is already registered in plex. If you want to register other dependency with same object Please mark it with 'Tag'");
  }
  _injectors.add(_PlexInjector.singletonLazy(builder, tag));
}

injectFactory<T>(T Function(dynamic parm) builder, String tag) {
  if (_injectors.any((inj) => inj.tag == tag)) {
    throw Exception("This type of object is already registered in plex. If you want to register other dependency with same object Please mark it with 'Tag'");
  }
  _injectors.add(_PlexInjector.factory(builder, tag));
}

T fromPlex<T>(String tag, {dynamic parm}) {
  return _injectors.firstWhere((element) => element.tag == tag).getValue(parm: parm);
}
