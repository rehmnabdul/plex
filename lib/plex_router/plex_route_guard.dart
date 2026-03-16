import 'package:plex/plex_user.dart';

/// Context passed to [PlexRouteGuard] when evaluating a route.
class PlexRouteContext {
  const PlexRouteContext({
    required this.path,
    this.currentUser,
  });

  final String path;
  final PlexUser? currentUser;
}

/// Guard that can redirect before navigation. Return null to allow, or a path to redirect.
abstract class PlexRouteGuard {
  /// Returns null to allow navigation, or a route path to redirect to.
  Future<String?> redirect(PlexRouteContext context);
}

/// Redirects to [loginPath] if [currentUser] is null.
class PlexAuthGuard extends PlexRouteGuard {
  PlexAuthGuard({this.loginPath = '/Login'});

  final String loginPath;

  @override
  Future<String?> redirect(PlexRouteContext context) async {
    if (context.currentUser == null) return loginPath;
    return null;
  }
}

/// Redirects (excludes route) if user lacks the required [rule].
class PlexRoleGuard extends PlexRouteGuard {
  PlexRoleGuard(this.rule);

  final String rule;

  @override
  Future<String?> redirect(PlexRouteContext context) async {
    if (context.currentUser == null) return null; // No user — let other guards handle auth
    final rules = context.currentUser!.getLoggedInRules();
    if (rules == null || rules.isEmpty) return '/'; // Exclude: user has no rules
    if (!rules.contains(rule)) return '/'; // Exclude: user lacks this rule
    return null;
  }
}

/// Evaluates guards for a route. If [guards] is empty and [rule] is set, uses [PlexRoleGuard].
/// Returns true if the route is allowed, false if any guard redirects.
Future<bool> evaluateRouteGuards(
  List<PlexRouteGuard> guards,
  String? rule,
  PlexRouteContext context,
) async {
  final effectiveGuards =
      guards.isEmpty && rule != null ? [PlexRoleGuard(rule)] : guards;
  for (final guard in effectiveGuards) {
    final redirect = await guard.redirect(context);
    if (redirect != null) return false;
  }
  return true;
}
