import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_input_widget.dart';

showSelectionList<T>(
  BuildContext context, {
  List<T>? items,
  Future<List<T>>? asyncItems,
  required String Function(T item) itemText,
  required Function(T item) onSelect,
  Widget Function(dynamic item)? itemWidget,
  Widget Function(T item)? leadingIcon,
  bool Function(String query, dynamic item)? onSearch,
}) async {
  var originalListData = items;
  originalListData ??= await asyncItems;
  if (originalListData == null) throw Exception("Items are null");

  var inputController = TextEditingController();
  var filteredListController = PlexWidgetController<List<T>>(data: originalListData);

  // ignore: use_build_context_synchronously
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(Dim.medium),
        child: Column(
          children: [
            PlexInputWidget<String>(
              title: "Search",
              type: PlexInputWidget.typeInput,
              inputController: inputController,
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
                          leading: leadingIcon?.call(item),
                          // style: ListTileStyle.list,
                          title: Text(itemText.call(item)),
                          onTap: () {
                            onSelect.call(item);
                            Get.back();
                          },
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      );
    },
  );
}
