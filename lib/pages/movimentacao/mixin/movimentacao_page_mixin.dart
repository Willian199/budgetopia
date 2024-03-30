import 'package:budgetopia/pages/movimentacao/view/movimentacao_page.dart';
import 'package:flutter/material.dart';

mixin MovimentacaoPageMixin on State<MovimentacaoPage> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final valueController = TextEditingController();
  final noteController = TextEditingController();

  final titleFocusNode = FocusNode();
  final categoryFocusNode = FocusNode();
  final transactionTypeFocusNode = FocusNode();
  final dateFocusNode = FocusNode();
  final valueFocusNode = FocusNode();
  final noteFocusNode = FocusNode();

  @override
  void dispose() {
    titleController.dispose();
    valueController.dispose();
    noteController.dispose();
    titleFocusNode.dispose();
    categoryFocusNode.dispose();
    transactionTypeFocusNode.dispose();
    dateFocusNode.dispose();
    valueFocusNode.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }
}
