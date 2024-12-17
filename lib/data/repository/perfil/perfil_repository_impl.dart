import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/data/repository/perfil/perfil_repository.dart';
import 'package:budgetopia/data/service/perfil/perfil_service.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class PerfilRepositoryImpl implements PerfilRepository {
  late final PerfilService _perfilService = ddi();

  @override
  bool remover(int id) => _perfilService.remover(id);

  @override
  int salvar(PerfilEntity perfilEntity) => _perfilService.salvar(perfilEntity);

  @override
  PerfilEntity? get getFirst => _perfilService.getFirst;

  @override
  Stream<PerfilEntity?> get watchFirst => _perfilService.watchFirst;
}
