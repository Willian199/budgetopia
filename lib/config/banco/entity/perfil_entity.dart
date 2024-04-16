import 'package:objectbox/objectbox.dart';

@Entity()
class PerfilEntity {
  PerfilEntity({
    required this.id,
    required this.nome,
    required this.dataNascimento,
    required this.valor,
    this.pathImagem,
  });

  @Id()
  int id;

  String nome;
  double valor;
  String? pathImagem;

  @Property(type: PropertyType.date)
  DateTime dataNascimento;
}
