import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  final Widget child;
  const Root({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }
}
