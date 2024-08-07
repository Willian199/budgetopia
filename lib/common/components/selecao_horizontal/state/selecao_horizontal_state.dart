// ignore_for_file: public_member_api_docs, sort_constructors_first
class SelecaoHorizontalState {
  SelecaoHorizontalState({required this.itens, this.posicao = 0});

  final List<String> itens;

  final int posicao;

  SelecaoHorizontalState copyWith({
    List<String>? itens,
    int? posicao,
  }) {
    return SelecaoHorizontalState(
      itens: itens ?? this.itens,
      posicao: posicao ?? this.posicao,
    );
  }
}
