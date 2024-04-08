import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/generics/default_back_button.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/pages/home/controller/home_controller.dart';
import 'package:budgetopia/pages/home/mixins/home_mixin.dart';
import 'package:budgetopia/pages/home/state/home_state.dart';
import 'package:budgetopia/pages/home/widgets/card_separador.dart';
import 'package:budgetopia/pages/home/widgets/card_valor.dart';
import 'package:budgetopia/pages/home/widgets/time_line_builder.dart';
import 'package:budgetopia/pages/home/widgets/time_line_opacity_effect.dart';
import 'package:budgetopia/pages/movimentacao/module/movimentacao_module.dart';
import 'package:budgetopia/pages/movimentacao/view/movimentacao_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends EventListenerState<HomePage, HomeState> with DDIInject<HomeController>, HomeMixin {
  @override
  void initState() {
    super.initState();
    instance.refresh(state?.tabSelecionada ?? {TipoRegistroEnum.todos});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building HomePage');
    final ThemeData tema = AdaptiveTheme.of(context).theme;
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: tema.colorScheme.onPrimary,
        ),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FlutterDDIFutureWidget(
                module: MovimentacaoModule.new,
                child: (_) => const MovimentacaoPage(),
              ),
            ),
          );

          instance.refresh(state?.tabSelecionada ?? {TipoRegistroEnum.todos});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: const Text(Strings.APP_NAME),
        leading: const DefaultBackButton(),
        actions: <Widget>[
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: Double.CINCO,
                  right: Double.DEZ,
                  left: Double.QUINZE,
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: Double.DEZ,
                  top: Double.CINCO,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.maxFinite,
        decoration: Degrade.efeitoDegrade(
          cores: <Color>[
            tema.colorScheme.primaryContainer,
            tema.colorScheme.onSecondary,
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: tema.colorScheme.onPrimary,
                      boxShadow: [
                        BoxShadow(
                          color: tema.colorScheme.primary.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 5,
                        ),
                      ],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        CardValor(titulo: Strings.SALDO, valor: state?.valorSaldo ?? 0),
                        const CardSeparador(),
                        CardValor(titulo: Strings.ENTRADA, valor: state?.valorEntrada ?? 0),
                        const CardSeparador(),
                        CardValor(titulo: Strings.SAIDA, valor: state?.valorSaida ?? 0),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Double.VINTE),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: SegmentedButton<TipoRegistroEnum>(
                      segments: <ButtonSegment<TipoRegistroEnum>>[
                        makeSegmentedButton(TipoRegistroEnum.todos, state?.tabSelecionada, tema.colorScheme),
                        makeSegmentedButton(TipoRegistroEnum.entrada, state?.tabSelecionada, tema.colorScheme),
                        makeSegmentedButton(TipoRegistroEnum.saida, state?.tabSelecionada, tema.colorScheme),
                      ],
                      selected: state?.tabSelecionada ?? {TipoRegistroEnum.todos},
                      onSelectionChanged: instance.refresh,
                      showSelectedIcon: false,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Double.VINTE),
                  child: SizedBox(
                    height: MediaQuery.orientationOf(context) == Orientation.landscape ? 250 : size.height - 290,
                    child: Stack(
                      children: [
                        TimeLineBuilder(
                          scrollGastosController: scrollMovimentacaoController,
                          registrosMovimentacao: instance.registrosAbaMovimentacao,
                        ),
                        const TimeLineOpacityeffect(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
