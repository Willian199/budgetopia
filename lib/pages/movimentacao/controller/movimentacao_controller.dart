import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/generated/objectbox.g.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:budgetopia/pages/movimentacao/controller/categoria_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/data_movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/tipo_movimentacao_controller.dart';

class MovimentacaoController {
  MovimentacaoController({
    required DataMovimentacaoController dataMovimentacaoController,
    required CategoriaController categoriaController,
    required TipoMovimentacaoController tipoMovimentacaoController,
    required Database database,
  })  : _dataMovimentacaoController = dataMovimentacaoController,
        _categoriaController = categoriaController,
        _tipoMovimentacaoController = tipoMovimentacaoController,
        _entity = database.box<MovimentacaoEntity>();

  final DataMovimentacaoController _dataMovimentacaoController;
  final CategoriaController _categoriaController;
  final TipoMovimentacaoController _tipoMovimentacaoController;
  final Box<MovimentacaoEntity> _entity;

  bool salvar({required String titulo, required double valor, required String observacao}) {
    _dataMovimentacaoController.dataSelecionada;
    _categoriaController.categoriaSelecionada;

    final MovimentacaoEntity obj = MovimentacaoEntity(
      data: _dataMovimentacaoController.dataSelecionada,
      tipoMovimentacao: _tipoMovimentacaoController.tipoMovimentacaoSelecionada.id,
      codigoCategoria: _categoriaController.categoriaSelecionada.id,
      titulo: titulo,
      valor: valor,
      observacao: observacao,
    );

    _entity.put(obj);

    return true;
  }
}
