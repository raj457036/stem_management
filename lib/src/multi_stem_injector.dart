import 'package:flutter/widgets.dart';
import 'package:stem/src/types.dart';

import 'stem_state_injector.dart';

// class MultiControllerInjector extends StatelessWidget {
//   final Widget child;
//   final List<StemStateBuilder> builders;

//   const MultiControllerInjector(
//       {Key? key, required this.builders, required this.child})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Widget _parent = child;

//     for (var builder in builders) {
//       _parent = StemStateInjector(stem: builder, child: _parent);
//     }

//     return _parent;
//   }
// }
