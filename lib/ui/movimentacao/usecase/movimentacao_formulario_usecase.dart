import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/dto/movimentacao_formulario_dados.dart';
import 'package:budgetopia/common/dto/movimentacao_formulario_estado.dart';
import 'package:budgetopia/common/dto/movimentacao_formulario_resultado.dart';
import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_cadastro_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_recorrencia_enum.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/recorrencia/recorrencia_repository.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class MovimentacaoFormularioUseCase {
  late final RecorrenciaRepository _recorrenciaRepository = ddi();

  MovimentacaoFormularioResultado novoCadastro() {
    return MovimentacaoFormularioResultado(
      dados: MovimentacaoFormularioDados(
        valor: formatarValor(0),
      ),
      estado: const MovimentacaoFormularioEstado(
        recorrenciaSemDataFim: false,
        quantidadeParcelas: 2,
        tipoRecorrencia: TipoRecorrenciaEnum.mensal,
        intervaloRecorrenciaDias: 30,
        tipoCadastro: TipoCadastroMovimentacaoEnum.unico,
      ),
    );
  }

  MovimentacaoFormularioResultado carregarMovimentacao(MovimentacaoModel model) {
    return MovimentacaoFormularioResultado(
      dados: MovimentacaoFormularioDados(
        titulo: model.titulo,
        valor: formatarValor(model.valor),
        observacao: model.observacao ?? '',
      ),
      estado: MovimentacaoFormularioEstado(
        data: model.data,
        recorrenciaSemDataFim: false,
        categoria: CategoriaEnum.getById(model.codigoCategoria),
        tipoMovimentacao: TipoMovimentacaoEnum.getById(model.tipoMovimentacao),
        status: model.status,
        tipoCadastro: TipoCadastroMovimentacaoEnum.unico,
      ),
    );
  }

  MovimentacaoFormularioResultado? carregarRecorrencia(int id) {
    if (id <= 0) {
      return null;
    }

    final RecorrenciaMovimentacaoEntity? recorrencia = _recorrenciaRepository.buscarPorId(id);
    if (recorrencia == null) {
      return null;
    }

    final bool recorrenciaSemDataFim = recorrencia.dataFim.year < 2000;
    final DateTime dataFim = recorrenciaSemDataFim
        ? DateTime(
            recorrencia.dataInicio.year + 1,
            recorrencia.dataInicio.month,
            recorrencia.dataInicio.day,
          )
        : recorrencia.dataFim;

    return MovimentacaoFormularioResultado(
      dados: MovimentacaoFormularioDados(
        titulo: recorrencia.titulo,
        valor: formatarValor(recorrencia.valorBase),
        observacao: recorrencia.observacao,
        intervaloRecorrencia: recorrencia.intervaloDias > 0
            ? recorrencia.intervaloDias.toString()
            : Strings.INTERVALO_RECORRENCIA_PADRAO,
      ),
      estado: MovimentacaoFormularioEstado(
        data: recorrencia.dataInicio,
        dataFimRecorrencia: dataFim,
        recorrenciaSemDataFim: recorrenciaSemDataFim,
        categoria: CategoriaEnum.getById(recorrencia.codigoCategoria),
        tipoMovimentacao: TipoMovimentacaoEnum.getById(recorrencia.tipoMovimentacao),
        status: recorrencia.statusPadrao,
        tipoCadastro: TipoCadastroMovimentacaoEnum.recorrencia,
        tipoRecorrencia: TipoRecorrenciaEnum.getById(recorrencia.tipoRecorrencia),
        intervaloRecorrenciaDias: recorrencia.intervaloDias > 0 ? recorrencia.intervaloDias : 30,
      ),
    );
  }

  double parseValor(String value) {
    try {
      return Moeda.parse(valor: value, simbolo: Strings.RS).toDouble();
    } catch (_) {
      return 0;
    }
  }

  int parseQuantidadeParcelas(String value) => _parseInteiroPositivo(value);

  int parseIntervaloRecorrencia(String value) => _parseInteiroPositivo(value);

  double calcularValorTotalParcelado({
    required String valor,
    required String parcelas,
  }) {
    final int quantidade = parseQuantidadeParcelas(parcelas);
    if (quantidade <= 0) {
      return 0;
    }
    return parseValor(valor) * quantidade;
  }

  String formatarValor(double valor) {
    return Moeda.format(valor: valor, simbolo: Strings.RS, decimalDigits: 2);
  }

  String? validarTitulo(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return Strings.INFORME_TITULO;
    }
    return null;
  }

  String? validarValor(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return Strings.INFORME_O_VALOR;
    }
    return null;
  }

  String? validarQuantidadeParcelas({
    required String? value,
    required TipoCadastroMovimentacaoEnum tipoCadastro,
  }) {
    if (tipoCadastro != TipoCadastroMovimentacaoEnum.parcelado) {
      return null;
    }
    if (parseQuantidadeParcelas(value ?? '') < 2) {
      return Strings.INFORME_AO_MENOS_DUAS_PARCELAS;
    }
    return null;
  }

  String? validarIntervaloRecorrencia({
    required String? value,
    required TipoCadastroMovimentacaoEnum tipoCadastro,
    required TipoRecorrenciaEnum tipoRecorrencia,
  }) {
    if (tipoCadastro != TipoCadastroMovimentacaoEnum.recorrencia || !tipoRecorrencia.usaIntervaloDias) {
      return null;
    }
    if (parseIntervaloRecorrencia(value ?? '') <= 0) {
      return Strings.INFORME_INTERVALO_VALIDO;
    }
    return null;
  }

  int _parseInteiroPositivo(String value) {
    final int? parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 0;
    }
    return parsed;
  }
}
