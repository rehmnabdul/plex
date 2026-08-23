import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_utils/plex_widgets.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_backgrounds/plex_background.dart';
import 'package:plex/plex_widgets/plex_card.dart';
import 'package:plex/plex_widgets/plex_card_glass.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

/// Login page chrome. [split] is the package default (Loop Console anatomy,
/// without third-party branding). Pass [centered] to keep the historic card.
enum PlexLoginLayout {
  split,
  centered,
}

class PlexLoginConfig {
  PlexLoginConfig({
    required this.onLogin,
    required this.userFromJson,
    this.additionalWidgetsTop,
    this.additionalWidgetsAboveLoginButton,
    this.additionalWidgetsBottom,
    this.debugUsername,
    this.debugPassword,
    this.username,
    this.password,
    this.passwordMinLength,
    this.passwordMaxLength,
    this.createWidget,
    this.useBackground = false,
    this.backgroundType = PlexBackgroundType.neoGlass,
    this.layout = PlexLoginLayout.split,
    this.brandHeadline,
    this.brandSubtitle,
    this.brandFooter,
    this.formTitle,
    this.formHint,
  });

  final bool useBackground;
  final PlexBackgroundType backgroundType;

  /// Visual layout. Defaults to [PlexLoginLayout.split].
  final PlexLoginLayout layout;

  /// Optional copy on the split brand panel. When null, [PlexAppInfo.title] is used.
  final String? brandHeadline;

  /// Optional supporting line on the split brand panel. Omitted when null.
  final String? brandSubtitle;

  /// Optional footer on the split brand panel. Version name is used when null.
  final String? brandFooter;

  /// Optional heading above the split-layout form fields.
  final String? formTitle;

  /// Optional muted hint under [formTitle]. Omitted when null.
  final String? formHint;

  final String? debugUsername;
  final String? debugPassword;
  final String? password;
  final String? username;
  final int? passwordMinLength;
  final int? passwordMaxLength;
  final Future<PlexUser?> Function(
      BuildContext context, String email, String password) onLogin;
  final Widget Function(BuildContext context)? additionalWidgetsTop;
  final Widget Function(BuildContext context)?
      additionalWidgetsAboveLoginButton;
  final Widget Function(BuildContext context)? additionalWidgetsBottom;
  final PlexUser Function(Map<String, dynamic> userData) userFromJson;

  //Custom
  final Widget Function(BuildContext context)? createWidget;
}

class PlexLoginScreen extends PlexScreen {
  static const Key splitLayoutKey = Key('plex-login-split');
  static const Key centeredLayoutKey = Key('plex-login-centered');
  static const Key brandPanelKey = Key('plex-login-brand-panel');

  const PlexLoginScreen({
    super.key,
    super.useScaffold,
    super.useBackground,
    super.backgroundType,
    required this.loginConfig,
    required this.nextRoute,
  });

  final String nextRoute;
  final PlexLoginConfig loginConfig;

  @override
  PlexState<PlexLoginScreen> createState() => _PlexLoginScreenState();
}

class _PlexLoginScreenState extends PlexState<PlexLoginScreen> {
  var usernameController = TextEditingController();
  var usernameErrorController = PlexWidgetController();
  var passController = TextEditingController();
  var passErrorController = PlexWidgetController();
  var rememberUserController = PlexWidgetController<bool>(data: true);

  @override
  void initState() {
    super.initState();

    if (PlexSp.instance.getString(PlexSp.loggedInUser) != null) {
      Future.delayed(const Duration(milliseconds: 100),
          () => Plex.offAndToNamed(PlexRoutesPaths.homePath));
      return;
    }

    if (kDebugMode && widget.loginConfig.debugUsername != null) {
      usernameController.text = widget.loginConfig.debugUsername ?? "";
      passController.text = widget.loginConfig.debugPassword ?? "";
    } else {
      if (widget.loginConfig.username != null) {
        usernameController.text = widget.loginConfig.username ?? "";
        passController.text = widget.loginConfig.password ?? "";
      }
    }
  }

  _loginAction() async {
    var username = usernameController.text.trim();
    if (username.isEmpty) {
      usernameErrorController.setValue("Username can't be empty");
      return;
    }
    if (passController.text.isEmpty) {
      passErrorController.setValue("Password can't be empty");
      return;
    }

    await _login(username, passController.text.toString());
  }

  @override
  Widget buildBody() {
    if (PlexSp.instance.getString(PlexSp.loggedInUser) != null) {
      return Container();
    }

    if (widget.loginConfig.createWidget != null) {
      return widget.loginConfig.createWidget!(context);
    }

    if (widget.loginConfig.layout == PlexLoginLayout.centered) {
      return _buildCenteredLayout();
    }
    return _buildSplitLayout();
  }

