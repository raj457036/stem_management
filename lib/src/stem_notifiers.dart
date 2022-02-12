import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stem/stem.dart';

class Stem<T> extends ChangeNotifier
    with StemEventNotifier
    implements ValueListenable<T> {
  final String name;

  late T _value;

  StemState? _parent;

  Stem(this.name, this._value);

  void setParent(StemState parent) => _parent = parent;

  @override
  T get value => _value;

  set value(T newValue) {
    final check = doPreChecks(newValue);

    if (!check) return;

    final _temp = _value;
    _value = newValue;
    change(_parent!, _temp, this);
    notifyListeners();
  }

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

class DebouncedStem<T> extends Stem<T> {
  final Duration duration;
  DebouncedStem(
    String name,
    T value, {
    this.duration = const Duration(milliseconds: 500),
  }) : super(name, value);

  Timer? timer;

  @override
  set value(T newValue) {
    final check = doPreChecks(newValue);

    if (!check) return;
    timer?.cancel();
    timer = Timer(duration, () {
      final _temp = _value;
      _value = newValue;
      change(_parent!, _temp, this);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
