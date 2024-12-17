import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoCase {
  late DateTime dataSelecionada = DateTime.now();
  late CategoriaEnum categoriaSelecionada = CategoriaEnum.values.first;
  late TipoMovimentacaoEnum tipoMovimentacaoSelecionada = TipoMovimentacaoEnum.entrada;
  late bool status = false;

  late final MovimentacaoRepository _movimentacaoService = ddi();

  bool salvar({required String titulo, required double valor, required String observacao, required int id}) {
    final MovimentacaoEntity obj = MovimentacaoEntity(
      id: id,
      data: dataSelecionada,
      tipoMovimentacao: tipoMovimentacaoSelecionada.id,
      codigoCategoria: categoriaSelecionada.id,
      titulo: titulo,
      valor: valor,
      observacao: observacao,
      status: status,
    );

    return _movimentacaoService.salvar(obj) > 0;
  }

  bool remover(int id) => _movimentacaoService.remover(id);
}
