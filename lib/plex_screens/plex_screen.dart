import 'package:flutter/material.dart';
import 'package:plex/plex_utils.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_utils/plex_utils.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_loader.dart';

abstract class PlexScreen extends StatefulWidget {
  const PlexScreen({super.key});
}

abstract class PlexState<T extends PlexScreen> extends State<T> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final _loadingController = PlexWidgetController();

  ///Screen Size Segregation
  var smallScreen = true;
  var mediumScreen = false;
  var largeScreen = false;

  getArguments<AT>() {
    var args = ModalRoute.of(context)!.settings.arguments as AT;
    return args;
  }

  @override
  setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @Deprecated("Use context.showMessage() or context.showMessageDelayed() instead which has more options and customizations available")
  toast(
    String message, {
    String title = "Message",
  }) {
    if (!mounted) return;
    if (message.length > 1000) message = "${message.substring(0, 1000)}...";
    context.showSnackBar(message);
  }

  @Deprecated("Use context.showMessage() or context.showMessageDelayed() instead which has more options and customizations available")
  toastDelayed(
    String message,
  ) async {
    return Future.delayed(
      const Duration(milliseconds: 100),
      () {
        toast(message);
      },
    );
  }

  int getNoOfTabs() => 0;

  TabBar? getTabBar() => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: buildAppBar(),
      drawer: buildSideNavigation(),
      bottomNavigationBar: buildBottomNavigation(),
      body: SafeArea(
        child: Stack(
          children: [
            createWidget(() {
              if (getNoOfTabs() > 0) {
                if (getTabBar() == null) {
                  throw Exception("Please override following methods:\n1. getTabBar()\n2. buildBody() must return TabBarView");
                }
                var body = buildBody();
                if (body is! TabBarView) {
                  throw Exception("buildBody() must return TabBarView if getTabBar() > 0");
                }
                return DefaultTabController(
                  length: getNoOfTabs(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      getTabBar()!,
                      Expanded(child: body),
                    ],
                  ),
                );
              } else {
                return buildBody();
              }
            }),
            PlexWidget(
              controller: _loadingController,
              createWidget: (context, data) {
                if (data == true) {
                  return Container(
                    color: const Color(0x80000000),
                    child: const Center(
                      child: PlexLoader(),
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    smallScreen = isSmallScreen(context);
    mediumScreen = isMediumScreen(context);
    largeScreen = isLargeScreen(context);
  }

  Widget buildBody();

  var _loadingCount = 0;

  bool isLoading() => _loadingCount > 0;

  showLoading() {
    _loadingCount++;
    if (!mounted) return;
    _loadingController.setValue(_loadingCount > 0);
  }

  hideLoading({bool force = false}) {
    if (force) _loadingCount = 0;
    if (_loadingCount > 0) _loadingCount--;
    if (!mounted) return;
    _loadingController.setValue(_loadingCount > 0);
  }
}
