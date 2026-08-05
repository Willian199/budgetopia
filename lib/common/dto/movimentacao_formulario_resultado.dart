import 'package:budgetopia/common/dto/movimentacao_formulario_dados.dart';
import 'package:budgetopia/common/dto/movimentacao_formulario_estado.dart';

final class MovimentacaoFormularioResultado {
  const MovimentacaoFormularioResultado({
    required this.dados,
    required this.estado,
  });

  final MovimentacaoFormularioDados dados;
  final MovimentacaoFormularioEstado estado;
}
