import 'package:stem/stem.dart';

abstract class StemChangeObserver {
  void onCreateStemState(StemState state) {}
  void onDisposeStemState(StemState state) {}
  void onStemChange(StemState state, oldValue, Stem newValue) {}
}

mixin StemEventNotifier {
  created(StemState state) {
    if (StemConfig.instance.observer != null) {
      StemConfig.instance.observer?.onCreateStemState(state);
    }
  }

  deleted(StemState state) {
    if (StemConfig.instance.observer != null) {
      StemConfig.instance.observer?.onDisposeStemState(state);
    }
  }

  change(StemState state, oldValue, Stem newValue) {
    if (StemConfig.instance.observer != null) {
      StemConfig.instance.observer?.onStemChange(state, oldValue, newValue);
    }
  }
}

class StemConfig {
  StemConfig._();
  static final StemConfig _instance = StemConfig._();
  static StemConfig get instance => _instance;

  StemChangeObserver? observer;
}
