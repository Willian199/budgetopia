import 'package:budgetopia/common/enum/tipo_registro_enum.dart';

class HomeState {
  HomeState(this.tabSelecionada);

  final Set<TipoRegistroEnum> tabSelecionada;
}
