import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/form_field_widget.dart';

showSelectionList<T>(
  BuildContext context, {
  List<T>? items,
  Future<List<T>>? asyncItems,
  required String Function(T) itemText,
  required Function(T) onSelect,
  Widget Function(dynamic)? itemWidget,
  Widget Function(T)? leadingIcon,
  bool Function(String, dynamic)? onSearch,
}) async {
  var originalListData = items;
  originalListData ??= await asyncItems;
  if (originalListData == null) throw Exception("Items are null");

  var inputController = TextEditingController();
  var filteredListController = PlexWidgetController<List<T>>(data: originalListData);

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Column(
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
                        style: ListTileStyle.list,
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
      );
    },
  );
}
