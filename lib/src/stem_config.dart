import 'package:meta/meta.dart';

import 'package:stem/stem.dart';

class StemTransition<T> {
  final String name;
  final T oldValue;
  final T newValue;

  StemTransition(this.name, this.oldValue, this.newValue);

  @override
  String toString() =>
      'Transition(name: $name, oldValue: $oldValue, newValue: $newValue)';
}

abstract class StemChangeObserver {
  void onCreateStemState(StemState state) {}
  void onDisposeStemState(StemState state) {}
  void onTransition(StemState state, StemTransition transition) {}
  void onActionTrigger(Object value) {}

  void onCustomStemEvent(StemState state, Object value) {}
}

mixin StemEventNotifier {
  /// Enable or Disable [StemEventNotifier] for this object.
  bool eventActive = true;

  /// Called when [StemState] is inserted into the tree.
  @mustCallSuper
  @protected
  void created(StemState state) {
    if (!eventActive) return;
    if (StemConfig.instance.observer != null) {
      StemConfig.instance.observer?.onCreateStemState(state);
    }
  }

  /// Called when [StemState] is removed from the tree.
  @mustCallSuper
  @protected
  void deleted(StemState state) {
    if (!eventActive) return;
    if (StemConfig.instance.observer != null) {
      StemConfig.instance.observer?.onDisposeStemState(state);
    }
  }

  /// Called when [Stem] changes its value.
  @mustCallSuper
  @protected
  void changeEvent(StemState state, String name, oldValue, newValue) {
    if (!eventActive) return;
    if (StemConfig.instance.observer != null) {
      StemConfig.instance.observer
          ?.onTransition(state, StemTransition(name, oldValue, newValue));
    }
  }

  @mustCallSuper
  @protected
  void captureAction(Object action) {
    if (!eventActive) return;
    if (StemConfig.instance.observer != null) {
      StemConfig.instance.observer?.onActionTrigger(action);
    }
  }

  /// Can be called for custom events inside [StemState]
  ///
  /// Example:
  ///
  /// ```dart
  ///class CustomStemState extends StemState {
  ///   final count = Stem('count', 0);
  ///
  ///   void increment() {
  ///     // Call trigger to inform StemEventObserver
  ///     // for this custom method call
  ///     trigger("$this : Increment Called");
  ///     count.value++;
  ///   }
  ///
  ///   @override
  ///   void afterBuild() {
  ///     super.afterBuild();
  ///
  ///     increment();
  ///
  ///     print("Count Value: ${count()}"); // prints 1
  ///   }
  ///
  ///   List<Stem> get props => [count];
  /// }
  /// ```
  ///
  @mustCallSuper
  @protected
  void trigger(StemState state, Object action) {
    if (!eventActive) return;
    if (StemConfig.instance.observer != null) {
      StemConfig.instance.observer?.onCustomStemEvent(state, action);
    }
  }
}

/// Configuration for internal Classes
class StemConfig {
  StemConfig._();
  static final StemConfig _instance = StemConfig._();
  static StemConfig get instance => _instance;

  /// Assign this to observe events for [Stem] and [StemState]
  ///
  /// Example:
  ///
  /// ```dart
  /// class CustomStemEventObserver extends StemChangeObserver {
  ///   @override
  ///   void onStemChange(StemState state, oldValue, Stem newValue) {
  ///     super.onStemChange(state, oldValue, newValue);
  ///     log("Transition (${state.runtimeType}: ${newValue.name}): Current $oldValue"
  ///         " -> Next State ${newValue.value}");
  ///   }
  ///
  ///   @override
  ///   void onCreateStemState(StemState state) {
  ///     super.onCreateStemState(state);
  ///     log("Created: $state : ${state.hashCode}");
  ///   }
  ///
  ///   @override
  ///   void onDisposeStemState(StemState state) {
  ///     super.onDisposeStemState(state);
  ///     log("Deleted: $state : ${state.hashCode}");
  ///   }
  ///
  ///   @override
  ///   void onCustomStemEvent(StemState state, Object value) {
  ///     super.onCustomStemEvent(state, value);
  ///
  ///     log("Custom Event (${state.runtimeType}: $value");
  ///   }
  /// }

  /// void main() {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   StemConfig.instance.observer = CustomStemEventObserver();

  ///   runApp(const MyApp());
  /// }
  ///
  /// ```
  StemChangeObserver? observer;
}
