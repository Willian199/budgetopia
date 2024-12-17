import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/config/banco/generated/objectbox.g.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:budgetopia/data/service/perfil/perfil_service.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class PerfilServiceImpl implements PerfilService {
  PerfilServiceImpl();

  late final Box<PerfilEntity> _entity = ddi.get<Database>().box<PerfilEntity>();

  @override
  bool remover(int id) => _entity.remove(id);

  @override
  int salvar(PerfilEntity perfilEntity) => _entity.put(perfilEntity);

  @override
  PerfilEntity? get getFirst => _entity.get(1);

  @override
  Stream<PerfilEntity?> get watchFirst => _entity.query(PerfilEntity_.id.equals(1)).watch(triggerImmediately: true).map((query) => query.findFirst());
}
