import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class CategoriaController with DDIEventSender<CategoriaEnum> {
  List<CategoriaEnum> get listarCategorias => CategoriaEnum.values;

  CategoriaEnum get categoriaSelecionada => super.state ?? CategoriaEnum.Alimentacao;

  void selecionarCategoria(CategoriaEnum? valor) {
    if (valor == null) {
      return;
    }
    fire(valor);
  }
}
