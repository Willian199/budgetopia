import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/ui/movimentacao/case/movimentacao_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TipoMovimentacaoController extends ValueNotifier<TipoMovimentacaoEnum> {
  TipoMovimentacaoController() : super(TipoMovimentacaoEnum.entrada);

  List<TipoMovimentacaoEnum> get listarTiposMovimentacao => TipoMovimentacaoEnum.values;

  late final MovimentacaoCase _movimentacaoCase = ddi();

  void selecionarTipoMovimentacao(TipoMovimentacaoEnum? valor) {
    if (valor == null) {
      return;
    }
    _movimentacaoCase.tipoMovimentacaoSelecionada = valor;
    value = valor;
  }
}
