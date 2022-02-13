import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stem/stem.dart';

/// {@template stem}
/// A [ChangeNotifier] that holds a single value and tightly
/// associated with [StemState] via `props` getter.
///
/// When [value] is replaced with something that is not
/// equal to the old value as evaluated by the equality
/// operator ==, this class notifies [StemBuilder] or [StemListener] which are.
/// listening to `this` [Stem].
///
/// ### properties
/// 1. `name` : Name of this [Stem] for [StemChangeObserver]
/// 2. `value`: Value of this [Stem]
/// 3. `registerEvent` : if `false`, [StemChangeObserver] will not notify of
/// any change to this stem. @default: true
///{@endtemplate}
///
///{@template stem_example}
/// Example:
///
/// ```dart
/// class CustomStemState extends StemState {
///   final count = Stem('count', 0);
///
///   List<Stem> get props => [count];
/// }
/// ```
///
/// {@endtemplate}
///
///
/// See Also:
///
/// [DebouncedStem]: A [Stem] that delays its [value] replacement.
///
class Stem<T> extends ChangeNotifier
    with StemEventNotifier
    implements ValueListenable<T> {
  /// Name of this [Stem] for [StemChangeObserver]
  final String name;

  /// Actial value of this [Stem]
  late T _value;

  /// [StemState] with which this [Stem] is associated with.
  StemState? _parent;

  /// {@macro stem}
  ///
  /// {@macro stem_example}
  ///
  /// See Also:
  ///
  /// [DebouncedStem]: A [Stem] that delays its [value] replacement and
  /// prevent frequent changes.
  ///
  Stem(this.name, this._value, {bool registerEvent = true}) {
    eventActive = registerEvent;
  }

  /// This method is used by [StemState] to associate this [Stem] with itself
  void setParent(StemState parent) => _parent = parent;

  /// Value of this [Stem]
  @override
  T get value => _value;

  set value(T newValue) {
    /// Pre Checks
    final check = doPreChecks(newValue);

    if (!check) return;

    final _temp = _value;
    _value = newValue;

    if (eventActive) {
      change(_parent!, _temp, this);
    }
    notifyListeners();
  }

  /// A helper to get `value` via call syntex
  ///
  /// ```dart
  ///class CustomStemState extends StemState {
  ///   final count = Stem('count', 0);
  ///
  ///   @overried
  ///   void initState() {
  ///     super.initState();
  ///
  ///     print("count value: ${count()}"); // prints 0
  ///   }
  ///
  ///   List<Stem> get props => [count];
  /// }
  /// ```
  T call() => value;

  /// Check if `newValue` is same as `_value` (current value)
  ///
  /// Also checks if this stem has been associated with any [StemState]
  /// if not throws Exception.
  bool doPreChecks(T newValue) {
    if (_value == newValue) {
      return false;
    }

    if (_parent == null) {
      throw Exception(
        "$name is not assigned to any StemState. "
        "make sure this is added to props of StemState.",
      );
    }
    return true;
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

/// A [Stem] that delays its [value] replacement and prevent frequent changes.
///
/// {@macro stem}
///
/// {@template debounceStem}
///
/// 4. `duration`: delay after which [value] get replaced.
///  @default `500ms`
///
/// ```dart
///class CustomStemState extends StemState {
///   final count = DebouncedStem('count', 0);
///
///   void increment() {
///     count.value++;
///   }
///
///   @override
///   void afterBuild() {
///     super.afterBuild();
///
///     // rapidly calling increment 10 times
///     for (int i = 0; i < 10; i++) {
///       increment();
///     }
///
///     print("Count Value: ${count()}"); // prints 1
///   }
///
///   List<Stem> get props => [count];
/// }
/// ```
///
/// {@endtemplate}
class DebouncedStem<T> extends Stem<T> {
  /// Delay after which [value] get replaced.
  final Duration duration;

  /// {@macro stem}
  /// {@macro debounceStem}
  DebouncedStem(
    String name,
    T value, {
    this.duration = const Duration(milliseconds: 500),
    bool registerEvent = true,
  }) : super(name, value, registerEvent: registerEvent);

  /// Internal timer to track of the last change
  Timer? timer;

  @override
  set value(T newValue) {
    final check = doPreChecks(newValue);

    if (!check) return;
    timer?.cancel();
    timer = Timer(duration, () {
      final _temp = _value;
      _value = newValue;

      if (eventActive) {
        change(_parent!, _temp, this);
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
