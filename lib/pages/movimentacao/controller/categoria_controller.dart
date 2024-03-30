import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class CategoriaController with DDIEventSender<CategoriaEnum> {
  late CategoriaEnum _categoriaSelecionada = CategoriaEnum.Alimentacao;

  CategoriaEnum get categoriaSelecionada => _categoriaSelecionada;
  List<CategoriaEnum> get listarCategorias => CategoriaEnum.values;

  void selecionarCategoria(CategoriaEnum? valor) {
    if (valor == null) {
      return;
    }
    _categoriaSelecionada = valor;
    fire(_categoriaSelecionada);
  }
}
