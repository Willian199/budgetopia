import 'dart:async';

import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_recorrencia_enum.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/movimentacao/enum/tipo_cadastro_movimentacao_enum.dart';
import 'package:budgetopia/common/dto/movimentacao_formulario_dados.dart';
import 'package:budgetopia/common/dto/movimentacao_formulario_estado.dart';
import 'package:budgetopia/common/dto/movimentacao_formulario_resultado.dart';
import 'package:budgetopia/common/dto/movimentacao_salvar_resultado.dart';
import 'package:budgetopia/common/dto/salvar_movimentacao_request.dart';
import 'package:budgetopia/ui/movimentacao/usecase/movimentacao_formulario_usecase.dart';
import 'package:budgetopia/ui/movimentacao/usecase/remover_movimentacao_usecase.dart';
import 'package:budgetopia/ui/movimentacao/usecase/salvar_movimentacao_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class MovimentacaoController with PreDestroy {
  MovimentacaoController()
    : data = ValueNotifier(DateTime.now()),
      dataFimRecorrencia = ValueNotifier(DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day)),
      categoria = ValueNotifier(CategoriaEnum.Alimentacao),
      tipoMovimentacao = ValueNotifier(TipoMovimentacaoEnum.entrada),
      status = ValueNotifier(false),
      tipoCadastro = ValueNotifier(TipoCadastroMovimentacaoEnum.unico),
      quantidadeParcelas = ValueNotifier(2),
      tipoRecorrencia = ValueNotifier(TipoRecorrenciaEnum.mensal),
      intervaloRecorrenciaDias = ValueNotifier(30);

  final ValueNotifier<DateTime> data;
  final ValueNotifier<DateTime> dataFimRecorrencia;
  final ValueNotifier<CategoriaEnum> categoria;
  final ValueNotifier<TipoMovimentacaoEnum> tipoMovimentacao;
  final ValueNotifier<bool> status;
  final ValueNotifier<TipoCadastroMovimentacaoEnum> tipoCadastro;
  final ValueNotifier<int> quantidadeParcelas;
  final ValueNotifier<TipoRecorrenciaEnum> tipoRecorrencia;
  final ValueNotifier<int> intervaloRecorrenciaDias;

  late final MovimentacaoFormularioUseCase _formularioUseCase = ddi();
  late final SalvarMovimentacaoUseCase _salvarMovimentacaoUseCase = ddi();
  late final RemoverMovimentacaoUseCase _removerMovimentacaoUseCase = ddi();
  bool _recorrenciaSemDataFim = false;

  bool get recorrenciaSemDataFim => _recorrenciaSemDataFim;

  MovimentacaoFormularioDados carregarNovoCadastro() {
    final MovimentacaoFormularioResultado resultado = _formularioUseCase.novoCadastro();
    _aplicarEstadoFormulario(resultado.estado);
    return resultado.dados;
  }

  MovimentacaoFormularioDados carregarMovimentacao(MovimentacaoModel model) {
    final MovimentacaoFormularioResultado resultado = _formularioUseCase.carregarMovimentacao(model);
    _aplicarEstadoFormulario(resultado.estado);
    return resultado.dados;
  }

  MovimentacaoFormularioDados? carregarRecorrencia(int id) {
    final MovimentacaoFormularioResultado? resultado = _formularioUseCase.carregarRecorrencia(id);
    if (resultado == null) {
      return null;
    }
    _aplicarEstadoFormulario(resultado.estado);
    return resultado.dados;
  }

  void alterarData(DateTime value) {
    data.value = value;
    if (dataFimRecorrencia.value.isBefore(value)) {
      dataFimRecorrencia.value = value;
    }
  }

  void alterarDataFimRecorrencia(DateTime value) {
    dataFimRecorrencia.value = value.isBefore(data.value) ? data.value : value;
  }

  void definirRecorrenciaSemDataFim(bool value) {
    _recorrenciaSemDataFim = value;
  }

  void selecionarCategoria(CategoriaEnum? value) {
    if (value != null) {
      categoria.value = value;
    }
  }

  void selecionarTipoMovimentacao(TipoMovimentacaoEnum? value) {
    if (value != null) {
      tipoMovimentacao.value = value;
    }
  }

  void alterarStatus(bool value) {
    status.value = value;
  }

  void alterarTipoCadastro(TipoCadastroMovimentacaoEnum value) {
    tipoCadastro.value = value;
    if (value != TipoCadastroMovimentacaoEnum.recorrencia) {
      _recorrenciaSemDataFim = false;
    }
  }

  void alterarQuantidadeParcelas(int value) {
    quantidadeParcelas.value = value <= 0 ? 1 : value;
  }

  void alterarTipoRecorrencia(TipoRecorrenciaEnum? value) {
    if (value != null) {
      tipoRecorrencia.value = value;
    }
  }

  void alterarIntervaloRecorrenciaDias(int value) {
    intervaloRecorrenciaDias.value = value <= 0 ? 1 : value;
  }

  int parseQuantidadeParcelas(String value) => _formularioUseCase.parseQuantidadeParcelas(value);

  int parseIntervaloRecorrencia(String value) => _formularioUseCase.parseIntervaloRecorrencia(value);

  double calcularValorTotalParcelado({
    required String valor,
    required String parcelas,
  }) {
    return _formularioUseCase.calcularValorTotalParcelado(valor: valor, parcelas: parcelas);
  }

  String formatarValor(double valor) => _formularioUseCase.formatarValor(valor);

  String? validarTitulo(String? value) => _formularioUseCase.validarTitulo(value);

  String? validarValor(String? value) => _formularioUseCase.validarValor(value);

  String? validarQuantidadeParcelas(String? value) {
    return _formularioUseCase.validarQuantidadeParcelas(
      value: value,
      tipoCadastro: tipoCadastro.value,
    );
  }

  String? validarIntervaloRecorrencia(String? value) {
    return _formularioUseCase.validarIntervaloRecorrencia(
      value: value,
      tipoCadastro: tipoCadastro.value,
      tipoRecorrencia: tipoRecorrencia.value,
    );
  }

  MovimentacaoSalvarResultado salvarFormulario({
    required bool formValido,
    required bool isEdicaoRecorrencia,
    required bool possuiMovimentacao,
    required int id,
    required String titulo,
    required String valor,
    required String observacao,
    required String parcelas,
    required int codigoRecorrencia,
    required int recorrenciaId,
  }) {
    return _salvarMovimentacaoUseCase.executar(
      SalvarMovimentacaoRequest(
        formValido: formValido,
        isEdicaoRecorrencia: isEdicaoRecorrencia,
        possuiMovimentacao: possuiMovimentacao,
        id: id,
        titulo: titulo,
        valor: valor,
        observacao: observacao,
        parcelas: parcelas,
        codigoRecorrencia: codigoRecorrencia,
        recorrenciaId: recorrenciaId,
        data: data.value,
        dataFimRecorrencia: dataFimRecorrencia.value,
        categoria: categoria.value,
        tipoMovimentacao: tipoMovimentacao.value,
        status: status.value,
        tipoCadastro: tipoCadastro.value,
        tipoRecorrencia: tipoRecorrencia.value,
        intervaloRecorrenciaDias: intervaloRecorrenciaDias.value,
        recorrenciaSemDataFim: _recorrenciaSemDataFim,
      ),
    );
  }

  bool remover(int id) => _removerMovimentacaoUseCase.executar(id);

  void _aplicarEstadoFormulario(MovimentacaoFormularioEstado estado) {
    if (estado.data != null) {
      alterarData(estado.data!);
    }
    if (estado.dataFimRecorrencia != null) {
      alterarDataFimRecorrencia(estado.dataFimRecorrencia!);
    }
    if (estado.recorrenciaSemDataFim != null) {
      definirRecorrenciaSemDataFim(estado.recorrenciaSemDataFim!);
    }
    if (estado.categoria != null) {
      selecionarCategoria(estado.categoria);
    }
    if (estado.tipoMovimentacao != null) {
      selecionarTipoMovimentacao(estado.tipoMovimentacao);
    }
    if (estado.status != null) {
      alterarStatus(estado.status!);
    }
    if (estado.tipoCadastro != null) {
      alterarTipoCadastro(estado.tipoCadastro!);
    }
    if (estado.quantidadeParcelas != null) {
      alterarQuantidadeParcelas(estado.quantidadeParcelas!);
    }
    if (estado.tipoRecorrencia != null) {
      alterarTipoRecorrencia(estado.tipoRecorrencia);
    }
    if (estado.intervaloRecorrenciaDias != null) {
      alterarIntervaloRecorrenciaDias(estado.intervaloRecorrenciaDias!);
    }
  }

  void dispose() {
    data.dispose();
    dataFimRecorrencia.dispose();
    categoria.dispose();
    tipoMovimentacao.dispose();
    status.dispose();
    tipoCadastro.dispose();
    quantidadeParcelas.dispose();
    tipoRecorrencia.dispose();
    intervaloRecorrenciaDias.dispose();
  }

  @override
  FutureOr<void> onPreDestroy() {
    dispose();
  }
}
