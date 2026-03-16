/// Mixin for services that need cleanup when their scope is closed.
mixin PlexDisposable {
  Future<void> dispose();
}

class PlexCircularDependencyError extends Error {
  final List<String> chain;
  PlexCircularDependencyError(this.chain);

  @override
  String toString() =>
      'PlexCircularDependencyError: Circular dependency detected: ${chain.join(' → ')}';
}

class _PlexInjector<T> {
  late String? tag;
  late bool singleton;
  T? injector;
  T Function(dynamic parm)? builder;
  Future<T> Function()? _asyncBuilder;
  Future<T>? _asyncInstance;

  _PlexInjector.singleton(this.injector, this.tag) {
    this.singleton = true;
  }

  _PlexInjector.singletonLazy(this.builder, this.tag) {
    this.singleton = true;
  }

  _PlexInjector.singletonLazyAsync(this._asyncBuilder, this.tag) {
    this.singleton = true;
  }

  _PlexInjector.factory(this.builder, this.tag) {
    this.singleton = false;
  }

  Object? get resolvedInstanceForDispose => injector;
  bool get isAsync => _asyncBuilder != null;

  T getValue({dynamic parm}) {
    if (singleton) {
      injector ??= builder!.call(parm);
      return injector!;
    }
    return builder!.call(parm);
  }

  Future<T> getValueAsync() async {
    if (singleton) {
      _asyncInstance ??= _asyncBuilder!();
      return await _asyncInstance!;
    }
    return await _asyncBuilder!();
  }
}

final _injectors = List<_PlexInjector>.empty(growable: true);
final _scopedInjectors = <String, List<_PlexInjector>>{};
final _resolutionStack = <String>[];

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

bool _isInjectedScoped<T>(List<_PlexInjector> list, {String? tag}) {
  var elements = list.whereType<_PlexInjector<T>>().cast<_PlexInjector>().toList();
  if (tag != null) {
    elements = elements.where((element) => element.tag == tag).toList();
  } else {
    elements = elements.where((element) => element.tag == null).toList();
  }
  return elements.isNotEmpty;
}

injectScoped<T>(T Function() builder, {required String scope, String? tag}) {
  final list = _scopedInjectors.putIfAbsent(scope, () => []);
  var plexDependency = _PlexInjector<T>.singletonLazy((parm) => builder(), tag);
  if (_isInjectedScoped<T>(list, tag: tag)) {
    throw Exception("This type of object is already registered in scope '$scope'. If you want to register other dependency with same object Please mark it with 'Tag'");
  }
  list.add(plexDependency);
}

T fromScoped<T>({required String scope, String? tag, dynamic parm}) {
  final list = _scopedInjectors[scope];
  if (list != null) {
    var elements = list.whereType<_PlexInjector<T>>().cast<_PlexInjector>().toList();
    if (tag != null) {
      elements = elements.where((element) => element.tag == tag).toList();
    } else {
      elements = elements.where((element) => element.tag == null).toList();
    }
    if (elements.isNotEmpty) return elements.first.getValue(parm: parm);
  }
  return fromPlex<T>(tag: tag, parm: parm);
}

Future<void> closeScope(String scope) async {
  final list = _scopedInjectors.remove(scope);
  if (list == null) return;
  for (final injector in list) {
    final instance = injector.resolvedInstanceForDispose;
    if (instance != null && instance is PlexDisposable) {
      await instance.dispose();
    }
  }
}

injectSingletonLazyAsync<T>(Future<T> Function() builder, {String? tag}) {
  var plexDependency = _PlexInjector<T>.singletonLazyAsync(builder, tag);
  if (_isInjected(plexDependency, tag: tag)) {
    throw Exception("This type of object is already registered in plex. If you want to register other dependency with same object Please mark it with 'Tag'");
  }
  _injectors.add(plexDependency);
}

T fromPlex<T>({String? tag, dynamic parm}) {
  final key = '${T}${tag ?? ''}';
  if (_resolutionStack.contains(key)) {
    throw PlexCircularDependencyError([..._resolutionStack, key]);
  }
  _resolutionStack.add(key);
  try {
    var elements = _injectors.whereType<_PlexInjector<T>>().cast<_PlexInjector>().toList();
    if (tag != null) {
      elements = elements.where((element) => element.tag == tag).toList();
    } else {
      elements = elements.where((element) => element.tag == null).toList();
    }
    if (elements.isEmpty) {
      throw Exception("No Dependency Provided\n\nPlease use injectSingleton(...), injectSingletonLazy(...) or injectFactory(...)\n");
    }
    return elements.first.getValue(parm: parm);
  } finally {
    _resolutionStack.remove(key);
  }
}

Future<T> fromPlexAsync<T>({String? tag}) async {
  var elements = _injectors.whereType<_PlexInjector<T>>().toList();
  if (tag != null) {
    elements = elements.where((element) => element.tag == tag).toList();
  } else {
    elements = elements.where((element) => element.tag == null).toList();
  }
  elements = elements.where((e) => e.isAsync).toList();
  if (elements.isEmpty) {
    throw Exception("No async dependency provided for $T. Use injectSingletonLazyAsync(...)");
  }
  final injector = elements.first;
  return injector.getValueAsync();
}
