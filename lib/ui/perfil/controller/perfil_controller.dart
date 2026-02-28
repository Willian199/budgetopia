import 'dart:async';

import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/data/repository/perfil/perfil_repository.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// Controller do módulo de perfil (MVC).
/// Concentra a lógica de carregar e salvar perfil; não depende de outros controllers.
final class PerfilController with PostConstruct {
  PerfilEntity? _registroSalvo;
  late final PerfilRepository _perfilRepository = ddi();

  @override
  FutureOr<void> onPostConstruct() {
    _registroSalvo = _perfilRepository.getFirst;
  }

  /// Perfil já salvo (carregado ao abrir a tela). Null se ainda não existir registro.
  PerfilEntity? get registroSalvo => _registroSalvo;

  /// Persiste os dados do perfil.
  /// [dataNascimento] e [pathImagem] vêm da View (outros controllers/widgets), para não criar dependência entre controllers.
  bool salvar({
    required String nome,
    required double valorObjetivo,
    required DateTime dataNascimento,
    String? pathImagem,
  }) {
    final obj = PerfilEntity(
      id: _registroSalvo?.id ?? 0,
      nome: nome,
      dataNascimento: dataNascimento,
      valor: valorObjetivo,
      pathImagem: pathImagem,
    );
    final id = _perfilRepository.salvar(obj);
    if (id > 0) {
      _registroSalvo = _perfilRepository.getFirst;
      return true;
    }
    return false;
  }
}
