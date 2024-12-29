import 'package:flutter/material.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class PlexSignalRMethod {
  final String name;
  final Function(List<Object?>? arguments) on;

  PlexSignalRMethod(this.name, this.on);
}

class PlexSignalRConfig {
  final String serverUrl;
  final String hub;
  final List<PlexSignalRMethod>? remoteMethods;

  final Function(Exception? error)? onClose;
  final Function(Exception? error)? onConnecting;

  const PlexSignalRConfig(
    this.serverUrl,
    this.hub, {
    this.remoteMethods,
    this.onClose,
    this.onConnecting,
  });
}

class PlexSignalR {
  static PlexSignalR? _instance;
  static PlexSignalRConfig? _config;

  static PlexSignalR get instance {
    if (_instance == null) {
      if (_config == null) {
        throw Exception("\n\nPlease first initialize the configurations\n => PlexSignalR.config = PlexSignalRConfig(...);\n");
      }
      _instance = PlexSignalR._(config: _config!);
    }
    return _instance!;
  }

  static set config(PlexSignalRConfig config) => _config = config;

  static PlexSignalRConfig get config => _config!;

  late HubConnection _hubConnection;

  PlexSignalR._({
    required PlexSignalRConfig config,
  }) {
    _hubConnection = HubConnectionBuilder().withUrl("${config.serverUrl}/${config.hub}").build();
    _hubConnection.onreconnecting(({error}) {
      config.onConnecting?.call(error);
    });
    _hubConnection.onreconnected(({connectionId}) {
      debugPrint("Connected: $connectionId");
    });
    _hubConnection.onclose(({error}) {
      config.onClose?.call(error);
    });
    for (var remoteMethod in config.remoteMethods ?? List.empty()) {
      _hubConnection.on(remoteMethod.name, (arguments) {
        remoteMethod.on(arguments);
      });
    }
  }

  start() async {
    try {
      await _hubConnection.start();
    } catch (e) {
      debugPrint("Connecting...\n$e");
      await Future.delayed(Duration(milliseconds: 5000));
      start();
    }
  }

  invoke(String name, List<Object>? arguments) {
    _hubConnection.invoke(name, args: arguments);
  }
}
