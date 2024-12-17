typedef SelecaoHorizontalDados = (int posicao, List<String> itens);

abstract interface class UpdateInterface {
  void update(int posicao, List<String> itens);

  Stream<SelecaoHorizontalDados> get dados;
}
