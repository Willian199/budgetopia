import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/generated/objectbox.g.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:budgetopia/pages/movimentacao/model/movimentacao_model.dart';

class ListaMovimentacaoController {
  ListaMovimentacaoController({required Database database}) : _entity = database.box<MovimentacaoEntity>();

  final Box<MovimentacaoEntity> _entity;

  List<MovimentacaoModel> filter(TipoRegistroEnum aba) {
    Condition<MovimentacaoEntity> qc = MovimentacaoEntity_.data.greaterOrEqualDate(DateTime.now().firstDayOfMonth);

    if (aba != TipoRegistroEnum.todos) {
      qc = qc.and(MovimentacaoEntity_.tipoMovimentacao.equals(aba.posicao));
    }

    final Query<MovimentacaoEntity> query = _entity.query(qc).build();

    final Iterable<MovimentacaoEntity> itens = query.find().reversed;

    return itens.map((e) => MovimentacaoModel.fromMovimentacaoEntity(e)).toList();
  }
}
