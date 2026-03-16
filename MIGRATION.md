# Migration Guide: Plex 1.x.x to 2.x.x

This guide documents all breaking and additive changes when upgrading from Plex 1.x.x to 2.x.x. Follow the sections relevant to your usage.

---

## Overview

Plex 2.x introduces improvements across networking, dependency injection, state management, routing, database, localization, and accessibility. Most changes are additive; breaking changes are opt-in or clearly marked.

**Versioning policy:**
- Minor versions (1.1.x, 1.2.x, …) add features; breaking changes are avoided.
- Major version 2.x consolidates all phase changes; some APIs are deprecated or replaced.

---

## Quick Migration Checklist

- [ ] **Logging**: Replace `print()` / `debugPrint()` with `PlexLogger` where appropriate
- [ ] **Networking**: Update error handling to use sealed `PlexNetworkError` subclasses; add interceptors if needed
- [ ] **State**: Replace `toast()` / `toastDelayed()` with `context.showMessage()`; consider `runAction(PlexAsyncAction(...))` for loading patterns
- [ ] **DI**: Use `injectScoped` for lifecycle-bounded services; call `closeScope` when done
- [ ] **Routing**: Optionally switch to `PlexGoRouter()` for deep links / web URL sync
- [ ] **Database**: Use `PlexDbConfig` and `migrations` in `PlexDb.initialize()`
- [ ] **Localization**: Add `localizationConfig` and `accessibilityConfig` to `PlexApp` if needed
- [ ] **pubspec**: Ensure `flutter_localizations: sdk: flutter` is present (plex adds it as a dependency)

---

## Phase 1 — Logging (v1.1.x)

### What Changed

- New `PlexLogger` replaces scattered `print()` / `console()` calls.
- Structured logging with levels: `verbose`, `debug`, `info`, `warning`, `error`.
- Optional sinks for forwarding logs to Sentry, Crashlytics, etc.

### New API

```dart
import 'package:plex/plex_utils/plex_logger.dart';

// Set minimum level (release builds suppress verbose/debug by default)
PlexLogger.setLevel(PlexLogLevel.info);

// Log messages
PlexLogger.v('MyTag', 'Verbose message');
PlexLogger.d('MyTag', 'Debug message');
PlexLogger.i('MyTag', 'Info message');
PlexLogger.w('MyTag', 'Warning', error: e, stack: stackTrace);
PlexLogger.e('MyTag', 'Error', error: e, stack: stackTrace);

// Add a custom sink (e.g., Sentry)
PlexLogger.addSink(MyPlexLogSink());
```

### Migration

Replace ad-hoc logging:

```dart
// Before
print('User logged in');
debugPrint('State: $state');

// After
PlexLogger.i('Auth', 'User logged in');
PlexLogger.d('State', 'State: $state');
```

---

## Phase 2 — Networking Overhaul (v1.2.x)

### What Changed

- Sealed error hierarchy: `PlexNetworkTimeout`, `PlexNetworkNoConnectivity`, `PlexNetworkCancelled`, `PlexNetworkServerError`, `PlexNetworkParseError`.
- Interceptor pipeline for auth, retry, logging.
- Request cancellation via `PlexCancelToken`.
- Response caching via `enableCache` / `clearCache`.
- Type-safe `getTyped<T>()` / `postTyped<T>()`.
- `PlexApi` convenience singleton over `PlexNetworking`.

### Breaking Changes

**Error handling** — Use pattern matching instead of checking `PlexError.code`:

```dart
// Before
final result = await PlexNetworking.instance.get('/users');
if (result is PlexError) {
  if (result.code == 408) { /* timeout */ }
  else { /* other error */ }
}

// After
final result = await PlexNetworking.instance.get('/users');
switch (result) {
  case PlexSuccess():
    // use result.response
    break;
  case PlexNetworkTimeout():
    // handle timeout
    break;
  case PlexNetworkNoConnectivity():
    // handle no network
    break;
  case PlexNetworkCancelled():
    // handle cancellation
    break;
  case PlexNetworkServerError(:final statusCode, :final body):
    // handle HTTP error
    break;
  case PlexNetworkParseError(:final cause, :final raw):
    // handle parse error
    break;
  case PlexError(:final code, :final message):
    // legacy / app-level error
    break;
}
```

