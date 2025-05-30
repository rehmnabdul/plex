import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_scanner.dart';
import 'package:plex/plex_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/loading/plex_loader_v2.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

showPlexSelectionList<T>(
  BuildContext context, {
  List<T>? items,
  Future<List<T>>? asyncItems,
  required String Function(T item) itemText,
  required Function(T item) onSelect,
  dynamic initialSelected,
  FocusNode? focusNode,
  Widget Function(dynamic item)? itemWidget,
  Widget Function(T item)? leadingIcon,
  bool Function(String query, dynamic item)? onSearch,
}) async {
  var originalListData = items;
  originalListData ??= await asyncItems;
  if (originalListData == null) throw Exception("Items are null");

  var inputController = TextEditingController();
  var filteredListController = PlexWidgetController<List<T>>(data: originalListData);
  if (focusNode == null) {
    focusNode = FocusNode();
    focusNode.requestFocus();
  }

  // ignore: use_build_context_synchronously
  showModalBottomSheet(
    enableDrag: true,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlexFormFieldInput(
                properties: PlexFormFieldGeneric.title("Search"),
                inputController: inputController,
                inputHint: "Search here...",
                inputFocusNode: focusNode,
                inputOnChange: (data) {
                  var query = data.toLowerCase();
                  if (query.isEmpty) {
                    filteredListController.setValue(originalListData!);
                  }
                  var filteredList = originalListData!.where((element) {
                    if (onSearch != null) {
                      return onSearch.call(query, element);
                    }
                    return itemText(element).toLowerCase().contains(query);
                  }).toList();
                  filteredListController.setValue(filteredList);
                },
              ),
              spaceSmall(),
              Expanded(
                child: PlexWidget(
                  controller: filteredListController,
                  createWidget: (con, data) {
                    var listData = data as List<T>;
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        var item = listData[index];
                        if (itemWidget != null) {
                          return InkWell(
                            onTap: () {
                              onSelect.call(item);
                              Get.back();
                            },
                            child: itemWidget.call(item),
                          );
                        }
                        return ListTile(
                          selectedTileColor: Colors.green.withValues(alpha: 0.25),
                          selected: initialSelected != null && itemText.call(item) == itemText.call(initialSelected),
                          leading: leadingIcon?.call(item),
                          title: Text(itemText.call(item)),
                          trailing: initialSelected != null && itemText.call(item) == itemText.call(initialSelected) ? const Icon(Icons.check_circle, color: Colors.green) : null,
                          onTap: () {
                            onSelect.call(item);
                            Get.back();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

showPlexMultiSelection<T>(
  BuildContext context, {
  List<T>? items,
  Future<List<T>>? asyncItems,
  List<T>? initialSelection,
  FocusNode? focusNode,
  required String Function(T item) itemText,
  required Function(List<T> items) onSelect,
  Widget Function(dynamic item)? itemWidget,
  Widget Function(T item)? leadingIcon,
  bool Function(String query, dynamic item)? onSearch,
}) async {
  var originalListData = items;
  originalListData ??= await asyncItems;
  if (originalListData == null) throw Exception("Items are null");

  var inputController = TextEditingController();
  var filteredListController = PlexWidgetController<List<T>>(data: originalListData);

  var selectionList = List<T>.empty(growable: true);
  if (initialSelection != null) {
    selectionList.addAll(initialSelection);
  }

  if (focusNode == null) {
    focusNode = FocusNode();
    focusNode.requestFocus();
  }

  // ignore: use_build_context_synchronously
  showModalBottomSheet(
    enableDrag: true,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: PlexFormFieldInput(
                      properties: PlexFormFieldGeneric.title("Search"),
                      inputController: inputController,
                      inputFocusNode: focusNode,
                      inputHint: "Search here...",
                      inputOnChange: (data) {
                        var query = data.toLowerCase();
                        if (query.isEmpty) {
                          filteredListController.setValue(originalListData!);
                        }
                        var filteredList = originalListData!.where((element) {
                          if (onSearch != null) {
                            return onSearch.call(query, element);
                          }
                          return itemText(element).toLowerCase().contains(query);
                        }).toList();
                        filteredListController.setValue(filteredList);
                      },
                    ),
                  ),
                  PlexFormFieldButton(
                    properties: PlexFormFieldGeneric.title("Done"),
                    buttonClick: () {
                      onSelect.call(selectionList);
                      Get.back();
                    },
                  ),
                ],
              ),
              spaceSmall(),
              Expanded(
                child: PlexWidget(
                    controller: filteredListController,
                    createWidget: (con, data) {
                      var listData = data as List<T>;
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: listData.length,
                        itemBuilder: (context, index) {
                          var item = listData[index];
                          if (itemWidget != null) {
                            return InkWell(
                              onTap: () {
                                var prevItem = selectionList.firstWhereOrNull((element) => itemText(item) == itemText(element));
                                if (prevItem == null) {
                                  selectionList.add(item);
                                } else {
                                  selectionList.removeWhere((element) => itemText(item) == itemText(element));
                                }
                                filteredListController.setValue(filteredListController.data);
                                onSelect.call(selectionList);
                              },
                              child: itemWidget.call(item),
                            );
                          }
                          return ListTile(
                            leading: leadingIcon?.call(item),
                            title: Text(itemText.call(item)),
                            trailing: Checkbox(
                              value: selectionList.firstWhereOrNull((element) => itemText(item) == itemText(element)) != null,
                              onChanged: (value) {
                                if (value == true) {
                                  selectionList.add(item);
                                } else {
                                  selectionList.removeWhere((element) => itemText(item) == itemText(element));
                                }
                                filteredListController.setValue(filteredListController.data);
                                onSelect.call(selectionList);
                              },
                            ),
                            onTap: () {
                              var prevItem = selectionList.firstWhereOrNull((element) => itemText(item) == itemText(element));
                              if (prevItem == null) {
                                selectionList.add(item);
                              } else {
                                selectionList.removeWhere((element) => itemText(item) == itemText(element));
                              }
                              filteredListController.setValue(filteredListController.data);
                            },
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    },
  );
}

showPlexAutoCompleteSelectionList<T>(
  BuildContext context, {
  FocusNode? focusNode,
  required Future<List<T>> Function(String query) asyncItems,
  required String Function(T item) itemText,
  required Function(T item) onSelect,
  int minQueryLength = 2,
  Widget Function(dynamic item)? itemWidget,
  Widget Function(T item)? leadingIcon,
  bool showBarCode = false,
  double inputDelay = 1000,
}) async {
  DateTime lastInputAt = DateTime.now();
  String? query;
  String? searchedQuery;

  var inputController = TextEditingController();
  var filteredListController = PlexWidgetController<List<T>>(data: List.empty());
  var loadingController = PlexWidgetController<int>(data: 0);

  if (focusNode == null) {
    focusNode = FocusNode();
    focusNode.requestFocus();
  }

  onSearch(String data) async {
    lastInputAt = DateTime.now();
    query = data;
    if (data.length < minQueryLength) return;

    delay(() async {
      if (DateTime.now().difference(lastInputAt).inMilliseconds < inputDelay) return;
      if (query == null || query!.length < minQueryLength) return;
      if (searchedQuery == query) return;

      loadingController.increment();
      searchedQuery = query;
      var filteredList = await asyncItems.call(searchedQuery!);
      loadingController.decrement();
      filteredListController.setValue(filteredList);
    }, delayMillis: inputDelay.toInt());
  }

  // ignore: use_build_context_synchronously
  showModalBottomSheet(
    enableDrag: true,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: PlexWidget(
                      controller: loadingController,
                      createWidget: (context, data) {
                        return PlexFormFieldInput(
                          properties: PlexFormFieldGeneric(title: "Search", enabled: data <= 0),
                          inputController: inputController,
                          inputHint: "Search Here...",
                          inputFocusNode: focusNode,
                          inputOnChange: (value) async {
                            onSearch(value);
                          },
                        );
                      },
                    ),
                  ),
                  if (showBarCode) ...{
                    PlexFormFieldButton(
                      buttonIcon: Icon(Icons.barcode_reader),
                      buttonClick: () async {
                        var result = await Plex.to(PlexScanner());
                        if (result != null) {
                          inputController.text = result.toString();
                          onSearch(inputController.text);
                        }
                      },
                    )
                  }
                ],
              ),
              spaceSmall(),
              PlexWidget(
                  controller: loadingController,
                  createWidget: (context, data) {
                    if (data > 0) {
                      return SizedBox(
                        width: 50,
                        height: 50,
                        child: const PlexLoaderV2(),
                      );
                    }
                    return Container();
                  }),
              spaceSmall(),
              Expanded(
                child: PlexWidget(
                  controller: filteredListController,
                  createWidget: (con, data) {
                    var listData = data as List<T>;
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        var item = listData[index];
                        if (itemWidget != null) {
                          return InkWell(
                            onTap: () {
                              onSelect.call(item);
                              Get.back();
                            },
                            child: itemWidget.call(item),
                          );
                        }
                        return ListTile(
                          selectedTileColor: Colors.green.withValues(alpha: 0.25),
                          leading: leadingIcon?.call(item),
                          title: Text(itemText.call(item)),
                          onTap: () {
                            onSelect.call(item);
                            Get.back();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

showPlexBottomSheet({
  required BuildContext context,
  required String title,
  required Widget Function() builder,
  Color? backgroundColor,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool useSafeArea = true,
  bool showDragHandle = true,
  bool enableDrag = true,
}) {
  showModalBottomSheet(
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor,
    context: context,
    builder: (BuildContext context) {
      return builder.call();
    },
  );
}
