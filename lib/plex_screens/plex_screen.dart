import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_widget.dart';

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

  toast(String message, {String title = 'Message'}) {
    if (message.length > 1000) message = "${message.substring(0, 1000)}...";
    context.showSnackBar(message);
  }

  toastDelayed(String message) async {
    return Future.delayed(
      const Duration(milliseconds: 100),
      () {
        toast(message);
      },
    );
  }

  getNoOfTabs() => 0;

  @override
  Widget build(BuildContext context) {
    var body = Scaffold(
      key: key,
      appBar: buildAppBar(),
      drawer: buildSideNavigation(),
      bottomNavigationBar: buildBottomNavigation(),
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

  Widget? buildSideNavigation() {
    return null;
  }

  Widget? buildBottomNavigation() {
    return null;
  }

  var smallScreen = false;
  var mediumScreen = false;
  var largeScreen = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    smallScreen = mediumScreen = largeScreen = false;
    if (MediaQuery.of(context).size.width >= 900) {
      largeScreen = true;
      return;
    }
    if (MediaQuery.of(context).size.width >= 600) {
      mediumScreen = true;
      return;
    }
    smallScreen = true;
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
