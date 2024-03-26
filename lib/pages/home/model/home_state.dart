import 'package:budgetopia/common/enum/tipo_registro_enum.dart';

class HomeState {
  HomeState({required this.tabSelecionada});

  final Set<TipoRegistroEnum> tabSelecionada;
}
