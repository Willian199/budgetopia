import 'dart:async';

import 'package:budgetopia/ui/home/case/home_case.dart';
import 'package:budgetopia/ui/home/state/opacity_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TimeLineOpacityController with DDIEventSender<OpacityState>, PostConstruct, PreDestroy {
  bool exibindo = false;
  late final StreamSubscription<double> _ref;

  late final HomeCase _homeCase = ddi();

  void changePosition(double value) {
    _homeCase.changePosition(value);
  }

  void _applyPosition(double value) {
    if ((exibindo && value <= 10) || (!exibindo && value > 10)) {
      exibindo = value > 10;
      fire(OpacityState(value));
    }
  }

  @override
  FutureOr<void> onPostConstruct() {
    _ref = _homeCase.position.listen(_applyPosition);
  }

  @override
  FutureOr<void> onPreDestroy() {
    _ref.cancel();
  }
}
