import 'dart:async';

/// A utility class that debounces function calls.
///
/// Debouncing ensures that a function is only called after a specified
/// delay has passed since the last time it was invoked. This is useful
/// for limiting the rate of API calls, especially for search inputs.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  /// Creates a new Debouncer with the specified delay.
  ///
  /// [delay] defaults to 500 milliseconds if not specified.
  Debouncer({Duration? delay})
    : delay = delay ?? const Duration(milliseconds: 500);

  /// Runs the provided callback after the debounce delay.
  ///
  /// If [run] is called again before the delay expires, the previous
  /// timer is cancelled and a new one is started.
  void run(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  /// Cancels any pending debounced call.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Disposes of the debouncer, cancelling any pending calls.
  void dispose() {
    cancel();
  }
}
