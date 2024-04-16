import 'dart:async';

import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:budgetopia/pages/perfil/controller/data_nascimento_controller.dart';
import 'package:budgetopia/pages/perfil/controller/user_image_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:objectbox/objectbox.dart';

class SalvarPerfilController with PostConstruct {
  SalvarPerfilController()
      : _dataNascimentoController = ddi(),
        _userImageController = ddi(),
        _entity = ddi<Database>().box<PerfilEntity>();

  PerfilEntity? _registroSalvo;
  PerfilEntity? get registroSalvo => _registroSalvo;

  final DataNascimentoController _dataNascimentoController;
  final UserImageController _userImageController;
  final Box<PerfilEntity> _entity;

  bool salvar({required String nome, required double valorObjetivo, int? id}) {
    final PerfilEntity obj = PerfilEntity(
      id: _registroSalvo?.id ?? 0,
      nome: nome,
      dataNascimento: _dataNascimentoController.dataNascimento,
      valor: valorObjetivo,
      pathImagem: _userImageController.pathImagem,
    );
    _entity.put(obj);
    return true;
  }

  @override
  FutureOr<void> onPostConstruct() {
    _registroSalvo = _entity.get(1);
  }
}
