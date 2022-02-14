import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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
      change(_parent!, name, _temp, _value);
    }
    notifyListeners();
  }

  /// force update this stem
  void forceUpdate() => notifyListeners();

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
        change(_parent!, name, _temp, _value);
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

class TripleStem<T> extends Stem<UnionStateType> {
  dynamic _error;
  T _data;

  TripleStem(
    String name,
    T value, {
    bool registerEvent = true,
  })  : _data = value,
        super(
          name,
          value != null ? UnionStateType.data : UnionStateType.loading,
          registerEvent: registerEvent,
        );

  UnionStateType get currentState => value;
  dynamic get error => _error;
  T get data => _data;

  bool get isLoading => currentState == UnionStateType.loading;
  bool get hasData => currentState == UnionStateType.data;
  bool get hasError => currentState == UnionStateType.error;

  @protected
  @override
  set value(UnionStateType newValue) {
    final check = doPreChecks(newValue);

    if (!check) return;
    _value = newValue;
    notifyListeners();
  }

  setError(dynamic error) {
    if (eventActive) {
      _emitEvent("Error: $error");
    }
    _error = error;
    value = UnionStateType.error;
  }

  setLoading() {
    if (eventActive) {
      _emitEvent('Loading');
    }
    value = UnionStateType.loading;
  }

  setData(T data) {
    if (eventActive) {
      _emitEvent(data);
    }
    _data = data;
    value = UnionStateType.data;
  }

  Widget on({
    required ErroBuilder<dynamic> error,
    required DataBuilder<T> data,
    required LoadingBuilder loading,
  }) {
    switch (value) {
      case UnionStateType.data:
        return data(_data);
      case UnionStateType.error:
        return error(_error);
      case UnionStateType.loading:
      default:
        return loading(_data);
    }
  }

  _emitEvent(dynamic next) {
    dynamic current;

    switch (value) {
      case UnionStateType.loading:
        current = 'Loaidng';
        break;
      case UnionStateType.error:
        current = 'Error: $error';
        break;
      case UnionStateType.data:
      default:
        current = data;
    }

    change(_parent!, name, current, next);
  }
}
