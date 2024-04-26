import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_utils/plex_widgets.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_input_widget.dart';

class PlexLoginConfig {
  PlexLoginConfig({
    required this.onLogin,
    required this.userFromJson,
    this.additionalWidgetsTop,
    this.additionalWidgetsBottom,
    this.debugUsername,
    this.debugPassword,
    this.username,
    this.password,
    this.createWidget,
  });

  final String? debugUsername;
  final String? debugPassword;
  final String? password;
  final String? username;
  final Future<PlexUser?> Function(BuildContext context, String email, String password) onLogin;
  final Widget Function(BuildContext context)? additionalWidgetsTop;
  final Widget Function(BuildContext context)? additionalWidgetsBottom;
  final PlexUser Function(Map<String, dynamic> userData) userFromJson;

  //Custom
  final Widget Function(BuildContext context)? createWidget;
}

class PlexLoginScreen extends PlexScreen {
  const PlexLoginScreen({super.key, required this.loginConfig, required this.nextRoute});

  final String nextRoute;
  final PlexLoginConfig loginConfig;

  @override
  PlexState<PlexLoginScreen> createState() => _PlexLoginScreenState();
}

class _PlexLoginScreenState extends PlexState<PlexLoginScreen> {
  var usernameController = TextEditingController();
  var passController = TextEditingController();
  var rememberUserController = PlexWidgetController<bool>(data: false);

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
      } else {
        var usersList = PlexSp.instance.getList(PlexSp.rememberUsers) ?? [];
        usernameController.text = usersList.firstOrNull?.split("|")[0] ?? "";
        passController.text = usersList.firstOrNull?.split("|")[1] ?? "";
        if(usersList.isNotEmpty) rememberUserController.setValue(true);
      }
    }
  }

  @override
  Widget buildBody() {
    if (PlexSp.instance.getString(PlexSp.loggedInUser) != null) {
      return Container();
    }
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 350,
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(Dim.medium),
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
                PlexInputWidget(
                  title: "Username / Email",
                  inputHint: "Enter Your Email or Username",
                  type: PlexInputWidgetType.typeInput,
                  inputController: usernameController,
                ),
                PlexInputWidget(
                  title: "Password",
                  inputHint: "Enter Your Password",
                  type: PlexInputWidgetType.typeInput,
                  inputController: passController,
                  isPassword: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: Dim.medium, right: Dim.small),
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
                PlexInputWidget(
                  title: "Login",
                  buttonIcon: const Icon(Icons.login),
                  type: PlexInputWidgetType.typeButton,
                  buttonClick: () async {
                    if (usernameController.text.isEmpty) {
                      toast("Username can't be empty");
                      return;
                    }
                    if (passController.text.isEmpty) {
                      toast("Password can't be empty");
                      return;
                    }

                    showLoading();
                    var result = await widget.loginConfig.onLogin(context, usernameController.text.toString(), passController.text.toString());
                    hideLoading();

                    if (result != null) {
                      result.save();
                      if (rememberUserController.data == true) {
                        PlexSp.instance.setList(PlexSp.rememberUsers, ["${usernameController.text}|${passController.text.toString()}"]);
                      } else {
                        PlexSp.instance.setList(PlexSp.rememberUsers, []);
                      }
                      Plex.offAndToNamed(PlexApp.app.dashboardConfig != null ? PlexRoutesPaths.homePath : PlexApp.app.appInfo.initialRoute);
                    }
                  },
                ),
                if (widget.loginConfig.additionalWidgetsBottom != null) ...{
                  widget.loginConfig.additionalWidgetsBottom!.call(context),
                },
                spaceSmall(),
                if (PlexApp.app.appInfo.versionName != null) ...[
                  Text("Version: ${PlexApp.app.appInfo.versionName}"),
                ],
              ],
            ),
          ),
        ).scaleAnim(),
      ),
    );
  }
}
