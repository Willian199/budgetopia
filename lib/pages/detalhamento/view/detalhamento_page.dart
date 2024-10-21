import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/generics/default_back_button.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/pages/detalhamento/state/detalhamento_state.dart';
import 'package:budgetopia/pages/detalhamento/widget/grafico_linha/grafico_linha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DetalhamentoPage extends StatefulWidget {
  const DetalhamentoPage({super.key});

  @override
  State<DetalhamentoPage> createState() => _DetalhamentoPageState();
}

class _DetalhamentoPageState extends EventListenerState<DetalhamentoPage, DetalhamentoState> {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = AdaptiveTheme.of(context).theme;
    final Size size = MediaQuery.sizeOf(context);
    final Color corBack = ddi.get<bool>(qualifier: Qualifier.dark_mode) ? tema.colorScheme.primary : tema.colorScheme.tertiary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.DETALHAMENTO),
        leading: const DefaultBackButton(),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: Degrade.efeitoDegrade(
          cores: <Color>[
            tema.colorScheme.primaryContainer,
            tema.colorScheme.onSecondary,
          ],
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minWidth: size.width,
                minHeight: 705,
              ),
              height: size.height - 100,
              child: Stack(
                children: [
                  Positioned(
                    top: 369,
                    child: Container(
                      decoration: BoxDecoration(
                        color: corBack,
                      ),
                      height: 70,
                      width: size.width,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      height: 400,
                      width: size.width,
                      child: const GraficoLinha(),
                    ),
                  ),
                  Positioned(
                    top: 410,
                    child: Container(
                      height: 270,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: tema.colorScheme.onSecondary,
                      ),
                      child: Column(
                        children: [
                          Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(16),
                            color: tema.colorScheme.primaryContainer,
                            child: Container(
                              width: size.width * .8,
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total de entradas:',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'R\$ ${Moeda.format(valor: state?.totalEntrada ?? 0)}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(16),
                            color: tema.colorScheme.primaryContainer,
                            child: Container(
                              width: size.width * .8,
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total de Saídas: ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'R\$ ${Moeda.format(valor: state?.totalSaida ?? 0)}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(16),
                            color: tema.colorScheme.primaryContainer,
                            child: Container(
                              width: size.width * .8,
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Saldo do periodo:',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'R\$ ${Moeda.format(valor: state?.totalSaldo ?? 0)}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
