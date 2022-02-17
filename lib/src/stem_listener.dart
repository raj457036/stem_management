import 'package:flutter/widgets.dart';

import 'stem_state.dart';
import 'stem_notifiers.dart';
import 'stem_state_injector.dart';
import 'types.dart';

/// {@template stem_listener}
/// Use this when you only want to listen for the change in [Stem]
/// for side effects.
///
/// ```dart
/// // CounterState
/// class CounterState extends StemState {
///   final counter = Stem('counter', 0);
///
///   void increment() => counter.value++;
///   void decrement() => counter.value--;
///
///   @override
///   List<Stem> get props => [counter];
/// }
///
/// // widgets
///
/// class Counter extends StatelessWidget {
///    @override
///    Widget build(BuildContext context) {
///      return StemStateInjector<CounterState>(
///         create: () => CounterState(),
///           child: StemListener<CounterState, int>(
///            listenTo: (controller) => controller.counter,
///            onListen: (value) {
///              // onListen will be called every time controller.counter
///              // changes its value.
///              print("counter value changed");
///            },
///            child: SomeOtherWidget(),
///           )
///         );
///    }
/// }
/// ```
///
///{@endtemplate}
class StemListener<T extends StemState, K> extends StatefulWidget {
  /// A widget child of which this [StemListener] become parent of.
  final Widget child;

  /// A callback that returns the [Stem] to which this [StemListener] will
  /// listen to.
  final StemGetter<T, K> listenTo;

  /// A callback to be called when there is any change captured in
  /// the [Stem] returned from `listenTo` with value of this [Stem];
  final SideEffectCallback<T> onListen;

  /// {@macro stem_listener}
  const StemListener({
    Key? key,
    required this.listenTo,
    required this.child,
    required this.onListen,
  }) : super(key: key);

  @override
  State<StemListener<T, K>> createState() => _StemListenerState<T, K>();
}

class _StemListenerState<T extends StemState, K>
    extends State<StemListener<T, K>> {
  T? _controller;
  Stem<K>? _stem;

  void _listenerValueChanged() => widget.onListen(_controller!);

  @override
  Widget build(BuildContext context) {
    _controller = StateInjector.of<T>(context);
    return widget.child;
  }

  // add listeners
  void setListeners() {
    if (_controller != null) {
      _stem = widget.listenTo(_controller!);
      _stem?.addListener(_listenerValueChanged);
    }
  }

  // remove listeners
  void unsetListeners() {
    if (_controller != null) {
      _stem?.removeListener(_listenerValueChanged);
    }
  }

  @override
  void dispose() {
    unsetListeners();
    super.dispose();
  }
}

/// {@template stem_listener}
/// Use this when you only want to listen for the change in multiple [Stem]s
/// for side effects.
///
/// See Also:
///
/// - [StemListener]: Listens to only one [Stem]
///
///{@endtemplate}
class MultiStemListener<T extends StemState> extends StatefulWidget {
  /// A widget child of which this [StemListener] become parent of.
  final Widget child;

  /// A callback that returns the [Stem] to which this [StemListener] will
  /// listen to.
  final MultiStemGetter<T> listenTo;

  /// A callback to be called when there is any change captured in
  /// the [Stem] returned from `listenTo` with value of this [Stem];
  final SideEffectCallback<T> onListen;

  /// {@macro stem_listener}
  const MultiStemListener({
    Key? key,
    required this.listenTo,
    required this.child,
    required this.onListen,
  }) : super(key: key);

  @override
  State<MultiStemListener<T>> createState() => _MultiStemListenerState<T>();
}

class _MultiStemListenerState<T extends StemState>
    extends State<MultiStemListener<T>> {
  T? _controller;
  late List<Stem> stems;

  @override
  void initState() {
    super.initState();
    _controller = StateInjector.elementOf<T>(context)?.state;
    setListeners();
  }

  void _listenerValueChanged() => widget.onListen(_controller!);

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return ErrorWidget("$T not found.");
    }

    return widget.child;
  }

  // add listeners
  void setListeners() {
    if (_controller != null) {
      stems = widget.listenTo(_controller!);
      for (var stem in stems) {
        stem.addListener(_listenerValueChanged);
      }
    }
  }

  // remove listeners
  void unsetListeners() {
    if (_controller != null) {
      for (var stem in stems) {
        stem.removeListener(_listenerValueChanged);
      }
    }
  }

  @override
  void dispose() {
    unsetListeners();
    super.dispose();
  }
}
