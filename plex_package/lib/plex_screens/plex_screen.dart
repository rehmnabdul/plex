import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex_package/plex_theme.dart';
import 'package:plex_package/plex_widget.dart';

abstract class PlexScreen extends StatefulWidget {
  const PlexScreen({Key? key}) : super(key: key);
}

abstract class PlexState<T extends PlexScreen> extends State<T> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final _loadingController = PlexWidgetController();

  @override
  setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  _toast(String message, {String title = 'Message'}) {
    Get.closeAllSnackbars();
    Get.snackbar(title, message);
  }

  toast(String message) {
    if (!mounted) return null;
    if (message.length > 1000) message = "${message.substring(0, 1000)}...";
    _toast(message);
  }

  toastDelayed(String message) async {
    if (!mounted) return Future(() => null);
    return Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (!mounted) return Future(() => null);
        toast(message);
      },
    );
  }

  getNoOfTabs() => 0;

  @override
  Widget build(BuildContext context) {
    var body = Scaffold(
      key: key,
      backgroundColor: customTheme.colorScheme.background,
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            buildBody(),
            PlexWidget(
              controller: _loadingController,
              createWidget: (context, data) {
                if (data == true) {
                  return Container(
                    color: const Color(0x80000000),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );

    if (getNoOfTabs() > 0) {
      return DefaultTabController(
        length: getNoOfTabs(),
        child: body,
      );
    } else {
      return body;
    }
  }

  AppBar? buildAppBar() {
    return null;
  }

  Widget? buildDrawer() {
    return null;
  }

  Widget buildBody();

  var loadingCount = 0;

  showLoading() {
    loadingCount++;
    if (!mounted) return;
    _loadingController.setValue(loadingCount > 0);
  }

  hideLoading() {
    loadingCount--;
    if (!mounted) return;
    _loadingController.setValue(loadingCount > 0);
  }
}
