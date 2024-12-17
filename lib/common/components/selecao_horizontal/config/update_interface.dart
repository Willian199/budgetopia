abstract interface class UpdateInterface {
  Stream<List<String>> get dados;

  Stream<int> get slidePosition;

  void updatePosition(int posicao);
}
