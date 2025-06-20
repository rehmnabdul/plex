import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_rx/plex_rx.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_view_model/plex_view_model.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_input_widget.dart';

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
  var cont = PlexWidgetController<List<int>>(data: []);


  @override
  Widget buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          PlexInputWidget(
            type: PlexInputWidgetType.typeMultiSelect,
            title: "Multiselect",
            dropdownItems: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            multiSelectionController: cont,
            customMultiSelectedWidget: (p0) => Text("Custom Text:$p0"),
            multiInitialSelection: [9],
            dropdownItemAsString: (item) => item.toString(),
          ),
          PlexWidget(
            controller: viewModel.updateController,
            createWidget: (context, data) {
              return Text("PlexWidget Counter: $data", style: const TextStyle(fontSize: PlexFontSize.large));
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
            label: const Text("Add PlexWidget Counter"),
          ),
          spaceMedium(),
          ElevatedButton.icon(
            onPressed: () {
              toast("Test Toast");
            },
            icon: const Icon(Icons.message),
            label: const Text("Show Toast"),
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
