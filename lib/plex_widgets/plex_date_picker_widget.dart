import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_date_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

typedef OnDateSelected = Function(DateTime? dateTime);

class PlexDatePickerWidget extends StatefulWidget {
  const PlexDatePickerWidget(
      {super.key,
      required this.onDateSelected,
      required this.startDate,
      this.enabled = true,
      this.removePadding = false});

  final DateTime? startDate;
  final bool? enabled;
  final bool removePadding;
  final OnDateSelected onDateSelected;

  @override
  State<PlexDatePickerWidget> createState() => _PlexDatePickerWidgetState();
}

class _PlexDatePickerWidgetState extends State<PlexDatePickerWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = widget.startDate?.toDateString() ?? "N/A";

    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(PlexDim.small))),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: (widget.removePadding ? PlexDim.zero : PlexDim.small)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                showCursor: false,
                enabled: widget.enabled,
                onTap: () {
                  if (widget.enabled == false) return;
                  showDatePicker(
                    context: context,
                    initialDate: widget.startDate ?? DateTime.now(),
                    firstDate: DateTime(2020, 1, 1),
                    lastDate: DateTime(2050, 12, 31),
                    useRootNavigator: true,
                  ).then((value) {
                    if (value != null) {
                      controller.text = value.toDateString();
                      widget.onDateSelected(value);
                    }
                  });
                },
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            if (widget.enabled == true) ...[
              IconButton(
                  onPressed: () {
                    controller.text = "";
                    widget.onDateSelected(null);
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.grey,
                  )),
            ],
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }
}
