import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/ui/movimentacao/case/movimentacao_case.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class CategoriaController extends ValueNotifier<CategoriaEnum> {
  CategoriaController() : super(CategoriaEnum.Alimentacao);

  late final MovimentacaoCase _movimentacaoCase = ddi();

  void selecionarCategoria(CategoriaEnum? valor) {
    if (valor == null) {
      return;
    }
    _movimentacaoCase.categoriaSelecionada = valor;
    value = valor;
  }
}
