import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_screens/plex_view.dart';
import 'package:plex/plex_utils/plex_logger.dart';
import 'package:plex/plex_view_model/plex_async_action.dart';

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

  BuildContext? get context {
    return state?.context;
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

  /// Runs an async action with automatic loading/error handling.
  Future<R?> runAction<R>(PlexAsyncAction<R> action) async {
    showLoading();
    try {
      final result = await action.run();
      action.onSuccess?.call(result);
      return result;
    } catch (e, s) {
      action.onError?.call(e, s);
      PlexLogger.e('PlexAsyncAction', e.toString(), error: e, stack: s);
      return null;
    } finally {
      hideLoading();
    }
  }

  @Deprecated("Use context.showMessage() or context.showMessageDelayed() instead which has more options and customizations available")
  toast(String message) {
    state?.toast(message);
  }

  @Deprecated("Use context.showMessage() or context.showMessageDelayed() instead which has more options and customizations available")
  toastDelayed(String message) {
    state?.toastDelayed(message);
  }
}

class PlexViewViewModel<Sc extends PlexView, St extends PlexViewState<Sc>> {
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

  BuildContext? get context {
    return state?.context;
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

  /// Runs an async action with automatic loading/error handling.
  Future<R?> runAction<R>(PlexAsyncAction<R> action) async {
    showLoading();
    try {
      final result = await action.run();
      action.onSuccess?.call(result);
      return result;
    } catch (e, s) {
      action.onError?.call(e, s);
      PlexLogger.e('PlexAsyncAction', e.toString(), error: e, stack: s);
      return null;
    } finally {
      hideLoading();
    }
  }
}
