import 'dart:async';

import 'package:budgetopia/common/components/user_imagem/controller/user_image_controller.dart';
import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/config/banco/repository/perfil/perfil_repository.dart';
import 'package:budgetopia/pages/perfil/controller/data_nascimento_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class SalvarPerfilController with PostConstruct {
  SalvarPerfilController()
      : _dataNascimentoController = ddi(),
        _userImageController = ddi(),
        _perfilRepository = ddi();

  PerfilEntity? _registroSalvo;
  PerfilEntity? get registroSalvo => _registroSalvo;

  final DataNascimentoController _dataNascimentoController;
  final UserImageController _userImageController;
  final PerfilRepository _perfilRepository;

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
