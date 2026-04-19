import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoModule with DDIModule {
  @override
  void onPostConstruct() {
    application(MovimentacaoController.new);
  }
}