  Widget _buildCenteredLayout() {
    return Center(
      key: PlexLoginScreen.centeredLayoutKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            spaceMedium(),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 350),
                child: _wrapFormChrome(_buildLoginForm(showLogo: true))
                    .scaleAnim(),
              ),
            ),
            spaceMedium(),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitLayout() {
    final bool showBrand = !smallScreen;
    return SizedBox.expand(
      key: PlexLoginScreen.splitLayoutKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showBrand) Expanded(flex: 105, child: _buildBrandPanel()),
          Expanded(
            flex: 100,
            child: ColoredBox(
              color: PlexThemeData.of(context).colors.surfaceCard,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(PlexDim.largePlus),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: _wrapFormChrome(
                      _buildLoginForm(
                          showLogo: !showBrand, showFormHeading: true),
                    ).scaleAnim(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandPanel() {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final String headline =
        widget.loginConfig.brandHeadline ?? PlexApp.app.appInfo.title;
    final String? subtitle = widget.loginConfig.brandSubtitle;
    final String? footer =
        widget.loginConfig.brandFooter ?? PlexApp.app.appInfo.versionName;

    return Container(
      key: PlexLoginScreen.brandPanelKey,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.4,
          colors: <Color>[
            colors.surfaceInverse,
            colors.brandInk,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: PlexDim.extraLargeMinus,
        vertical: PlexDim.largePlus,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: PlexDim.extraLarge,
            child:
                PlexApp.app.appInfo.appLogoDark ?? PlexApp.app.getLogo(context),
          ),
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: TextStyle(
                    color: colors.textInverse,
                    fontWeight: FontWeight.w900,
                    fontSize: PlexFontSize.displaySmall,
                    height: 1.1,
                    letterSpacing: -0.4,
                  ),
                ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  spaceMedium(),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colors.textInverse.withValues(alpha: 0.7),
                      fontSize: PlexFontSize.large,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
          if (footer != null)
            Text(
              footer,
              style: TextStyle(
                color: colors.textInverse.withValues(alpha: 0.5),
                fontSize: PlexFontSize.small,
              ),
            ),
        ],
      ),
    );
  }

  Widget _wrapFormChrome(Widget loginWidget) {
    if (widget.useBackground &&
        widget.backgroundType == PlexBackgroundType.neoGlass) {
      return PlexCardGlassEffect(child: loginWidget);
    }
    if (widget.loginConfig.layout == PlexLoginLayout.centered) {
      return PlexCard(child: loginWidget);
    }
    return loginWidget;
  }

  Widget _buildLoginForm(
      {required bool showLogo, bool showFormHeading = false}) {
    return Padding(
      padding: const EdgeInsets.all(PlexDim.medium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.loginConfig.additionalWidgetsTop != null) ...{
            widget.loginConfig.additionalWidgetsTop!.call(context),
          },
          if (showLogo) ...[
            SizedBox(
              height: 100,
              child: PlexApp.app.getLogo(context),
            ),
            spaceMedium(),
          ],
          if (showFormHeading) ...[
            Text(
              widget.loginConfig.formTitle ?? 'Sign in',
              style: TextStyle(
                color: PlexThemeData.of(context).colors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: PlexFontSize.extraLarge,
                letterSpacing: -0.4,
              ),
            ),
            if (widget.loginConfig.formHint != null) ...[
              spaceSmallest(),
              Text(
                widget.loginConfig.formHint!,
                style: TextStyle(
                  color: PlexThemeData.of(context).colors.textMuted,
                  fontSize: PlexFontSize.body,
                ),
              ),
            ],
            spaceMedium(),
          ],
          PlexFormFieldInput(
            properties: const PlexFormFieldGeneric.title("Username / Email"),
            inputHint: "Enter Your Email or Username",
            inputController: usernameController,
            errorController: usernameErrorController,
          ),
          PlexFormFieldInput(
            properties: const PlexFormFieldGeneric.title("Password"),
            inputHint: "Enter Your Password",
            inputController: passController,
            errorController: passErrorController,
            isPassword: true,
            maxInputLength: widget.loginConfig.passwordMaxLength,
            inputOnSubmit: (value) => _loginAction(),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PlexDim.medium, right: PlexDim.small),
            child: Row(
              children: [
                const Expanded(child: Text("Remember User")),
                spaceMedium(),
                PlexWidget<bool>(
                  controller: rememberUserController,
                  createWidget: (context, data) {
                    return Checkbox(
                      value: data,
                      onChanged: (value) {
                        rememberUserController.setValue(value);
                      },
                    );
                  },
                )
              ],
            ),
          ),
          if (widget.loginConfig.additionalWidgetsAboveLoginButton != null) ...{
            widget.loginConfig.additionalWidgetsAboveLoginButton!.call(context),
          },
          PlexFormFieldButton(
            properties: PlexFormFieldGeneric(title: "Login", useMargin: false),
            buttonIcon: const Icon(Icons.login),
            expanded: widget.loginConfig.layout == PlexLoginLayout.split,
            buttonClick: () => _loginAction(),
          ),
          if (_getRecentLogins().isNotEmpty) ...{
            Row(
              children: [
                spaceMedium(),
                const Text("Recent Logins",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            spaceSmall(),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: PlexDim.small,
              runSpacing: PlexDim.small,
              children: [
                ..._getRecentLogins().map((e) => _getRecentLoginWidget(e)),
              ],
            ),
            spaceSmall(),
          },
          if (widget.loginConfig.additionalWidgetsBottom != null) ...{
            widget.loginConfig.additionalWidgetsBottom!.call(context),
          },
          spaceSmall(),
          if (PlexApp.app.appInfo.versionName != null) ...[
            Text("Version: ${PlexApp.app.appInfo.versionName}"),
          ],
        ],
      ),
    );
  }

  Future _login(String username, String password) async {
    showLoading();
    var result = await widget.loginConfig.onLogin(context, username, password);
    hideLoading();

    if (result != null) {
      result.save();
      if (rememberUserController.data == true) {
        rememberUser(result, username, passController.text.toString());
      }
      Plex.offAndToNamed(PlexApp.app.dashboardConfig != null
          ? PlexRoutesPaths.homePath
          : PlexApp.app.appInfo.initialRoute);
    }
  }

  String getUserProperty(String userData, int location) {
    // 0 => UserName
    // 1 => Pass
    // 2 => FullName
    // 3 => Initials
    // 4 => Picture
    var splits = userData.split("|");
    if (splits.isEmpty) return "N/A";
    if (location == 0) {
      return splits.isNotEmpty ? splits[0] : "N/A";
    } else if (location == 1) {
      return splits.length > 1 ? splits[1] : "N/A";
    } else if (location == 2) {
      return splits.length > 2 ? splits[2] : "N/A";
    } else if (location == 3) {
      return splits.length > 3 ? splits[3] : "N/A";
    } else if (location == 4) {
      return splits.length > 4 ? splits[4] : "N/A";
    }
    return "N/A";
  }

  void rememberUser(PlexUser plexUser, String username, String password) {
    var rememberedUsers = PlexSp.instance.getList(PlexSp.rememberUsers) ??
        List.empty(growable: true);
    if (rememberedUsers
            .firstWhereOrNull((e) => getUserProperty(e, 0) == username) ==
        null) {
      rememberedUsers.add(
          "$username|$password|${plexUser.getLoggedInFullName()}|${plexUser.getInitials()}|${plexUser.getPictureUrl() ?? ""}");
      if (rememberedUsers.length > 3) {
        rememberedUsers = rememberedUsers.sublist(rememberedUsers.length - 3);
      }
      PlexSp.instance.setList(PlexSp.rememberUsers, rememberedUsers);
    }
  }

  List<String> _getRecentLogins() {
    return PlexSp.instance.getList(PlexSp.rememberUsers) ?? List.empty();
  }

  _deleteRecentLogins(String e) {
    var users = PlexSp.instance.getList(PlexSp.rememberUsers) ?? List.empty();
    users.remove(e);
    PlexSp.instance.setList(PlexSp.rememberUsers, users);
  }

  _getRecentLoginWidget(String e) {
    return Row(children: [
      Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: Tooltip(
            message: getUserProperty(e, 2),
            child: Container(
              decoration: BoxDecoration(
                color: PlexTheme.getActiveTheme(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge,
              child:
                  getUserProperty(e, 4) != "N/A" && getUserProperty(e, 4) != ""
                      ? CachedNetworkImage(
                          imageUrl: getUserProperty(e, 4),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            debugPrint(downloadProgress.progress.toString());
                            return Stack(
                              children: [
                                Center(
                                  child: Text(
                                    getUserProperty(e, 3),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: PlexFontSize.normal),
                                  ),
                                ),
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.yellowAccent,
                                    value: downloadProgress.totalSize == null
                                        ? null
                                        : downloadProgress.downloaded /
                                            downloadProgress.totalSize!,
                                  ),
                                )
                              ],
                            );
                          },
                          errorWidget: (context, url, error) => Center(
                            child: Text(
                              getUserProperty(e, 3),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: PlexFontSize.normal),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            getUserProperty(e, 3),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: PlexFontSize.smallest),
                          ),
                        ),
            ),
          ),
        ),
      ),
      spaceSmall(),
      Expanded(child: Text(getUserProperty(e, 0))),
      FilledButton.tonalIcon(
        onPressed: () {
          _login(getUserProperty(e, 0), getUserProperty(e, 1));
        },
        icon: const Icon(Icons.login),
        label: const Text("Login"),
      ),
      IconButton(
        iconSize: 20,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirmation'),
                content: const Text('Are you sure you want to delete?'),
                actions: [
                  TextButton(
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Plex.back();
                      _deleteRecentLogins(e);
                      setState(() {});
                    },
                  ),
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Plex.back();
                    },
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.delete),
      ),
    ]);
  }
}
