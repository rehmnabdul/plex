import 'package:flutter/material.dart';

class PlexWidget<T> extends StatefulWidget {
  const PlexWidget({Key? key, required this.controller, required this.createWidget, this.tag}) : super(key: key);

  final String? tag;
  final Widget Function(BuildContext, dynamic) createWidget;
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
  PlexWidgetController({this.data});

  T? data;
  bool isDisposed = false;

  void setValue(T data) {
    this.data = data;
    notifyListeners();
  }

  @override
  dispose() {
    if (!isDisposed) {
      super.dispose();
      isDisposed = true;
    }
  }
}
