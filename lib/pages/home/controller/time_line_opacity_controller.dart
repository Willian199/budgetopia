import 'package:budgetopia/pages/home/model/opacity_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TimeLineOpacityController with DDIEventSender<OpacityState> {
  double _position = 0;
  void changeTabSelecionada(double value) {
    _position = value;
    fire(OpacityState(position: _position));
  }
}
