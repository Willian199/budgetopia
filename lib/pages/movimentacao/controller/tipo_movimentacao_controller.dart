import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TipoMovimentacaoController with DDIEventSender<TipoMovimentacaoEnum> {
  List<TipoMovimentacaoEnum> get listarTiposMovimentacao => TipoMovimentacaoEnum.values;

  TipoMovimentacaoEnum get tipoMovimentacaoSelecionada => super.state ?? TipoMovimentacaoEnum.entrada;

  void selecionarTipoMovimentacao(TipoMovimentacaoEnum? valor) {
    if (valor == null) {
      return;
    }
    fire(valor);
  }
}
