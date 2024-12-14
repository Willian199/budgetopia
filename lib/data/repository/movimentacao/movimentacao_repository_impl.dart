import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/generated/objectbox.g.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoRepositoryImpl implements MovimentacaoRepository {
  MovimentacaoRepositoryImpl();

  late final Box<MovimentacaoEntity> _entity = ddi.get<Database>().box<MovimentacaoEntity>();

  @override
  Stream<Map<String, List<MovimentacaoModel>>> filter() {
    final DateTime now = DateTime.now();
    final Stream<Query<MovimentacaoEntity>> query = _entity
        .query(MovimentacaoEntity_.data.greaterOrEqualDate(now.minusSixMonth.firstDayOfMonth))
        .order(MovimentacaoEntity_.data)
        .order(MovimentacaoEntity_.titulo)
        .watch(triggerImmediately: true);

    return query.map((query) {
      final Iterable<MovimentacaoEntity> itens = query.find();
      // Criar um mapa para agrupar os itens por nome do mês
      final Map<String, List<MovimentacaoModel>> groupedData = {};
      for (var item in itens) {
        // Extrair o nome do mês da data
        final String monthName = item.data.getFormattedMonth();
        // Verificar se já existe uma lista para esse mês, senão criar uma nova
        if (groupedData.containsKey(monthName)) {
          groupedData[monthName]!.add(MovimentacaoModel.fromMovimentacaoEntity(item));
        } else {
          groupedData[monthName] = [MovimentacaoModel.fromMovimentacaoEntity(item)];
        }
      }
      return groupedData;
    });
  }

  @override
  int salvar(MovimentacaoEntity movimentacaoEntity) => _entity.put(movimentacaoEntity);

  @override
  bool remover(int id) => _entity.remove(id);
}
