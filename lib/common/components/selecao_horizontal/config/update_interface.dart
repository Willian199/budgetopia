typedef EstruturaEvento = (int posicao, List<String> itens);

abstract interface class UpdateInterface {
  Stream<EstruturaEvento> get dados;

  Stream<int> get slidePosition;

  void updatePosition(int posicao);
}
