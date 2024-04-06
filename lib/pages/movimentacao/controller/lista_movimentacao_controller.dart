import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/generated/objectbox.g.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:budgetopia/pages/movimentacao/model/movimentacao_model.dart';

class ListaMovimentacaoController {
  ListaMovimentacaoController({required Database database}) : _entity = database.box<MovimentacaoEntity>();

  final Box<MovimentacaoEntity> _entity;

  Stream<List<MovimentacaoModel>> filter() {
    final DateTime now = DateTime.now();
    final Stream<Query<MovimentacaoEntity>> query = _entity
        .query(MovimentacaoEntity_.data.greaterOrEqualDate(now.firstDayOfMonth).and(MovimentacaoEntity_.data.lessOrEqualDate(now.lastDayOfMonth)))
        .order(MovimentacaoEntity_.data, flags: Order.descending)
        .order(MovimentacaoEntity_.titulo)
        .watch(triggerImmediately: true);

    return query.map((query) {
      final Iterable<MovimentacaoEntity> itens = query.find();
      return itens.map((e) => MovimentacaoModel.fromMovimentacaoEntity(e)).toList();
    });
  }
}
