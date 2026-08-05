import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:budgetopia/ui/movimentacao/usecase/movimentacao_formulario_usecase.dart';
import 'package:budgetopia/ui/movimentacao/usecase/remover_movimentacao_usecase.dart';
import 'package:budgetopia/ui/movimentacao/usecase/salvar_movimentacao_usecase.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoModule with DDIModule {
  @override
  void onPostConstruct() {
    application(MovimentacaoFormularioUseCase.new);
    application(SalvarMovimentacaoUseCase.new);
    application(RemoverMovimentacaoUseCase.new);
    application(MovimentacaoController.new);
  }
}
