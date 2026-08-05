import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class RemoverMovimentacaoUseCase {
  late final MovimentacaoRepository _repository = ddi();

  bool executar(int id) {
    if (id <= 0) {
      return false;
    }
    return _repository.remover(id);
  }
}
