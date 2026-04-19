import 'package:budgetopia/common/components/generics/app_scaffold.dart';
import 'package:budgetopia/common/components/generics/custom_snackbar.dart';
import 'package:budgetopia/common/dto/movimentacao_formulario_dados.dart';
import 'package:budgetopia/common/dto/movimentacao_salvar_resultado.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:budgetopia/ui/movimentacao/mixin/movimentacao_page_mixin.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/movimentacao_app_bar.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/movimentacao_formulario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoPage extends StatefulWidget {
  const MovimentacaoPage({
    this.movimentacaoModel,
    this.codigoRecorrencia,
    super.key,
  });

  final MovimentacaoModel? movimentacaoModel;
  final int? codigoRecorrencia;

  @override
  State<MovimentacaoPage> createState() => _MovimentacaoPageState();
}

class _MovimentacaoPageState extends State<MovimentacaoPage>
    with MovimentacaoPageMixin, DDIInject<MovimentacaoController> {
  bool get _isEdicaoRecorrencia => widget.movimentacaoModel == null && (widget.codigoRecorrencia ?? 0) > 0;

  @override
  void initState() {
    super.initState();
    _carregarFormulario();

    valueFocusNode.addListener(_onValueFocusChanged);
    parcelasController.addListener(_onParcelasChanged);
    intervaloRecorrenciaController.addListener(_onIntervaloRecorrenciaChanged);
    titleFocusNode.requestFocus();
  }

  void _carregarFormulario() {
    if (widget.movimentacaoModel != null) {
      _preencherFormulario(instance.carregarMovimentacao(widget.movimentacaoModel!));
      return;
    }

    if (_isEdicaoRecorrencia) {
      _carregarRecorrencia();
      return;
    }

    _preencherFormulario(instance.carregarNovoCadastro());
  }

  void _carregarRecorrencia() {
    final MovimentacaoFormularioDados? dados = instance.carregarRecorrencia(widget.codigoRecorrencia!);
    _preencherFormulario(dados ?? instance.carregarNovoCadastro());
  }

  void _preencherFormulario(MovimentacaoFormularioDados dados) {
    titleController.text = dados.titulo;
    valueController.text = dados.valor;
    noteController.text = dados.observacao;
    parcelasController.text = dados.parcelas;
    intervaloRecorrenciaController.text = dados.intervaloRecorrencia;
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
    instance.alterarQuantidadeParcelas(instance.parseQuantidadeParcelas(parcelasController.text));
  }

  void _onIntervaloRecorrenciaChanged() {
    instance.alterarIntervaloRecorrenciaDias(instance.parseIntervaloRecorrencia(intervaloRecorrenciaController.text));
  }

  void _salvar() {
    final MovimentacaoSalvarResultado resultado = instance.salvarFormulario(
      formValido: formKey.currentState?.validate() ?? false,
      isEdicaoRecorrencia: _isEdicaoRecorrencia,
      possuiMovimentacao: widget.movimentacaoModel != null,
      id: widget.movimentacaoModel?.id ?? 0,
      titulo: titleController.text,
      valor: valueController.text,
      observacao: noteController.text,
      parcelas: parcelasController.text,
      codigoRecorrencia: widget.movimentacaoModel?.codigoRecorrencia ?? 0,
      recorrenciaId: _isEdicaoRecorrencia ? widget.codigoRecorrencia! : 0,
    );

    if (!resultado.sucesso) {
      CustomSnackBar.informacacao(mensagem: resultado.mensagem);
      return;
    }

    context.closeKeyboard();
    Navigator.pop(context);
    CustomSnackBar.sucesso(mensagem: resultado.mensagem);
  }

  void _remover() {
    if (instance.remover(widget.movimentacaoModel!.id)) {
      Navigator.pop(context);
      CustomSnackBar.sucesso(mensagem: 'Transação removida');
      return;
    }

    CustomSnackBar.informacacao(mensagem: 'Erro ao remover transação');
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
    return AppScaffold(
      appBar: MovimentacaoAppBar(
        exibirRemover: widget.movimentacaoModel != null,
        onSalvar: _salvar,
        onRemover: _remover,
      ),
      body: MovimentacaoFormulario(
        formKey: formKey,
        isEdicaoRecorrencia: _isEdicaoRecorrencia,
        possuiMovimentacao: widget.movimentacaoModel != null,
        titleController: titleController,
        valueController: valueController,
        noteController: noteController,
        parcelasController: parcelasController,
        intervaloRecorrenciaController: intervaloRecorrenciaController,
        titleFocusNode: titleFocusNode,
        categoriaFocusNode: categoriaFocusNode,
        tipoMovimentacaoFocusNode: tipoMovimentacaoFocusNode,
        tipoRecorrenciaFocusNode: tipoRecorrenciaFocusNode,
        dateFocusNode: dateFocusNode,
        dataFimRecorrenciaFocusNode: dataFimRecorrenciaFocusNode,
        valueFocusNode: valueFocusNode,
        parcelasFocusNode: parcelasFocusNode,
        intervaloRecorrenciaFocusNode: intervaloRecorrenciaFocusNode,
        noteFocusNode: noteFocusNode,
      ),
    );
  }
}
