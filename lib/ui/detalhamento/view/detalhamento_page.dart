import 'package:budgetopia/common/components/button/container_back_button.dart';
import 'package:budgetopia/common/components/generics/app_scaffold.dart';
import 'package:budgetopia/common/components/generics/page_title.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/ui/detalhamento/controller/detalhamento_controller.dart';
import 'package:budgetopia/ui/detalhamento/view/widget/detalhamennto_financeiro_block.dart';
import 'package:budgetopia/ui/detalhamento/view/widget/detalhamento_target.dart';
import 'package:budgetopia/ui/detalhamento/view/widget/grafico_dados_linha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DetalhamentoPage extends StatefulWidget {
  const DetalhamentoPage({super.key});

  @override
  State<DetalhamentoPage> createState() => _DetalhamentoPageState();
}

class _DetalhamentoPageState extends ListenableState<DetalhamentoPage, DetalhamentoController> {
  @override
  Widget build(BuildContext context) {
    final Color secondaryColor = context.colorScheme.secondary;

    return AppScaffold(
      appBar: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ContainerBackButton(),
          PageTitle(title: Strings.DETALHES),
          SizedBox(width: 50),
        ],
      ),
      body: Column(
        children: [
          DetalhamentoTarget(valorSaldoObjetivo: listenable.valorSaldoObjetivo),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: secondaryColor.withAlpha(51),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const GraficoDadosLinha(),
            ),
          ),
          DetalhamenntoFinanceiroBlock(
            totalEntrada: listenable.value.totalEntrada,
            totalSaida: listenable.value.totalSaida,
            totalSaldo: listenable.value.totalSaldo,
          ),
        ],
      ),
    );
  }
}
