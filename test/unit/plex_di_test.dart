import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_di/plex_dependency_injection.dart';

void main() {
  group('PlexDI', () {
    setUp(() {
      // Reset injectors between tests by using unique types
      // Note: The current DI implementation doesn't support reset,
      // so we use unique type+tag combinations per test
    });

    test('injectSingleton and fromPlex return same instance', () {
      final instance = _TestService();
      injectSingleton<_TestService>(instance);

      final resolved = fromPlex<_TestService>();
      expect(resolved, same(instance));
    });

    test('injectSingletonLazy creates instance on first access', () {
      var createCount = 0;
      injectSingletonLazy<_LazyService>((_) {
        createCount++;
        return _LazyService();
      });

      expect(createCount, 0);

      final first = fromPlex<_LazyService>();
      expect(createCount, 1);

      final second = fromPlex<_LazyService>();
      expect(createCount, 1);
      expect(first, same(second));
    });

    test('injectFactory creates new instance each time', () {
      var createCount = 0;
      injectFactory<_FactoryService>((_) {
        createCount++;
        return _FactoryService();
      });

      final first = fromPlex<_FactoryService>();
      final second = fromPlex<_FactoryService>();

      expect(createCount, 2);
      expect(first, isNot(same(second)));
    });

    test('injectSingleton with tag resolves correctly', () {
      final instanceA = _TaggedService('A');
      final instanceB = _TaggedService('B');
      injectSingleton<_TaggedService>(instanceA, tag: 'tagA');
      injectSingleton<_TaggedService>(instanceB, tag: 'tagB');

      expect(fromPlex<_TaggedService>(tag: 'tagA').id, 'A');
      expect(fromPlex<_TaggedService>(tag: 'tagB').id, 'B');
    });

    test('injectSingletonLazy passes parm to builder', () {
      injectSingletonLazy<_ParamService>((parm) => _ParamService(parm as int));

      final resolved = fromPlex<_ParamService>(parm: 99);
      expect(resolved.value, 99);
    });

    test('injectScoped and fromScoped resolve within scope', () {
      injectScoped<_ScopedService>(
        () => _ScopedService('scoped'),
        scope: 'test',
      );

      final resolved = fromScoped<_ScopedService>(scope: 'test');
      expect(resolved.id, 'scoped');
    });

    test('fromScoped falls back to global when not in scope', () {
      injectSingleton<_ScopedService>(_ScopedService('global'));

      final resolved = fromScoped<_ScopedService>(scope: 'empty');
      expect(resolved.id, 'global');
    });

    test('closeScope disposes PlexDisposable instances', () async {
      var disposed = false;
      injectScoped<_DisposableService>(
        () => _DisposableService(() => disposed = true),
        scope: 'dispose_test',
      );

      final resolved = fromScoped<_DisposableService>(scope: 'dispose_test');
      expect(resolved, isNotNull);

      await closeScope('dispose_test');
      expect(disposed, true);
    });

    test('injectSingletonLazyAsync and fromPlexAsync work', () async {
      var initCount = 0;
      injectSingletonLazyAsync<_AsyncService>(() async {
        initCount++;
        await Future.delayed(const Duration(milliseconds: 10));
        return _AsyncService();
      });

      expect(initCount, 0);

      final first = await fromPlexAsync<_AsyncService>();
      expect(initCount, 1);

      final second = await fromPlexAsync<_AsyncService>();
      expect(initCount, 1);
      expect(first, same(second));
    });

    test('circular dependency throws PlexCircularDependencyError', () {
      injectSingletonLazy<_CircularA>((_) => _CircularA());
      injectSingletonLazy<_CircularB>((_) => _CircularB());

      expect(
        () => fromPlex<_CircularA>(),
        throwsA(isA<PlexCircularDependencyError>()),
      );
    });
  });
}

class _TestService {}

class _LazyService {}

class _FactoryService {}

class _TaggedService {
  final String id;
  _TaggedService(this.id);
}

class _ParamService {
  final int value;
  _ParamService(this.value);
}

class _ScopedService {
  final String id;
  _ScopedService(this.id);
}

class _DisposableService with PlexDisposable {
  final void Function() onDispose;
  _DisposableService(this.onDispose);

  @override
  Future<void> dispose() async {
    onDispose();
  }
}

class _AsyncService {}

class _CircularA {
  late final _CircularB _b;
  _CircularA() {
    _b = fromPlex<_CircularB>();
  }
}

class _CircularB {
  late final _CircularA _a;
  _CircularB() {
    _a = fromPlex<_CircularA>();
  }
}
