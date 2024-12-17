import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/config/update_interface.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class HomeCase with PreDestroy implements UpdateInterface {
  double positionValue = 0.0;

  late final StreamController<double> _position = StreamController<double>.broadcast();
  late final StreamController<SelecaoHorizontalDados> _dadosSelecaoHorizontal = StreamController<SelecaoHorizontalDados>.broadcast();

  Stream<double> get position => _position.stream;

  List<String> _itens = [];

  List<String> get itens => _itens;

  int _posicao = 0;

  int get posicao => _posicao;

  String get getByPosicao => itens[posicao];

  void changePosition(double value) {
    positionValue = value;

    _position.add(value);
  }

  @override
  FutureOr<void> onPreDestroy() {
    _position.close();
  }

  @override
  Stream<SelecaoHorizontalDados> get dados => _dadosSelecaoHorizontal.stream;

  @override
  void update(int posicao, List<String> itens) {
    _posicao = posicao;
    _itens = itens;
    _dadosSelecaoHorizontal.add((posicao, itens));
  }
}
