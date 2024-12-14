import 'package:budgetopia/config/banco/entity/perfil_entity.dart';

abstract interface class PerfilRepository {
  int salvar(PerfilEntity perfilEntity);

  bool remover(int id);

  PerfilEntity? get getFirst;

  Stream<PerfilEntity?> get watchFirst;
}
