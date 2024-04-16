import 'package:budgetopia/pages/perfil/view/perfil_page.dart';
import 'package:flutter/material.dart';

mixin PerfilPageMixin on State<PerfilPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController valorObjetivoController = TextEditingController();

  final nomeFocusNode = FocusNode();
  final valorObjetivoFocusNode = FocusNode();
  final dataNascimentoFocusNode = FocusNode();

  @override
  void dispose() {
    nomeController.dispose();
    nomeFocusNode.dispose();
    dataNascimentoFocusNode.dispose();
    valorObjetivoController.dispose();
    valorObjetivoFocusNode.dispose();
    super.dispose();
  }
}
