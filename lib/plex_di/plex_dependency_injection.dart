class _PlexInjector<T> {
  late String? tag;
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

bool _isInjected<T>(_PlexInjector<T> dependency, {String? tag}) {
  var elements = _injectors.whereType<_PlexInjector<T>>().cast<_PlexInjector>().toList();
  if(tag != null) {
    elements = elements.where((element) => element.tag == tag).toList();
  } else {
    elements = elements.where((element) => element.tag == null).toList();
  }
  return elements.isNotEmpty;
}

injectSingleton<T>(T dependency, {String? tag}) {
  var plexDependency = _PlexInjector<T>.singleton(dependency, tag);
  if (_isInjected(plexDependency, tag: tag)) {
    throw Exception("This type of object is already registered in plex. If you want to register other dependency with same object Please mark it with 'Tag'");
  }
  _injectors.add(plexDependency);
}

injectSingletonLazy<T>(T Function(dynamic parm) builder, {String? tag}) {
  var plexDependency = _PlexInjector<T>.singletonLazy(builder, tag);
  if (_isInjected(plexDependency, tag: tag)) {
    throw Exception("This type of object is already registered in plex. If you want to register other dependency with same object Please mark it with 'Tag'");
  }
  _injectors.add(plexDependency);
}

injectFactory<T>(T Function(dynamic parm) builder, {String? tag}) {
  var plexDependency = _PlexInjector<T>.factory(builder, tag);
  if (_isInjected(plexDependency, tag: tag)) {
    throw Exception("This type of object is already registered in plex. If you want to register other dependency with same object Please mark it with 'Tag'");
  }
  _injectors.add(plexDependency);
}

T fromPlex<T>({String? tag, dynamic parm}) {
  var elements = _injectors.whereType<_PlexInjector<T>>().cast<_PlexInjector>().toList();
  if(tag != null) {
    elements = elements.where((element) => element.tag == tag).toList();
  } else {
    elements = elements.where((element) => element.tag == null).toList();
  }
  return elements.first.getValue(parm: parm);
}
