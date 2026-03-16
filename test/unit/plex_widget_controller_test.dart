import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_widget.dart';

void main() {
  group('PlexWidgetController', () {
    test('setValue updates data and notifies listeners', () {
      final controller = PlexWidgetController<int>(data: 0);
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.setValue(1);
      expect(controller.data, 1);
      expect(notifyCount, 1);

      controller.setValue(42);
      expect(controller.data, 42);
      expect(notifyCount, 2);
    });

    test('increment increases numeric data', () {
      final controller = PlexWidgetController<int>(data: 10);
      controller.increment();
      expect(controller.data, 11);

      controller.increment(increment: 5);
      expect(controller.data, 16);
    });

    test('decrement decreases numeric data', () {
      final controller = PlexWidgetController<int>(data: 10);
      controller.decrement();
      expect(controller.data, 9);

      controller.decrement(decrement: 3);
      expect(controller.data, 6);
    });

    test('onUpdate callback is invoked', () {
      int? oldVal;
      int? newVal;
      final controller = PlexWidgetController<int>(
        data: 0,
        onUpdate: (prev, updated) {
          oldVal = prev;
          newVal = updated;
        },
      );

      controller.setValue(5);
      expect(oldVal, 0);
      expect(newVal, 5);

      controller.setValue(10);
      expect(oldVal, 5);
      expect(newVal, 10);
    });

    test('dispose sets isDisposed', () {
      final controller = PlexWidgetController<int>(data: 0);
      expect(controller.isDisposed, false);

      controller.dispose();
      expect(controller.isDisposed, true);
    });

    test('controller factory recreates when disposed', () {
      var controller = PlexWidgetController<int>(data: 42);
      controller.dispose();

      controller = PlexWidgetController.controller(controller);
      expect(controller.isDisposed, false);
      expect(controller.data, 42);
    });
  });

  group('PlexInputWidgetController', () {
    test('setError updates error and notifies', () {
      final controller = PlexInputWidgetController<String, String>(data: 'value');
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.setError('Invalid');
      expect(controller.error, 'Invalid');
      expect(notifyCount, 1);
    });
  });
}
