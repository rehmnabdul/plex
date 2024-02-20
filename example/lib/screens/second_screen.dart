import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_view_model/plex_view_model.dart';
import 'package:plex/plex_widget.dart';

class UpdatableScreenViewModel extends PlexViewModel<UpdatableScreen, _UpdatableScreenState> {
  var updateController = PlexWidgetController<int>(data: 0);
}


class UpdatableScreen extends PlexScreen {
  const UpdatableScreen({Key? key}) : super(key: key);

  @override
  PlexState<UpdatableScreen> createState() => _UpdatableScreenState();
}

class _UpdatableScreenState extends PlexState<UpdatableScreen> {

  var viewModel = UpdatableScreenViewModel();

  @override
  Widget buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlexWidget(
            controller: viewModel.updateController,
            createWidget: (context, data) {
              return Text("Counter: $data",
                  style: const TextStyle(fontSize: 20));
            },
          ),
          spaceMedium(),
          ElevatedButton.icon(
            onPressed: () {
              var oldValue = viewModel.updateController.data ?? 0;
              viewModel.updateController.setValue(oldValue + 1);
              viewModel.toast("Added");
            },
            icon: const Icon(Icons.add),
            label: const Text("Add"),
          ),
          spaceMedium(),
          ElevatedButton.icon(
            onPressed: () {
              PlexApp.app.dashboardConfig?.navigateOnDashboard(0);
            },
            icon: const Icon(Icons.home),
            label: const Text("GoTo Home"),
          ),
        ],
      ),
    );
  }
}