### New Features

**Interceptors:**

```dart
// Auth interceptor
PlexNetworking.instance.addInterceptor(
  PlexAuthInterceptor(() => getAccessToken()),
);

// Retry interceptor
PlexNetworking.instance.addInterceptor(
  PlexRetryInterceptor(maxAttempts: 3, retryOnStatusCodes: [500, 502, 503]),
);
```

**Request cancellation:**

```dart
final token = PlexCancelToken();
PlexNetworking.instance.get('/slow', cancelToken: token);
// Later: token.cancel();
```

**Type-safe responses:**

```dart
final result = await PlexNetworking.instance.getTyped<User>(
  '/user/1',
  fromJson: (m) => User.fromJson(m),
);
if (result is PlexSuccess<User>) {
  final user = result.typedResponse;
}
```

**Caching:**

```dart
await PlexNetworking.instance.enableCache(
  PlexCacheConfig(maxAge: Duration(minutes: 5)),
  db,
);
```

---

## Phase 3 — State Management (v1.3.x)

### What Changed

- New `PlexAsyncAction<T>` for async tasks with automatic loading/error handling.
- `PlexViewModel.runAction(action)` replaces manual `showLoading` / `try` / `hideLoading` boilerplate.
- `toast()` and `toastDelayed()` are **deprecated**.

### Deprecations

| Deprecated | Replacement |
|------------|-------------|
| `viewModel.toast(message)` | `context.showMessage(message)` |
| `viewModel.toastDelayed(message)` | `context.showMessageDelayed(message)` |
| `state.toast(message)` | `context.showMessage(message)` |
| `state.toastDelayed(message)` | `context.showMessageDelayed(message)` |

### Migration

**Loading pattern:**

```dart
// Before
showLoading();
try {
  final data = await fetchData();
  onSuccess(data);
} catch (e, st) {
  onError(e, st);
} finally {
  hideLoading();
}

// After
runAction(PlexAsyncAction(
  () => fetchData(),
  onSuccess: (data) => onSuccess(data),
  onError: (e, st) => onError(e, st),
));
```

**Toast migration:**

```dart
// Before
toast('Saved successfully');

// After
context.showMessage('Saved successfully');
```

---

## Phase 4 — DI & Lifecycle (v1.4.x)

### What Changed

- `injectScoped<T>()` for lifecycle-bounded singletons.
- `fromScoped<T>()` and `closeScope()` for scoped resolution and cleanup.
- `injectSingletonLazyAsync<T>()` for async initialization.
- `PlexCircularDependencyError` thrown on circular dependency detection.
- `PlexScreen.diScope` override to auto-scope DI to screen lifetime.

### New API

```dart
// Scoped registration (disposed when scope is closed)
injectScoped<CartService>(() => CartService(), scope: 'cart', tag: 'main');

// Scoped resolution (falls back to global if not in scope)
final cart = fromScoped<CartService>(scope: 'cart');

// Close scope and dispose all PlexDisposable instances
await closeScope('cart');

// Async lazy singleton
injectSingletonLazyAsync<RemoteConfig>(() => loadRemoteConfig());
final config = await fromPlexAsync<RemoteConfig>();
```

### Screen-level scope

Override `diScope` in your screen state to auto-create and close a scope:

```dart
class _MyScreenState extends PlexState<MyScreen> {
  @override
  String? get diScope => 'my_screen';
}
```

---

## Phase 5 — Navigation (v1.5.x)

### What Changed

- `PlexApp` accepts optional `router:` parameter.
- Default: `PlexGetXRouter()` (backward compatible).
- New: `PlexGoRouter()` for deep links and web URL sync.
- Route guards: `PlexRouteGuard`, `PlexAuthGuard`, `PlexRoleGuard`.

