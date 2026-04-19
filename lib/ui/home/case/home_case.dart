import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/config/update_interface.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// Gerencia o estado da tela Home relacionado a posição de scroll
/// e seleção horizontal de Mes. Fornece streams para
/// observadores receberem atualizações de posição e dados.
final class HomeCase with PreDestroy implements UpdateInterface {
  late final StreamController<double> _scrollPosition = StreamController<double>.broadcast();
  late final StreamController<int> _slidePosition = StreamController<int>.broadcast();

  late final StreamController<(int, List<String>)> _dadosSelecaoHorizontal =
      StreamController<(int, List<String>)>.broadcast();

  List<String> _itens = [];

  /// Retorna a lista atual de itens exibidos na seleção horizontal.
  List<String> get itens => _itens;

  int _slidePosicaoValue = 0;

  /// Índice da posição atualmente selecionada (slide).
  int get slidePosicaoValue => _slidePosicaoValue;

  /// Retorna o item corrente conforme `slidePosicaoValue`.
  String? get itemSelecionado {
    if (_itens.isEmpty || _slidePosicaoValue < 0 || _slidePosicaoValue >= _itens.length) {
      return null;
    }

    return _itens[_slidePosicaoValue];
  }

  /// Stream broadcast que emite a posição de scroll vertical/horizontal
  /// (valor `double`) quando `changeScrollPosition` é chamado.
  Stream<double> get scrollPosition => _scrollPosition.stream;

  /// Stream broadcast que emite o índice do slide atual (`int`).
  @override
  Stream<int> get slidePosition => _slidePosition.stream;

  /// Stream broadcast que emite uma tupla contendo o índice selecionado
  /// e a lista de itens associada: `(posicao, itens)`.
  @override
  Stream<(int, List<String>)> get dados => _dadosSelecaoHorizontal.stream;

  /// Atualiza a posição do slide para `value` e notifica ouvintes via
  /// `slidePosition` caso o valor tenha mudado.
  @override
  void updatePosition(int value) {
    if (_slidePosicaoValue == value) {
      return;
    }

    _slidePosicaoValue = value;

    _slidePosition.add(value);
  }

  /// Emite uma nova posição de scroll (`double`) para `scrollPosition`.
  void changeScrollPosition(double value) {
    _scrollPosition.add(value);
  }

  /// Fecha os `StreamController`s usados pela classe. Deve ser chamado
  /// antes da destruição/limpeza do componente para evitar vazamentos.
  @override
  FutureOr<void> onPreDestroy() {
    _scrollPosition.close();
    _slidePosition.close();
    _dadosSelecaoHorizontal.close();
  }

  /// Atualiza o conjunto de `itens` exibidos e a `posicao` selecionada,
  /// emitindo os dados atualizados via `dados`.
  void update(int posicao, List<String> itens) {
    _itens = itens;
    _slidePosicaoValue = posicao;
    _dadosSelecaoHorizontal.add((posicao, itens));
  }
}
