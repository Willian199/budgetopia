import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TipoMovimentacaoController with DDIEventSender<TipoMovimentacaoEnum> {
  late TipoMovimentacaoEnum _tipoMovimentacaoSelecionada = TipoMovimentacaoEnum.entrada;

  List<TipoMovimentacaoEnum> get listarTiposMovimentacao => TipoMovimentacaoEnum.values;

  TipoMovimentacaoEnum get tipoMovimentacaoSelecionada => _tipoMovimentacaoSelecionada;

  void selecionarTipoMovimentacao(TipoMovimentacaoEnum? valor) {
    if (valor == null) {
      return;
    }
    _tipoMovimentacaoSelecionada = valor;
    fire(_tipoMovimentacaoSelecionada);
  }
}
