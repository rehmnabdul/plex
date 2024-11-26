import 'package:flutter/material.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_loader.dart';

abstract class PlexView extends StatefulWidget {
  const PlexView({
    super.key,
    this.loadingBackground = const Color(0x80000000),
  });

  final Color loadingBackground;
}

abstract class PlexViewState<T extends PlexView> extends State<T> {
  final _loadingController = PlexWidgetController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildBody(),
        PlexWidget(
          controller: _loadingController,
          createWidget: (context, data) {
            if (data == true) {
              return Container(
                color: widget.loadingBackground,
                child: const Center(
                  child: PlexLoader(),
                ),
              );
            }
            return Container();
          },
        )
      ],
    );
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
