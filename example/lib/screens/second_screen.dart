import 'package:flutter/material.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';

class UpdatableScreen extends PlexScreen {
  const UpdatableScreen({Key? key}) : super(key: key);

  @override
  PlexState<UpdatableScreen> createState() => _UpdatableScreenState();
}

class _UpdatableScreenState extends PlexState<UpdatableScreen> {
  var updateController = PlexWidgetController<int>(data: 0);

  @override
  Widget buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlexWidget(controller: updateController, createWidget: (context, data) {
            return Text("Counter: $data", style: const TextStyle(fontSize: 20));
          },),
          spaceMedium(),
          ElevatedButton.icon(
            onPressed: () {
              var oldValue = updateController.data ?? 0;
              updateController.setValue(oldValue + 1);
            },
            icon: const Icon(Icons.add),
            label: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