### Breaking Changes (Opt-in)

If you use `PlexGoRouter`:

- `PlexGoRouter.to(widget)` throws `UnsupportedError` — use `toNamed(path)` instead.

### Migration

**Switching to GoRouter:**

```dart
// Before (implicit GetX)
PlexApp(
  appInfo: appInfo,
  loginConfig: loginConfig,
  dashboardConfig: dashboardConfig,
  // ...
);

// After (GoRouter for deep links / web)
PlexApp(
  appInfo: appInfo,
  loginConfig: loginConfig,
  dashboardConfig: dashboardConfig,
  router: PlexGoRouter(),
  // ...
);
```

**Route guards:**

```dart
PlexRoute(
  path: '/admin',
  guards: [PlexAuthGuard(loginPath: '/Login'), PlexRoleGuard('admin')],
  // ...
);
```

---

## Phase 7 — UI & Widgets (v1.7.x)

### What Changed

- New `PlexWizardForm` multi-step form with `PlexWizardStep`.
- New `PlexValidator` composable validators.
- New form fields: `PlexFormFieldStepper`, `PlexFormFieldColor`, `PlexFormFieldFile`, `PlexFormFieldButton`.

### New API

**Wizard form:**

```dart
PlexWizardForm(
  steps: [
    PlexWizardStep(title: 'Step 1', fields: [/* ... */]),
    PlexWizardStep(title: 'Step 2', fields: [/* ... */]),
  ],
  onComplete: () => /* submit */,
  onCancel: () => /* cancel */,
);
```

**Validators:**

```dart
PlexValidator.required(message: 'Required');
PlexValidator.email(message: 'Invalid email');
PlexValidator.minLength(8, message: 'Min 8 chars');
PlexValidator.maxLength(100);
PlexValidator.pattern(RegExp(r'^\d+$'), message: 'Numbers only');
PlexValidator.compose([PlexValidator.required(), PlexValidator.email()]);
```

---

## Phase 8 — Database Enhancements (v1.8.x)

### What Changed

- `PlexDb.initialize()` requires `PlexDbConfig` and accepts optional `migrations`.
- New `PlexQuery<T>` fluent builder.
- New `PlexRelation` via `hasMany<R>()` / `belongsTo<R>()`.
- Reactive streams: `watchAll()`, `watchById()`.
- `PlexDbMigration` for schema evolution.

### Breaking Changes

**Initialization** — If you previously passed a bare string (or used a different API), wrap in `PlexDbConfig`:

```dart
// Before (if you had custom initialization)
// PlexDb.initialize('mydb');  // hypothetical old API

// After
final db = await PlexDb.initialize(
  PlexDbConfig('mydb'),
  migrations: [
    PlexDbMigration(version: 2, up: (db) async {
      await db.getCollection('orders').addIndex('status');
    }),
  ],
);
```

### New API

**Query builder:**

```dart
final orders = await db
    .getEntityCollection<Order>('orders', fromJson: Order.fromJson, toJson: (o) => o.toJson())
    .query()
    .where('status')
    .equals('pending')
    .where('total')
    .greaterThan(100)
    .orderBy('createdAt', descending: true)
    .limit(20)
    .get();
```

**Relations:**

```dart
final orders = db.getEntityCollection<Order>(...);
final customers = db.getEntityCollection<Customer>(...);

final relation = orders.hasMany<OrderItem>(orderItems, 'orderId');
final items = await relation.loadHasMany(orderId);

final belongsToRel = orders.belongsTo<Customer>(customers, 'customerId');
final customer = await belongsToRel.loadBelongsTo(order);
```

**Reactive streams:**

```dart
db.getEntityCollection<Order>(...).watchAll().listen((orders) => /* update UI */);
```

---

## Phase 9 — Localization & Accessibility (v1.9.x)

### What Changed

