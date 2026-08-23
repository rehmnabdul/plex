import 'package:flutter/material.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_view_model/plex_view_model.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_widgets/plex_input_widget.dart';
import 'package:plex_app/screens/example_chrome.dart';
import 'package:plex_app/screens/example_routes.dart';

class UpdatableScreenViewModel
    extends PlexViewModel<UpdatableScreen, _UpdatableScreenState> {
  var updateController = PlexWidgetController<int>(data: 0);
}

class UpdatableScreen extends PlexScreen {
  const UpdatableScreen({super.key}) : super(useScaffold: false);

  @override
  PlexState<UpdatableScreen> createState() => _UpdatableScreenState();
}

class _UpdatableScreenState extends PlexState<UpdatableScreen> {
  var viewModel = UpdatableScreenViewModel();
  var cont = PlexWidgetController<List<int>>(data: []);

  @override
  Widget buildBody() {
    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "PlexInputWidget (legacy)",
          subtitle: "Prefer PlexFormField* for new screens",
          // ignore: deprecated_member_use
          child: PlexInputWidget(
            type: PlexInputWidgetType.typeMultiSelect,
            title: "Multiselect",
            dropdownItems: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            multiSelectionController: cont,
            customMultiSelectedWidget: (p0) => Text("Custom Text:$p0"),
            multiInitialSelection: const [9],
            dropdownItemAsString: (item) => item.toString(),
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "PlexWidget controller",
          child: Column(
            children: [
              PlexWidget(
                controller: viewModel.updateController,
                createWidget: (context, data) {
                  return Text(
                    "PlexWidget Counter: $data",
                    style: const TextStyle(fontSize: PlexFontSize.large),
                  );
                },
              ),
              const SizedBox(height: PlexDim.medium),
              Wrap(
                spacing: PlexDim.small,
                runSpacing: PlexDim.small,
                children: [
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric(
                      title: "Add counter",
                      useMargin: false,
                    ),
                    buttonType: PlexButtonType.filled,
                    buttonIcon: const Icon(Icons.add),
                    buttonClick: () {
                      var oldValue = viewModel.updateController.data ?? 0;
                      viewModel.updateController.setValue(oldValue + 1);
                      context.showMessage("Added", title: "Counter");
                    },
                  ),
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric(
                      title: "Show toast",
                      useMargin: false,
                    ),
                    buttonType: PlexButtonType.outlined,
                    buttonIcon: const Icon(Icons.message),
                    buttonClick: () {
                      context.showMessage("Test toast", title: "Toast");
                    },
                  ),
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric(
                      title: "Go to home",
                      useMargin: false,
                    ),
                    buttonType: PlexButtonType.text,
                    buttonIcon: const Icon(Icons.home),
                    buttonClick: () => exampleNavigate(Routes.home),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
