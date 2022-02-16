import 'package:flutter/widgets.dart';
import 'package:stem/stem.dart';

/// [StemState] is like Flutter's [State] object that hold
/// the logic and state for the tree.
///
/// [StemState] has 3 life cycle hooks
///
/// 1. `initState` : Called when this StemState is inserted into the tree.
/// 2. `afterBuild`: Called just after the first frame is called, after this
/// StemState is inserted into the tree.
/// 3. `dispose`: Called when this [StemState] is removed from the tree permanently.
///
/// [StemState] can hold any property but to store reactive property we use [Stem]
///
/// [Stem]s are basically [ChangeNotifier] with internal bindings with [StemState]
/// for effective memory management (1).
///
/// [props] : List of [Stem] that are part of this StemState (1)
///
/// See Also:
/// [Stem] :
/// [DebouncedStem] :
///
abstract class StemState with StemEventNotifier {
  @protected
  bool _mounted = false;

  /// Whether this StemState object is currently in a tree.
  bool get mounted => _mounted;

  /// Called when this StemState is inserted into the tree.
  ///
  /// The framework will call this method exactly once
  /// for each StemState object it creates.
  @mustCallSuper
  void initState() {
    for (var prop in props) {
      prop.setParent(this);
    }
    if (eventActive) {
      created(this);
    }
  }

  /// Called just after the first frame is called, after this
  /// StemState is inserted into the tree.
  ///
  /// The framework will call this method exactly once after
  /// each StemState object it creates.
  @mustCallSuper
  void afterBuild() {
    _mounted = true;
  }

  /// Called when this StemState is removed from the tree permanently.
  ///
  /// The framework calls this method when this StemState object will
  /// never build again.
  @mustCallSuper
  void dispose() {
    for (var prop in props) {
      prop.dispose();
    }
    _mounted = false;
    if (eventActive) {
      deleted(this);
    }
  }

  /// List of [Stem] that are associated with this StemState
  ///
  /// ```dart
  /// class CustomStemState extends StemState {
  ///   final count = Stem('count', 0);
  ///
  ///   List<Stem> get props => [count];
  /// }
  ///
  /// ```
  List<Stem> get props;
}
