import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/button/salvar_button.dart';
import 'package:budgetopia/common/components/button/sub_menu_back_button.dart';
import 'package:budgetopia/common/components/fields/info_fields.dart';
import 'package:budgetopia/common/components/generics/app_scaffold.dart';
import 'package:budgetopia/common/components/generics/custom_snackbar.dart';
import 'package:budgetopia/common/components/generics/page_title.dart';
import 'package:budgetopia/common/components/input_formatters/decimal_input_formatter.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_recorrencia_enum.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:budgetopia/ui/movimentacao/enum/tipo_cadastro_movimentacao_enum.dart';
import 'package:budgetopia/ui/movimentacao/mixin/movimentacao_page_mixin.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/data_fim_recorrencia.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/data_movimentacao.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/modo_cadastro_movimentacao.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/selecionar_categoria.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/status_pagamento.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/tipo_movimentacao.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/tipo_recorrencia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovimentacaoPage extends StatefulWidget {
  const MovimentacaoPage({
    this.movimentacaoModel,
    this.codigoRecorrencia,
    super.key,
  });

  final MovimentacaoModel? movimentacaoModel;
  final int? codigoRecorrencia;

  @override
  _MovimentacaoPageState createState() => _MovimentacaoPageState();
}

class _MovimentacaoPageState extends State<MovimentacaoPage>
    with MovimentacaoPageMixin, DDIInject<MovimentacaoController> {
  bool get _isEdicaoRecorrencia => widget.movimentacaoModel == null && (widget.codigoRecorrencia ?? 0) > 0;

  double _parseValor(String value) {
    try {
      return Moeda.parse(valor: value, simbolo: 'R\$').toDouble();
    } catch (_) {
      return 0;
    }
  }

  int _parseParcelas() {
    final int? parcelas = int.tryParse(parcelasController.text);
    if (parcelas == null || parcelas <= 0) {
      return 0;
    }
    return parcelas;
  }

  double _calcularValorTotalParcelado() {
    final int parcelas = _parseParcelas();
    final double valorParcela = _parseValor(valueController.text);
    return parcelas <= 0 ? 0 : valorParcela * parcelas;
  }

  int _parseIntervaloRecorrencia() {
    final int? intervalo = int.tryParse(intervaloRecorrenciaController.text);
    if (intervalo == null || intervalo <= 0) {
      return 0;
    }
    return intervalo;
  }

  void _onValueFocusChanged() {
    if (!valueFocusNode.hasFocus) {
      return;
    }

    valueController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: valueController.text.length,
    );
  }

  void _onParcelasChanged() {
    instance.alterarQuantidadeParcelas(_parseParcelas());
  }

  void _onIntervaloRecorrenciaChanged() {
    instance.alterarIntervaloRecorrenciaDias(_parseIntervaloRecorrencia());
  }

  @override
  void initState() {
    super.initState();

    if (widget.movimentacaoModel != null) {
      _carregarMovimentacao();
    } else if (_isEdicaoRecorrencia) {
      _carregarRecorrencia();
    } else {
      _carregarNovoCadastro();
    }

    valueFocusNode.addListener(_onValueFocusChanged);
    parcelasController.addListener(_onParcelasChanged);
    intervaloRecorrenciaController.addListener(_onIntervaloRecorrenciaChanged);
    titleFocusNode.requestFocus();
  }

  void _carregarNovoCadastro() {
    valueController.text = Moeda.format(valor: 0, simbolo: 'R\$', decimalDigits: 2);
    parcelasController.text = '2';
    intervaloRecorrenciaController.text = '30';
    instance.definirRecorrenciaSemDataFim(false);
    instance.alterarQuantidadeParcelas(2);
    instance.alterarTipoRecorrencia(TipoRecorrenciaEnum.mensal);
    instance.alterarIntervaloRecorrenciaDias(30);
    instance.alterarTipoCadastro(TipoCadastroMovimentacaoEnum.unico);
  }

  void _carregarMovimentacao() {
    final model = widget.movimentacaoModel!;
    titleController.text = model.titulo;
    valueController.text = Moeda.format(
      valor: model.valor,
      simbolo: 'R\$',
      decimalDigits: 2,
    );
    noteController.text = model.observacao ?? '';
    instance.alterarData(model.data);
    instance.definirRecorrenciaSemDataFim(false);
    instance.selecionarCategoria(CategoriaEnum.getById(model.codigoCategoria));
    instance.selecionarTipoMovimentacao(TipoMovimentacaoEnum.getById(model.tipoMovimentacao));
    instance.alterarStatus(model.status);
    instance.alterarTipoCadastro(TipoCadastroMovimentacaoEnum.unico);
  }

  void _carregarRecorrencia() {
    final RecorrenciaMovimentacaoEntity? recorrencia = instance.buscarRecorrenciaPorId(widget.codigoRecorrencia!);
    if (recorrencia == null) {
      _carregarNovoCadastro();
      return;
    }

    titleController.text = recorrencia.titulo;
    valueController.text = Moeda.format(valor: recorrencia.valorBase, simbolo: 'R\$', decimalDigits: 2);
    noteController.text = recorrencia.observacao;
    intervaloRecorrenciaController.text = recorrencia.intervaloDias > 0 ? recorrencia.intervaloDias.toString() : '30';

    instance.alterarData(recorrencia.dataInicio);
    if (recorrencia.dataFim.year < 2000) {
      instance.definirRecorrenciaSemDataFim(true);
      instance.alterarDataFimRecorrencia(
        DateTime(
          recorrencia.dataInicio.year + 1,
          recorrencia.dataInicio.month,
          recorrencia.dataInicio.day,
        ),
      );
    } else {
      instance.definirRecorrenciaSemDataFim(false);
      instance.alterarDataFimRecorrencia(recorrencia.dataFim);
    }
    instance.selecionarCategoria(CategoriaEnum.getById(recorrencia.codigoCategoria));
    instance.selecionarTipoMovimentacao(TipoMovimentacaoEnum.getById(recorrencia.tipoMovimentacao));
    instance.alterarStatus(recorrencia.statusPadrao);
    instance.alterarTipoCadastro(TipoCadastroMovimentacaoEnum.recorrencia);
    instance.alterarTipoRecorrencia(TipoRecorrenciaEnum.getById(recorrencia.tipoRecorrencia));
    instance.alterarIntervaloRecorrenciaDias(recorrencia.intervaloDias > 0 ? recorrencia.intervaloDias : 30);
  }

  @override
  void dispose() {
    valueFocusNode.removeListener(_onValueFocusChanged);
    parcelasController.removeListener(_onParcelasChanged);
    intervaloRecorrenciaController.removeListener(_onIntervaloRecorrenciaChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdaptiveTheme.of(context).theme;

    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;
    final backgroundColor = theme.colorScheme.surface;

    return AppScaffold(
      appBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SubMenuBackButton(),
          const PageTitle(title: Strings.MOVIMENTACAO),
          if (widget.movimentacaoModel != null)
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: errorColor.withAlpha(128),
                ),
                boxShadow: [
                  BoxShadow(
                    color: errorColor.withAlpha(77),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: errorColor.withAlpha(100),
                    blurRadius: 9,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.trashCan,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                onPressed: () {
                  if (instance.remover(widget.movimentacaoModel!.id)) {
                    Navigator.pop(context);
                    CustomSnackBar.sucesso(mensagem: 'Transação removida');
                  } else {
                    CustomSnackBar.informacacao(mensagem: 'Erro ao remover transação');
                  }
                },
              ),
            ),
          SalvarButton(
            height: 40,
            width: 40,
            onPressed: () {
              final double valor = _parseValor(valueController.text);
              final bool isParcelado =
                  !_isEdicaoRecorrencia &&
                  widget.movimentacaoModel == null &&
                  instance.tipoCadastro.value == TipoCadastroMovimentacaoEnum.parcelado;
              final bool isRecorrencia =
                  _isEdicaoRecorrencia ||
                  (widget.movimentacaoModel == null &&
                      instance.tipoCadastro.value == TipoCadastroMovimentacaoEnum.recorrencia);
              final int parcelas = isParcelado ? _parseParcelas() : 1;

              if ((formKey.currentState?.validate() ?? false) && valor > 0 && parcelas > 0) {
                context.closeKeyboard();

                final bool status = instance.salvar(
                  id: widget.movimentacaoModel?.id ?? 0,
                  titulo: titleController.text.trim(),
                  valor: valor,
                  observacao: noteController.text.trim(),
                  parcelas: parcelas,
                  codigoRecorrencia: widget.movimentacaoModel?.codigoRecorrencia ?? 0,
                  recorrenciaId: _isEdicaoRecorrencia ? widget.codigoRecorrencia! : 0,
                );

                if (!status) {
                  return;
                }

                Navigator.pop(context);

                if (isParcelado) {
                  CustomSnackBar.sucesso(mensagem: '$parcelas transações parceladas salvas!');
                } else if (isRecorrencia) {
                  CustomSnackBar.sucesso(
                    mensagem: _isEdicaoRecorrencia
                        ? 'Recorrência atualizada com sucesso!'
                        : 'Recorrência cadastrada com sucesso!',
                  );
                } else {
                  CustomSnackBar.sucesso(mensagem: 'Transação salva!');
                }
              } else {
                CustomSnackBar.informacacao(mensagem: 'Verifique os dados informados!');
              }
            },
          ),
        ],
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: InfoFields(
                label: Strings.TITULO,
                icon: FontAwesomeIcons.noteSticky,
                controller: titleController,
                focusNode: titleFocusNode,
                nextFocus: categoriaFocusNode,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
                primaryColor: primaryColor,
                backgroundColor: backgroundColor,
              ),
            ),
            const SizedBox(height: 15.0),
            SelecionarCategoria(
              focusNode: categoriaFocusNode,
              nextFocusNode: tipoMovimentacaoFocusNode,
            ),
            const SizedBox(height: 15.0),
            TipoMovimentacao(
              focusNode: tipoMovimentacaoFocusNode,
              nextFocusNode: dateFocusNode,
            ),
            const SizedBox(height: 15.0),
            if (widget.movimentacaoModel == null && !_isEdicaoRecorrencia) ...[
              const ModoCadastroMovimentacao(),
              const SizedBox(height: 15.0),
            ],
            ValueListenableBuilder<TipoCadastroMovimentacaoEnum>(
              valueListenable: instance.tipoCadastro,
              builder: (context, tipoCadastro, child) {
                final bool exibirCamposRecorrencia =
                    _isEdicaoRecorrencia || tipoCadastro == TipoCadastroMovimentacaoEnum.recorrencia;

                if (!exibirCamposRecorrencia || widget.movimentacaoModel != null) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    ValueListenableBuilder<TipoRecorrenciaEnum>(
                      valueListenable: instance.tipoRecorrencia,
                      builder: (context, tipoRecorrencia, child) {
                        return TipoRecorrencia(
                          focusNode: tipoRecorrenciaFocusNode,
                          nextFocusNode: tipoRecorrencia.usaIntervaloDias
                              ? intervaloRecorrenciaFocusNode
                              : dateFocusNode,
                        );
                      },
                    ),
                    ValueListenableBuilder<TipoRecorrenciaEnum>(
                      valueListenable: instance.tipoRecorrencia,
                      builder: (context, tipoRecorrencia, child) {
                        if (!tipoRecorrencia.usaIntervaloDias) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            const SizedBox(height: 15.0),
                            InfoFields(
                              label: 'Intervalo em dias',
                              icon: FontAwesomeIcons.clockRotateLeft,
                              controller: intervaloRecorrenciaController,
                              focusNode: intervaloRecorrenciaFocusNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              nextFocus: dateFocusNode,
                              validator: (value) {
                                if (instance.tipoCadastro.value != TipoCadastroMovimentacaoEnum.recorrencia ||
                                    !instance.tipoRecorrencia.value.usaIntervaloDias) {
                                  return null;
                                }
                                final int? intervalo = int.tryParse(value ?? '');
                                if (intervalo == null || intervalo <= 0) {
                                  return 'Informe um intervalo válido';
                                }
                                return null;
                              },
                              primaryColor: primaryColor,
                              backgroundColor: backgroundColor,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 15.0),
                  ],
                );
              },
            ),
            ValueListenableBuilder<TipoCadastroMovimentacaoEnum>(
              valueListenable: instance.tipoCadastro,
              builder: (context, tipoCadastro, child) {
                final bool exibirDataFimRecorrencia =
                    widget.movimentacaoModel == null &&
                    (_isEdicaoRecorrencia || tipoCadastro == TipoCadastroMovimentacaoEnum.recorrencia);

                return Column(
                  children: [
                    DataMovimentacao(
                      focusNode: dateFocusNode,
                      nextFocus: exibirDataFimRecorrencia ? dataFimRecorrenciaFocusNode : valueFocusNode,
                    ),
                    if (exibirDataFimRecorrencia) ...[
                      const SizedBox(height: 15.0),
                      DataFimRecorrencia(
                        focusNode: dataFimRecorrenciaFocusNode,
                        nextFocus: valueFocusNode,
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 15.0),
            ValueListenableBuilder<TipoCadastroMovimentacaoEnum>(
              valueListenable: instance.tipoCadastro,
              builder: (context, tipoCadastro, child) {
                final bool isParcelado =
                    !_isEdicaoRecorrencia &&
                    widget.movimentacaoModel == null &&
                    tipoCadastro == TipoCadastroMovimentacaoEnum.parcelado;
                return InfoFields(
                  label: Strings.VALOR,
                  icon: FontAwesomeIcons.moneyBill1Wave,
                  controller: valueController,
                  focusNode: valueFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    DecimalInputFormatter(allowNegative: false),
                  ],
                  nextFocus: isParcelado ? parcelasFocusNode : noteFocusNode,
                  onTap: () {
                    if (valueFocusNode.hasPrimaryFocus) {
                      return;
                    }

                    valueController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: valueController.value.text.length,
                    );
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return Strings.INFORME_VALOR;
                    }
                    return null;
                  },
                  primaryColor: primaryColor,
                  backgroundColor: backgroundColor,
                );
              },
            ),
            ValueListenableBuilder<TipoCadastroMovimentacaoEnum>(
              valueListenable: instance.tipoCadastro,
              builder: (context, value, child) {
                if (widget.movimentacaoModel != null ||
                    _isEdicaoRecorrencia ||
                    value != TipoCadastroMovimentacaoEnum.parcelado) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    const SizedBox(height: 15.0),
                    InfoFields(
                      label: 'Quantidade de Parcelas',
                      icon: FontAwesomeIcons.listOl,
                      controller: parcelasController,
                      focusNode: parcelasFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      nextFocus: noteFocusNode,
                      onEditingComplete: noteFocusNode.requestFocus,
                      validator: (value) {
                        if (instance.tipoCadastro.value != TipoCadastroMovimentacaoEnum.parcelado) {
                          return null;
                        }
                        final int? parcelas = int.tryParse(value ?? '');
                        if (parcelas == null || parcelas < 2) {
                          return 'Informe ao menos 2 parcelas';
                        }
                        return null;
                      },
                      primaryColor: primaryColor,
                      backgroundColor: backgroundColor,
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: AnimatedBuilder(
                        animation: Listenable.merge([valueController, parcelasController]),
                        builder: (context, child) {
                          final String valorTotal = Moeda.format(
                            valor: _calcularValorTotalParcelado(),
                            simbolo: 'R\$',
                            decimalDigits: 2,
                          );
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Valor total: $valorTotal',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const StatusPagamento(),
            InfoFields(
              label: Strings.OBSERVACOES,
              icon: FontAwesomeIcons.info,
              controller: noteController,
              focusNode: noteFocusNode,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                return null;
              },
              primaryColor: primaryColor,
              backgroundColor: backgroundColor,
              maxLines: 4,
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
