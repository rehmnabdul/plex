import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plex/plex_db.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_widgets/form_field_widget.dart';

class PlexLoginScreen extends PlexScreen {
  const PlexLoginScreen({Key? key, this.logo, required this.onLogin, required this.nextRoute}) : super(key: key);

  final Widget? logo;
  final String nextRoute;
  final Future<PlexUser?> Function(String email, String password) onLogin;

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
      Future.delayed(const Duration(milliseconds: 100), () => Plex.offAndToNamed(widget.nextRoute));
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
          maxWidth: 300,
        ),
        child: Card(
          color: customTheme.cardColor,
          elevation: Dim.medium,
          child: Padding(
            padding: const EdgeInsets.all(Dim.medium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.logo != null) ...{
                  widget.logo!,
                },
                PlexInputWidget(
                  title: "Username / Email",
                  type: PlexInputWidget.typeInput,
                  inputController: usernameController,
                  fieldColor: customTheme.colorScheme.background,
                ),
                PlexInputWidget(
                  title: "Password",
                  type: PlexInputWidget.typeInput,
                  inputController: passController,
                  fieldColor: customTheme.colorScheme.background,
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

                    var result = await widget.onLogin(usernameController.text.toString(), passController.text.toString());
                    if (result != null) {
                      PlexDb.instance.setString(PlexDb.loggedInUser, jsonEncode(result.userData));
                      Plex.offAndToNamed(widget.nextRoute);
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