- New `PlexStrings` base class for all UI strings.
- New `PlexLocalizationConfig` and `PlexL10nDelegate`.
- New `context.plexStrings` extension.
- New `PlexAccessibilityConfig` (highContrast, largeText, reduceMotion).
- New `context.plexA11y` extension.
- `PlexFormFieldGeneric` gains `semanticLabel`.
- `PlexInfoDialog.show` / `PlexInfoSheet.show`: `okLabel` and `cancelLabel` are nullable and default to localized strings.
- `flutter_localizations` is a required dependency.

### New API

**Localization:**

```dart
// Subclass PlexStrings for translations
class ArabicPlexStrings extends PlexStrings {
  @override
  String get loginTitle => 'تسجيل الدخول';
  // ...
}

PlexApp(
  localizationConfig: PlexLocalizationConfig(
    supportedLocales: [Locale('en'), Locale('ar')],
    translationLoader: (locale) => locale.languageCode == 'ar' ? ArabicPlexStrings() : PlexStrings(),
  ),
  // ...
);
```

**Usage in widgets:**

```dart
Text(context.plexStrings.loginTitle);
```

**Accessibility:**

```dart
PlexApp(
  accessibilityConfig: PlexAccessibilityConfig(
    highContrast: true,
    largeText: true,
    reduceMotion: false,
  ),
  // ...
);
```

**Semantic labels on form fields:**

```dart
PlexFormFieldInput(
  properties: PlexFormFieldGeneric.title('Email', semanticLabel: 'Email address input'),
  // ...
);
```

### Deprecations / Behavior Changes

- `okLabel` and `cancelLabel` in `PlexInfoDialog.show` and `PlexInfoSheet.show` are now nullable. When `null`, they use `context.plexStrings.dialogOk` and `context.plexStrings.dialogCancel`. Explicit values still override.

---

## pubspec.yaml Changes

Add `flutter_localizations` if your app uses Plex localization (plex declares it as a dependency, so it is usually pulled in automatically):

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  plex: ^2.0.0
```

---

## Import Paths Reference

| Feature | Import |
|---------|--------|
| Logging | `package:plex/plex_utils/plex_logger.dart` |
| Networking | `package:plex/plex_networking/plex_networking.dart` |
| Interceptors | `package:plex/plex_networking/plex_interceptor.dart` |
| API convenience | `package:plex/plex_networking/plex_api_calls.dart` |
| DI | `package:plex/plex_di/plex_dependency_injection.dart` |
| Database | `package:plex/plex_database/plex_database.dart` |
| Router | `package:plex/plex_router/plex_router.dart` |
| Route guards | `package:plex/plex_router/plex_route_guard.dart` |
| Localization | `package:plex/plex_l10n/plex_localization.dart` |
| Strings | `package:plex/plex_l10n/plex_strings.dart` |
| Accessibility | `package:plex/plex_accessibility/plex_accessibility.dart` |
| Validators | `package:plex/plex_utils/plex_validator.dart` |

---

## Complete Setup Example (2.x)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await PlexDb.initialize(
    PlexDbConfig('my_app'),
    migrations: [
      PlexDbMigration(version: 2, up: (db) async {
        // schema changes
      }),
    ],
  );

  injectSingletonLazyAsync(() => db);
  PlexNetworking.instance.setBasePath('https://api.example.com');
  PlexNetworking.instance.addInterceptor(PlexAuthInterceptor(() => getToken()));

  runApp(PlexApp(
    appInfo: appInfo,
    loginConfig: loginConfig,
    dashboardConfig: dashboardConfig,
    router: PlexGoRouter(),
    localizationConfig: PlexLocalizationConfig(
      supportedLocales: [Locale('en'), Locale('ar')],
      translationLoader: (l) => l.languageCode == 'ar' ? ArabicPlexStrings() : PlexStrings(),
    ),
    accessibilityConfig: PlexAccessibilityConfig(highContrast: false, largeText: false),
  ));
}
```
