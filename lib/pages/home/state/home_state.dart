// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';

class HomeState {
  HomeState({required this.tabSelecionada, required this.valorEntrada, required this.valorSaida, required this.valorSaldo});

  final Set<TipoRegistroEnum> tabSelecionada;

  final double valorEntrada;
  final double valorSaida;
  final double valorSaldo;

  HomeState copyWith({
    Set<TipoRegistroEnum>? tabSelecionada,
    double? valorEntrada,
    double? valorSaida,
    double? valorSaldo,
  }) {
    return HomeState(
      tabSelecionada: tabSelecionada ?? this.tabSelecionada,
      valorEntrada: valorEntrada ?? this.valorEntrada,
      valorSaida: valorSaida ?? this.valorSaida,
      valorSaldo: valorSaldo ?? this.valorSaldo,
    );
  }
}
