import 'dart:async';

import 'package:budgetopia/ui/home/case/home_case.dart';
import 'package:budgetopia/ui/home/state/opacity_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TimeLineOpacityController extends ValueNotifier<OpacityState> with PostConstruct, PreDestroy {
  TimeLineOpacityController() : super(OpacityState(0));

  bool exibindo = false;

  StreamSubscription<double>? _ref;

  late final HomeCase _homeCase = ddi();

  void changePosition(double value) {
    _homeCase.changeScrollPosition(value);
  }

  void _applyScrollPosition(double pos) {
    if ((exibindo && pos <= 10) || (!exibindo && pos > 10)) {
      exibindo = pos > 10;
      value = OpacityState(pos);
    }
  }

  @override
  FutureOr<void> onPostConstruct() {
    _ref = _homeCase.scrollPosition.listen(_applyScrollPosition);
  }

  @override
  FutureOr<void> onPreDestroy() {
    _ref?.cancel();
  }
}
