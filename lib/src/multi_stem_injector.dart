import 'package:flutter/widgets.dart';

import 'stem.dart';
import 'stem_injector.dart';

class MultiControllerInjector extends StatelessWidget {
  final Widget child;
  final List<Stem> controllers;

  const MultiControllerInjector(
      {Key? key, required this.controllers, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _parent = child;

    for (var controller in controllers) {
      _parent = StemInjector(controller: controller, child: _parent);
    }

    return _parent;
  }
}
