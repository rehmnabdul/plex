import 'package:flutter/material.dart';

///This [PlexWidget] will be use to uto update the widget by updating its contorller
class PlexWidget<T> extends StatefulWidget {
  const PlexWidget({super.key, required this.controller, required this.createWidget, this.tag});

  final String? tag;
  final Widget Function(BuildContext context, dynamic data) createWidget;
  final PlexWidgetController<T> controller;

  @override
  State<PlexWidget> createState() => _PlexWidgetState<T>();
}

class _PlexWidgetState<T> extends State<PlexWidget> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.createWidget(context, widget.controller.data);
  }
}

class PlexWidgetController<T> extends ChangeNotifier {
  final void Function(T? previous, T? updated)? onUpdate;

  PlexWidgetController({this.data, this.onUpdate});

  T? data;
  bool isDisposed = false;

  void setValue(T? data) {
    var oldData = this.data;
    this.data = data;
    if (isDisposed) return;
    notifyListeners();
    onUpdate?.call(oldData, this.data);
  }

  ///If Data is of type int, double, float or any num, you can increment (default 1)
  void increment({num increment = 1}) {
    var oldData = this.data;
    this.data = ((this.data as num) + increment) as T?;
    if (isDisposed) return;
    notifyListeners();
    onUpdate?.call(oldData, this.data);
  }

  ///If Data is of type int, double, float or any num, you can decrement (default 1)
  void decrement({num decrement = 1}) {
    var oldData = this.data;
    this.data = ((this.data as num) - decrement) as T?;
    if (isDisposed) return;
    notifyListeners();
    onUpdate?.call(oldData, this.data);
  }

  @override
  dispose() {
    if (!isDisposed) {
      super.dispose();
      isDisposed = true;
    }
  }

  static PlexWidgetController<T> controller<T>(PlexWidgetController<T> controller) {
    if (controller.isDisposed) {
      controller = PlexWidgetController<T>(data: controller.data, onUpdate: controller.onUpdate);
    }
    return controller;
  }
}

class PlexInputWidgetController<T, E> extends PlexWidgetController<T> {
  PlexInputWidgetController({super.data, this.error});

  E? error;

  void setError(E? error) {
    this.error = error;
    if (isDisposed) return;
    notifyListeners();
  }
}
