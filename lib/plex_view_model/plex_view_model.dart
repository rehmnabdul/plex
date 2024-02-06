import 'package:flutter/material.dart';
import 'package:plex/plex_screens/plex_screen.dart';

///When extend PlexViewModel use your PlexScreen and PlexState like this:
///class MyViewModel extends PlexViewModel<MyPlexScreen, MyPlexScreenState> {
///}
class PlexViewModel<Sc extends PlexScreen, St extends PlexState<Sc>> {
  ///Return the State of Screen
  St? _state;

  St? get state {
    if (_state?.mounted == true) {
      return _state;
    }
    if (_state == null) {
      debugPrint("State not initialized");
    } else if (_state != null && _state?.mounted == false) {
      debugPrint("State not not mounted");
    }
    return null;
  }

  ///Set the State of Screen on Init
  setState(St state) => this._state = state;

  showLoading() {
    state?.showLoading();
  }

  hideLoading() {
    state?.hideLoading();
  }

  isLoading() {
    state?.isLoading();
  }

  toast(String message) {
    state?.toast(message);
  }

  toastDelayed(String message) {
    state?.toastDelayed(message);
  }
}
