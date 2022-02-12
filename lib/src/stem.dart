import 'package:meta/meta.dart';

abstract class Stem {
  @protected
  bool built = false;

  void initState() {}

  @mustCallSuper
  void afterBuild() {
    built = true;
  }

  void dispose() {}
}
