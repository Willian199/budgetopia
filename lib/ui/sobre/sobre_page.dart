import 'package:budgetopia/common/components/button/container_back_button.dart';
import 'package:budgetopia/common/components/generics/app_scaffold.dart';
import 'package:budgetopia/common/components/generics/page_title.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/ui/sobre/widget/sobre_corpo.dart';
import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {

    // Using theme colors directly from your theme files
    final tertiaryColor = context.colorScheme.tertiary;

    return AppScaffold(
      appBar: Row(
        children: [
          // Custom Menu Button with glow effect
          const ContainerBackButton(),

          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: tertiaryColor.withAlpha(128),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: tertiaryColor.withAlpha(51),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const PageTitle(title: Strings.APP_NAME),
              ),
            ),
          ),

          // Balance layout with empty container
          const SizedBox(width: 30),
        ],
      ),
      body: const SobreCorpo(),
    );
  }
}
