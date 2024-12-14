import 'dart:async';

import 'package:budgetopia/common/components/user_imagem/controller/user_image_controller.dart';
import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/data/repository/perfil/perfil_repository.dart';
import 'package:budgetopia/ui/perfil/controller/data_nascimento_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class PerfilController with PostConstruct {
  PerfilController();

  PerfilEntity? _registroSalvo;
  PerfilEntity? get registroSalvo => _registroSalvo;

  late final DataNascimentoController _dataNascimentoController = ddi();
  late final UserImageController _userImageController = ddi();
  late final PerfilRepository _perfilRepository = ddi();

  @override
  FutureOr<void> onPostConstruct() {
    _registroSalvo = _perfilRepository.getFirst;
  }

  bool salvar({required String nome, required double valorObjetivo, int? id}) {
    final PerfilEntity obj = PerfilEntity(
      id: _registroSalvo?.id ?? 0,
      nome: nome,
      dataNascimento: _dataNascimentoController.dataNascimento,
      valor: valorObjetivo,
      pathImagem: _userImageController.pathImagem,
    );
    return _perfilRepository.salvar(obj) > 0;
  }
}
