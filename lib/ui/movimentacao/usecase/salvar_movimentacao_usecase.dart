import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/data/repository/recorrencia/recorrencia_repository.dart';
import 'package:budgetopia/ui/movimentacao/enum/tipo_cadastro_movimentacao_enum.dart';
import 'package:budgetopia/common/dto/movimentacao_salvar_resultado.dart';
import 'package:budgetopia/common/dto/salvar_movimentacao_request.dart';
import 'package:budgetopia/ui/movimentacao/usecase/movimentacao_formulario_usecase.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class SalvarMovimentacaoUseCase {
  late final MovimentacaoRepository _repository = ddi();
  late final RecorrenciaRepository _recorrenciaRepository = ddi();
  late final MovimentacaoFormularioUseCase _formularioUseCase = ddi();

  MovimentacaoSalvarResultado executar(SalvarMovimentacaoRequest request) {
    final double valorMovimentacao = _formularioUseCase.parseValor(request.valor);
    final bool isParcelado = request.isCadastroParcelado;
    final bool isRecorrencia = request.isCadastroRecorrencia;
    final int quantidadeParcelas = isParcelado ? _formularioUseCase.parseQuantidadeParcelas(request.parcelas) : 1;

    if (!request.formValido || valorMovimentacao <= 0 || quantidadeParcelas <= 0) {
      return const MovimentacaoSalvarResultado.erro('Verifique os dados informados!');
    }

    final bool sucesso = _salvar(
      request: request,
      titulo: request.titulo.trim(),
      valor: valorMovimentacao,
      observacao: request.observacao.trim(),
      parcelas: quantidadeParcelas,
    );

    if (!sucesso) {
      return const MovimentacaoSalvarResultado.erro('Erro ao salvar transação');
    }

    if (isParcelado) {
      return MovimentacaoSalvarResultado.sucesso('$quantidadeParcelas transações parceladas salvas!');
    }
    if (isRecorrencia) {
      return MovimentacaoSalvarResultado.sucesso(
        request.isEdicaoRecorrencia ? 'Recorrência atualizada com sucesso!' : 'Recorrência cadastrada com sucesso!',
      );
    }
    return const MovimentacaoSalvarResultado.sucesso('Transação salva!');
  }

  bool _salvar({
    required SalvarMovimentacaoRequest request,
    required String titulo,
    required double valor,
    required String observacao,
    required int parcelas,
  }) {
    if (request.tipoCadastro == TipoCadastroMovimentacaoEnum.parcelado && request.id == 0) {
      return _salvarParcelado(
        request: request,
        titulo: titulo,
        valor: valor,
        observacao: observacao,
        parcelas: parcelas,
      );
    }

    if (request.tipoCadastro == TipoCadastroMovimentacaoEnum.recorrencia && request.id == 0) {
      return _salvarRecorrencia(
        request: request,
        titulo: titulo,
        valor: valor,
        observacao: observacao,
      );
    }

    final entity = MovimentacaoEntity(
      id: request.id,
      titulo: titulo,
      valor: valor,
      observacao: observacao,
      data: request.data,
      codigoCategoria: request.categoria.id,
      tipoMovimentacao: request.tipoMovimentacao.id,
      status: request.status,
      codigoRecorrencia: request.codigoRecorrencia,
    );
    return _repository.salvar(entity) > 0;
  }

  bool _salvarParcelado({
    required SalvarMovimentacaoRequest request,
    required String titulo,
    required double valor,
    required String observacao,
    required int parcelas,
  }) {
    if (parcelas <= 1) {
      return false;
    }

    final List<MovimentacaoEntity> entidades = <MovimentacaoEntity>[];
    for (int indice = 0; indice < parcelas; indice++) {
      entidades.add(
        MovimentacaoEntity(
          titulo: titulo,
          valor: valor,
          observacao: observacao,
          data: _addMonths(request.data, indice),
          codigoCategoria: request.categoria.id,
          tipoMovimentacao: request.tipoMovimentacao.id,
          status: request.status,
        ),
      );
    }

    final List<int> ids = _repository.salvarTodos(entidades);
    if (ids.length != parcelas) {
      return false;
    }
    return ids.every((id) => id > 0);
  }

  bool _salvarRecorrencia({
    required SalvarMovimentacaoRequest request,
    required String titulo,
    required double valor,
    required String observacao,
  }) {
    if (request.tipoRecorrencia.usaIntervaloDias && request.intervaloRecorrenciaDias <= 0) {
      return false;
    }

    final RecorrenciaMovimentacaoEntity entity = RecorrenciaMovimentacaoEntity(
      id: request.recorrenciaId,
      titulo: titulo,
      valorBase: valor,
      observacao: observacao,
      dataInicio: request.data,
      dataFim: request.recorrenciaSemDataFim ? DateTime(1) : request.dataFimRecorrencia,
      codigoCategoria: request.categoria.id,
      tipoMovimentacao: request.tipoMovimentacao.id,
      tipoRecorrencia: request.tipoRecorrencia.id,
      intervaloDias: request.tipoRecorrencia.usaIntervaloDias ? request.intervaloRecorrenciaDias : 0,
      statusPadrao: request.status,
    );

    return _recorrenciaRepository.salvar(entity) > 0;
  }

  DateTime _addMonths(DateTime baseDate, int monthsToAdd) {
    final int monthIndex = baseDate.month - 1 + monthsToAdd;
    final int year = baseDate.year + (monthIndex ~/ 12);
    final int month = monthIndex % 12 + 1;
    final int lastDayOfTargetMonth = DateTime(year, month + 1, 0).day;
    final int day = baseDate.day > lastDayOfTargetMonth ? lastDayOfTargetMonth : baseDate.day;
    return DateTime(
      year,
      month,
      day,
      baseDate.hour,
      baseDate.minute,
      baseDate.second,
      baseDate.millisecond,
      baseDate.microsecond,
    );
  }
}
