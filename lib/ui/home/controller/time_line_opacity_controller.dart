import 'package:budgetopia/ui/home/state/opacity_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TimeLineOpacityController with DDIEventSender<OpacityState> {
  bool exibindo = false;

  void changePosition(double value) {
    if ((exibindo && value <= 10) || (!exibindo && value > 10)) {
      exibindo = value > 10;
      fire(OpacityState(value));
    }
  }
}
