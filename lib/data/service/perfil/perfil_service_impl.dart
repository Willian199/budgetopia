import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/data/repository/perfil/perfil_repository.dart';
import 'package:budgetopia/data/service/perfil/perfil_service.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class PerfilServiceImpl implements PerfilService {
  late final PerfilRepository _perfilRepository = ddi();

  @override
  bool remover(int id) => _perfilRepository.remover(id);

  @override
  int salvar(PerfilEntity perfilEntity) => _perfilRepository.salvar(perfilEntity);

  @override
  PerfilEntity? get getFirst => _perfilRepository.getFirst;

  @override
  Stream<PerfilEntity?> get watchFirst => _perfilRepository.watchFirst;
}
