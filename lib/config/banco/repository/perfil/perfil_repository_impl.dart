import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/config/banco/generated/objectbox.g.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:budgetopia/config/banco/repository/perfil/perfil_repository.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class PerfilRepositoryImpl implements PerfilRepository {
  PerfilRepositoryImpl() : _entity = ddi<Database>().box<PerfilEntity>();

  final Box<PerfilEntity> _entity;

  @override
  bool remover(int id) => _entity.remove(id);

  @override
  int salvar(PerfilEntity perfilEntity) => _entity.put(perfilEntity);

  @override
  PerfilEntity? get getFirst => _entity.get(1);

  @override
  Stream<PerfilEntity?> get watchFirst => _entity.query(PerfilEntity_.id.equals(1)).watch(triggerImmediately: true).map((query) => query.findFirst());
}
