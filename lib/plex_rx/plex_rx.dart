import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef PlexRxListener = void Function();

class PlexRx {
  String id = UniqueKey().toString();
  Object _value;
  final List<PlexRxListener> _listeners = List.empty(growable: true);

  Object get value {
    return _value;
  }

  set value(Object value) {
    _value = value;
    print("Rx ${id}-${value.toString()}");
    for (var element in _listeners) {
      element.call();
    }
  }

  PlexRx(this._value);
}

extension PlexRxExt on Object {
  PlexRx get plexObs => PlexRx(this);
}

class PlexRxWidget extends StatefulWidget {
  Widget _widget;
  PlexRx _rx;

  PlexRxWidget(this._widget, this._rx, {super.key});

  @override
  State<PlexRxWidget> createState() => _PlexRxWidgetState();
}

class _PlexRxWidgetState extends State<PlexRxWidget> {

  int _counter = 0;
  late PlexRxListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = () => setState(() {
      _counter++;
    });
    widget._rx._listeners.add(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    widget._rx._listeners.remove(_listener);
  }

  @override
  Widget build(BuildContext context) {
    print("From Widget ${widget._rx.id}-${widget._rx.value.toString()}");
    _counter++;
    return widget._widget;
  }
}

extension PlexRxWidgetExt on Widget {
  PlexRxWidget plexRxWidget(PlexRx rx) => PlexRxWidget(this, rx);
}
