import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_screens/plex_screen.dart';

///When extend PlexViewModel use your PlexScreen and PlexState like this:
///class MyViewModel extends PlexViewModel<MyPlexScreen, MyPlexScreenState> {
///}
class PlexViewModel<Sc extends PlexScreen, St extends PlexState<Sc>> {
  St? _state;

  ///The State of Screen ()
  St? get state {
    if (_state?.mounted == true) {
      return _state;
    }
    if (_state == null) {
      Exception("----------State not initialized----------").printError(info: 'plex_view_model.dart');
    } else if (_state != null && _state?.mounted == false) {
      Exception("----------State not not mounted----------").printError(info: 'plex_view_model.dart');
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
