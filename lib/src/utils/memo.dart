/// A type of value that remembers its last [size] no states.
///
/// i.e you can use this to support `undo` and `redo`
class Memoize<T> {
  int _index = -1;
  final _memo = <T>[];
  final int size;

  Memoize(T initial, {this.size = 8}) {
    value = initial;
  }

  T get value => _memo[_index];

  set value(T value) {
    if (_cursorIsBehind) {
      _memo.replaceRange(_index + 1, _memo.length, [value]);
    } else {
      _memo.add(value);
    }

    _moveCursor();
  }

  bool get _cursorIsBehind => _index < _memo.length - 1;

  void _moveCursor() {
    _index++;
    final diff = _index - size;

    if (!diff.isNegative) {
      _memo.removeRange(0, diff);
      _index -= diff;
    }
  }

  /// go back to last known state.
  void undo() => _index > 0 ? _index-- : null;

  /// go forward to to future state if available.
  void redo() => _index < _memo.length - 1 ? _index++ : null;
}
