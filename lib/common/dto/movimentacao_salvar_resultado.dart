final class MovimentacaoSalvarResultado {
  const MovimentacaoSalvarResultado._({
    required this.sucesso,
    required this.mensagem,
  });

  const MovimentacaoSalvarResultado.sucesso(String mensagem)
    : this._(
        sucesso: true,
        mensagem: mensagem,
      );

  const MovimentacaoSalvarResultado.erro(String mensagem)
    : this._(
        sucesso: false,
        mensagem: mensagem,
      );

  final bool sucesso;
  final String mensagem;
}
