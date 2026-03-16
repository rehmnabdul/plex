/// Wraps an async task with automatic loading/error handling.
/// Use with [PlexViewModel.runAction], [PlexViewViewModel.runAction], or [PlexState.runAction].
class PlexAsyncAction<T> {
  final Future<T> Function() _task;
  final void Function(Object error, StackTrace stack)? onError;
  final void Function(T result)? onSuccess;

  const PlexAsyncAction(this._task, {this.onError, this.onSuccess});

  Future<T> run() => _task();
}
