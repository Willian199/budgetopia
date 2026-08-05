import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';
import 'package:budgetopia/config/banco/generated/objectbox.g.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:budgetopia/data/service/recorrencia/recorrencia_service.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class RecorrenciaServiceImpl implements RecorrenciaService {
  RecorrenciaServiceImpl();

  late final Box<RecorrenciaMovimentacaoEntity> _recorrenciaBox = ddi
      .get<Database>()
      .box<RecorrenciaMovimentacaoEntity>();
  late final Box<MovimentacaoEntity> _movimentacaoBox = ddi.get<Database>().box<MovimentacaoEntity>();

  @override
  Stream<List<RecorrenciaMovimentacaoEntity>> buscarRecorrencias() {
    final query = _recorrenciaBox
        .query(RecorrenciaMovimentacaoEntity_.ativo.equals(true))
        .order(RecorrenciaMovimentacaoEntity_.titulo)
        .watch(triggerImmediately: true);

    return query.map((event) => event.find());
  }

  @override
  List<RecorrenciaMovimentacaoEntity> listarRecorrenciasAtivas() {
    final Query<RecorrenciaMovimentacaoEntity> query = _recorrenciaBox
        .query(RecorrenciaMovimentacaoEntity_.ativo.equals(true))
        .order(RecorrenciaMovimentacaoEntity_.dataInicio)
        .build();
    try {
      return query.find();
    } finally {
      query.close();
    }
  }

  @override
  int salvar(RecorrenciaMovimentacaoEntity recorrenciaEntity) => _recorrenciaBox.put(recorrenciaEntity);

  @override
  bool remover(int id) => _recorrenciaBox.remove(id);

  @override
  RecorrenciaMovimentacaoEntity? buscarPorId(int id) => _recorrenciaBox.get(id);

  @override
  List<MovimentacaoEntity> buscarMovimentacoesPorRecorrencia({
    required int recorrenciaId,
    DateTime? ateData,
    int limit = 12,
  }) {
    final Query<MovimentacaoEntity> query = _movimentacaoBox
        .query(MovimentacaoEntity_.codigoRecorrencia.equals(recorrenciaId))
        .order(MovimentacaoEntity_.data, flags: Order.descending)
        .build();

    try {
      final List<MovimentacaoEntity> items = ateData == null
          ? query.find()
          : query.find().where((item) => !item.data.isAfter(ateData)).toList(growable: false);
      return items.take(limit).toList(growable: false);
    } finally {
      query.close();
    }
  }

  @override
  bool existeMovimentacaoConfirmada({
    required int recorrenciaId,
    required DateTime data,
  }) {
    final Query<MovimentacaoEntity> query = _movimentacaoBox
        .query(MovimentacaoEntity_.codigoRecorrencia.equals(recorrenciaId))
        .build();

    try {
      return query.find().any((item) => _isSameDate(item.data, data));
    } finally {
      query.close();
    }
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
