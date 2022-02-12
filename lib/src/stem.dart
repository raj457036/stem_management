import 'package:meta/meta.dart';
import 'package:stem/stem.dart';

abstract class StemState with StemEventNotifier {
  @protected
  bool built = false;

  @mustCallSuper
  void initState() {
    for (var prop in props) {
      prop.setParent(this);
    }
    created(this);
  }

  @mustCallSuper
  void afterBuild() {
    built = true;
  }

  @mustCallSuper
  void dispose() {
    for (var prop in props) {
      prop.dispose();
    }

    deleted(this);
  }

  List<Stem> get props;
}
