import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/generics/default_back_button.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:budgetopia/common/components/selecao_horizontal/view/selecao_horizontal.dart';
import 'package:budgetopia/common/components/user_imagem/view/user_image.dart';
import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/ui/home/controller/home_controller.dart';
import 'package:budgetopia/ui/home/mixins/home_mixin.dart';
import 'package:budgetopia/ui/home/module/home_module.dart';
import 'package:budgetopia/ui/home/state/home_state.dart';
import 'package:budgetopia/ui/home/view/widgets/movimentacao_list_builder.dart';
import 'package:budgetopia/ui/home/view/widgets/time_line_opacity_effect.dart';
import 'package:budgetopia/ui/home/view/widgets/valor_segmented_button.dart';
import 'package:budgetopia/ui/movimentacao/module/movimentacao_module.dart';
import 'package:budgetopia/ui/movimentacao/view/movimentacao_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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

    Future.delayed(Duration.zero, () {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building HomePage');

    final currentTab = state?.tabSelecionada ?? {TipoRegistroEnum.todos};

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
              builder: (context) => FlutterDDIBuilder(
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
              const Padding(
                padding: EdgeInsets.only(
                  top: Double.CINCO,
                  right: Double.DEZ,
                  left: Double.QUINZE,
                ),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: UserImage(),
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
        child: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HorizontalSelecaoMes<HomeModule>(
                    onPageChanged: instance.alterouSelecao,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Double.DEZ),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: SegmentedButton<TipoRegistroEnum>(
                        segments: <ButtonSegment<TipoRegistroEnum>>[
                          ButtonSegment<TipoRegistroEnum>(
                            value: TipoRegistroEnum.todos,
                            label: ValorSegmentedButton(
                              titulo: Strings.SALDO,
                              valor: state?.valorSaldo ?? 0,
                              selecionada: TipoRegistroEnum.todos == currentTab.first,
                            ),
                          ),
                          ButtonSegment<TipoRegistroEnum>(
                            value: TipoRegistroEnum.entrada,
                            label: ValorSegmentedButton(
                              titulo: Strings.ENTRADA,
                              valor: state?.valorEntrada ?? 0,
                              selecionada: TipoRegistroEnum.entrada == currentTab.first,
                            ),
                          ),
                          ButtonSegment<TipoRegistroEnum>(
                            value: TipoRegistroEnum.saida,
                            label: ValorSegmentedButton(
                              titulo: Strings.SAIDA,
                              valor: state?.valorSaida ?? 0,
                              selecionada: TipoRegistroEnum.saida == currentTab.first,
                            ),
                          ),
                        ],
                        selected: currentTab,
                        onSelectionChanged: instance.refresh,
                        showSelectedIcon: false,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Double.VINTE),
                    child: SizedBox(
                      height: size.height - 210,
                      child: Stack(
                        children: [
                          MovimentacaoListBuilder(),
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
      ),
    );
  }
}
