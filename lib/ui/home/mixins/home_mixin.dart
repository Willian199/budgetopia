import 'package:budgetopia/ui/home/view/home_page.dart';
import 'package:flutter/material.dart';

mixin HomeMixin on State<HomePage> {
  final TextEditingController _pesquisaController = TextEditingController();
  final FocusNode _pesquisaFocus = FocusNode();

  int notificationCount = 1;

  @override
  void dispose() {
    _pesquisaController.dispose();
    _pesquisaFocus.dispose();
    super.dispose();
  }
}
