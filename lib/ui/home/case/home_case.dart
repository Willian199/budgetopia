import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/config/update_interface.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class HomeCase with PreDestroy implements UpdateInterface {
  late final StreamController<double> _scrollPosition = StreamController<double>.broadcast();
  late final StreamController<int> _slidePosition = StreamController<int>.broadcast();

  late final StreamController<List<String>> _dadosSelecaoHorizontal = StreamController<List<String>>.broadcast();

  List<String> _itens = [];

  List<String> get itens => _itens;

  int _slidePosicaoValue = 0;

  int get slidePosicaoValue => _slidePosicaoValue;

  String get getByPosicao => itens[_slidePosicaoValue];

  Stream<double> get scrollPosition => _scrollPosition.stream;

  @override
  Stream<int> get slidePosition => _slidePosition.stream;

  @override
  Stream<List<String>> get dados => _dadosSelecaoHorizontal.stream;

  @override
  void updatePosition(int value) {
    if (_slidePosicaoValue == value) {
      return;
    }

    _slidePosicaoValue = value;

    _slidePosition.add(value);
  }

  void changeScrollPosition(double value) {
    _scrollPosition.add(value);
  }

  @override
  FutureOr<void> onPreDestroy() {
    _scrollPosition.close();
  }

  void update(int posicao, List<String> itens) {
    _itens = itens;
    _dadosSelecaoHorizontal.add(itens);
    updatePosition(posicao);
  }
}
