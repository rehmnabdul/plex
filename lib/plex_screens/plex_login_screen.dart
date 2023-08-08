import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plex/plex_db.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_widgets/plex_input_widget.dart';

class PlexLoginConfig {
  PlexLoginConfig({
    required this.onLogin,
    this.additionalWidgets,
  });

  final Future<PlexUser?> Function(String email, String password) onLogin;
  final Widget? additionalWidgets;
}

class PlexLoginScreen extends PlexScreen {
  const PlexLoginScreen({Key? key, this.logo, required this.loginConfig, required this.nextRoute}) : super(key: key);

  final Widget? logo;
  final String nextRoute;
  final PlexLoginConfig loginConfig;

  @override
  PlexState<PlexLoginScreen> createState() => _PlexLoginScreenState();
}

class _PlexLoginScreenState extends PlexState<PlexLoginScreen> {
  var usernameController = TextEditingController();
  var passController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (PlexDb.instance.getString(PlexDb.loggedInUser) != null) {
      Future.delayed(const Duration(milliseconds: 100), () => Plex.offAndToNamed(PlexRoutesPaths.homePath));
      return;
    }

    if (kDebugMode) {
      usernameController.text = "dev";
      passController.text = "dev";
    }
  }

  @override
  Widget buildBody() {
    if (PlexDb.instance.getString(PlexDb.loggedInUser) != null) {
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
                if (widget.logo != null) ...{
                  widget.logo!,
                },
                spaceMedium(),
                PlexInputWidget(
                  title: "Username / Email",
                  inputHint: "Enter Your Email or Username",
                  type: PlexInputWidget.typeInput,
                  inputController: usernameController,
                ),
                PlexInputWidget(
                  title: "Password",
                  inputHint: "Enter Your Password",
                  type: PlexInputWidget.typeInput,
                  inputController: passController,
                  isPassword: true,
                ),
                PlexInputWidget(
                  title: "Login",
                  buttonIcon: const Icon(Icons.login),
                  type: PlexInputWidget.typeButton,
                  buttonClick: () async {
                    if (usernameController.text.isEmpty) {
                      toast("Username can't be empty");
                      return;
                    }
                    if (passController.text.isEmpty) {
                      toast("Password can't be empty");
                      return;
                    }

                    var result = await widget.loginConfig.onLogin(usernameController.text.toString(), passController.text.toString());
                    if (result != null) {
                      PlexDb.instance.setString(PlexDb.loggedInUser, jsonEncode(result.userData));
                      Plex.offAndToNamed(PlexRoutesPaths.homePath);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onLogin(String username, String password) async {}
}
