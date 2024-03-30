import 'package:objectbox/objectbox.dart';

@Entity()
class UserPreferencesEntity {
  UserPreferencesEntity({required this.id, required this.descricao, required this.valor, required this.dataAlteracao});

  @Id()
  int id;
  String descricao;
  String valor;
  @Property(type: PropertyType.date) // Store as int in milliseconds
  DateTime dataAlteracao;
}
