import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_utils/plex_widgets.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_backgrounds/plex_background.dart';
import 'package:plex/plex_widgets/plex_card.dart';
import 'package:plex/plex_widgets/plex_card_glass.dart';
import 'package:plex/plex_l10n/plex_localization.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

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
  });

  final bool useBackground;
  final PlexBackgroundType backgroundType;

  final String? debugUsername;
  final String? debugPassword;
  final String? password;
  final String? username;
  final int? passwordMinLength;
  final int? passwordMaxLength;
  final Future<PlexUser?> Function(BuildContext context, String email, String password) onLogin;
  final Widget Function(BuildContext context)? additionalWidgetsTop;
  final Widget Function(BuildContext context)? additionalWidgetsAboveLoginButton;
  final Widget Function(BuildContext context)? additionalWidgetsBottom;
  final PlexUser Function(Map<String, dynamic> userData) userFromJson;

  //Custom
  final Widget Function(BuildContext context)? createWidget;
}

class PlexLoginScreen extends PlexScreen {
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
      Future.delayed(const Duration(milliseconds: 100), () => Plex.offAndToNamed(PlexRoutesPaths.homePath));
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
      usernameErrorController.setValue(context.plexStrings.loginUsernameEmpty);
      return;
    }
    if (passController.text.isEmpty) {
      passErrorController.setValue(context.plexStrings.loginPasswordEmpty);
      return;
    }

    await _login(username, passController.text.toString());
  }

  @override
  Widget buildBody() {
    if (PlexSp.instance.getString(PlexSp.loggedInUser) != null) {
      return Container();
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            spaceMedium(),
            Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 350,
                ),
                child: createWidget(
                  () {
                    var loginWidget = Padding(
                      padding: const EdgeInsets.all(PlexDim.medium),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.loginConfig.additionalWidgetsTop != null) ...{
                            widget.loginConfig.additionalWidgetsTop!.call(context),
                          },
                          SizedBox(
                            height: 100,
                            child: PlexApp.app.getLogo(context),
                          ),
                          spaceMedium(),
                          PlexFormFieldInput(
                            properties: PlexFormFieldGeneric.title(context.plexStrings.loginUsername),
                            inputHint: context.plexStrings.loginUsernameHint,
                            inputController: usernameController,
                            errorController: usernameErrorController,
                          ),
                          PlexFormFieldInput(
                            properties: PlexFormFieldGeneric.title(context.plexStrings.loginPassword),
                            inputHint: context.plexStrings.loginPasswordHint,
                            inputController: passController,
                            errorController: passErrorController,
                            isPassword: true,
                            maxInputLength: widget.loginConfig.passwordMaxLength,
                            inputOnSubmit: (value) => _loginAction(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: PlexDim.medium, right: PlexDim.small),
                            child: Row(
                              children: [
                                Expanded(child: Text(context.plexStrings.loginRememberMe)),
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
                            properties: PlexFormFieldGeneric(title: context.plexStrings.loginButton, useMargin: false),
                            buttonIcon: const Icon(Icons.login),
                            buttonClick: () => _loginAction(),
                          ),
                          if (_getRecentLogins().isNotEmpty) ...{
                            Row(
                              children: [
                                spaceMedium(),
                                Text(context.plexStrings.loginRecentLogins, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            spaceSmall(),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: PlexDim.small,
                              runSpacing: PlexDim.small,
                              children: [
                                ..._getRecentLogins().map((e) => _getRecentLoginWidget(context, e)),
                              ],
                            ),
                            spaceSmall(),
                          },
                          if (widget.loginConfig.additionalWidgetsBottom != null) ...{
                            widget.loginConfig.additionalWidgetsBottom!.call(context),
                          },
                          spaceSmall(),
                          if (PlexApp.app.appInfo.versionName != null) ...[
                            Text("${context.plexStrings.versionLabel} ${PlexApp.app.appInfo.versionName}"),
                          ],
                        ],
                      ),
                    );

                    if (widget.useBackground && widget.backgroundType == PlexBackgroundType.neoGlass) {
                      return PlexCardGlassEffect(child: loginWidget);
                    }
                    return PlexCard(child: loginWidget);
                  },
                ).scaleAnim(),
              ),
            ),
            spaceMedium(),
          ],
        ),
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
        rememberUser(context, result, username, passController.text.toString());
      }
      Plex.offAndToNamed(PlexApp.app.dashboardConfig != null ? PlexRoutesPaths.homePath : PlexApp.app.appInfo.initialRoute);
    }
  }

  String getUserProperty(BuildContext context, String userData, int location) {
    // 0 => UserName
    // 1 => Pass
    // 2 => FullName
    // 3 => Initials
    // 4 => Picture
    var splits = userData.split("|");
    final na = context.plexStrings.dropdownNoData;
    if (splits.isEmpty) return na;
    if (location == 0) {
      return splits.length > 0 ? splits[0] : na;
    } else if (location == 1) {
      return splits.length > 1 ? splits[1] : na;
    } else if (location == 2) {
      return splits.length > 2 ? splits[2] : na;
    } else if (location == 3) {
      return splits.length > 3 ? splits[3] : na;
    } else if (location == 4) {
      return splits.length > 4 ? splits[4] : na;
    }
    return na;
  }

  void rememberUser(BuildContext context, PlexUser plexUser, String username, String password) {
    var rememberedUsers = PlexSp.instance.getList(PlexSp.rememberUsers) ?? List.empty(growable: true);
    if (rememberedUsers.firstWhereOrNull((e) => getUserProperty(context, e, 0) == username) == null) {
      rememberedUsers.add("$username|$password|${plexUser.getLoggedInFullName()}|${plexUser.getInitials()}|${plexUser.getPictureUrl() ?? ""}");
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

  _getRecentLoginWidget(BuildContext context, String e) {
    return Row(children: [
      Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: Tooltip(
            message: getUserProperty(context, e, 2),
            child: Container(
              decoration: BoxDecoration(
                color: PlexTheme.getActiveTheme(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge,
              child: getUserProperty(context, e, 4) != context.plexStrings.dropdownNoData && getUserProperty(context, e, 4) != ""
                  ? CachedNetworkImage(
                      imageUrl: getUserProperty(context, e, 4),
                      progressIndicatorBuilder: (context, url, downloadProgress) {
                        debugPrint(downloadProgress.progress.toString());
                        return Stack(
                          children: [
                            Center(
                              child: Text(
                                getUserProperty(context, e, 3),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: PlexFontSize.normal),
                              ),
                            ),
                            Center(
                              child: CircularProgressIndicator(
                                color: Colors.yellowAccent,
                                value: downloadProgress.totalSize == null ? null : downloadProgress.downloaded / downloadProgress.totalSize!,
                              ),
                            )
                          ],
                        );
                      },
                      errorWidget: (context, url, error) => Center(
                        child: Text(
                          getUserProperty(context, e, 3),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: PlexFontSize.normal),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        getUserProperty(context, e, 3),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: PlexFontSize.smallest),
                      ),
                    ),
            ),
          ),
        ),
      ),
      spaceSmall(),
      Expanded(child: Text(getUserProperty(context, e, 0))),
      FilledButton.tonalIcon(
        onPressed: () {
          _login(getUserProperty(context, e, 0), getUserProperty(context, e, 1));
        },
        icon: const Icon(Icons.login),
        label: Text(context.plexStrings.loginButton),
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
                    child: Text(context.plexStrings.dialogCancel),
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
