// cyberpunk_home_page.dart
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/ui/home/case/home_case.dart';
import 'package:budgetopia/ui/home/controller/home_controller.dart';
import 'package:budgetopia/ui/home/mixins/home_mixin.dart';
import 'package:budgetopia/ui/home/module/home_module.dart';
import 'package:budgetopia/ui/home/view/widgets/home_add_button.dart';
import 'package:budgetopia/ui/home/view/widgets/home_app_bar.dart';
import 'package:budgetopia/ui/home/view/widgets/home_background.dart';
import 'package:budgetopia/ui/home/view/widgets/home_segmented_button.dart';
import 'package:budgetopia/ui/home/view/widgets/home_selecao_mes.dart';
import 'package:budgetopia/ui/home/view/widgets/home_transaction_list.dart';
import 'package:budgetopia/ui/movimentacao/module/movimentacao_module.dart';
import 'package:budgetopia/ui/movimentacao/view/movimentacao_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ListenableState<HomePage, HomeController> with HomeMixin, SingleTickerProviderStateMixin {
  late AnimationController _fadeInController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FlutterNativeSplash.remove();
    });
    listenable.refresh(listenable.value.tabSelecionada);

    _fadeInController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeOut,
    );

    _fadeInController.forward();
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = AdaptiveTheme.of(context).theme;
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? const Color(0xFF002215) : const Color(0xFFebffe5);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: HomeAddButton(
        animation: _fadeInAnimation,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FlutterDDIBuilder(
                module: MovimentacaoModule.new,
                child: (_) => const MovimentacaoPage(),
              ),
            ),
          );
          listenable.refresh(listenable.value.tabSelecionada);
        },
      ),
      body: Stack(
        children: [
          const HomeBackground(),
          SafeArea(
            child: Column(
              children: [
                HomeAppBar(
                  animation: _fadeInAnimation,
                  title: Strings.APP_NAME,
                  notificationCount: notificationCount,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: HomeSelecaoMes<HomeModule, HomeCase>(),
                ),
                AnimatedBuilder(
                  animation: _fadeInAnimation,
                  builder: (context, child) => Opacity(opacity: _fadeInAnimation.value, child: child!),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: HomeSegmentedButton(),
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _fadeInAnimation,
                    builder: (context, child) => Opacity(opacity: _fadeInAnimation.value, child: child!),
                    child: HomeTransactionList(
                      transacoes: listenable.registrosAbaMovimentacao,
                      onConfirmSuggestion: (sugestao) async {
                        final bool status = listenable.confirmarSugestao(sugestao);
                        if (status) {
                          listenable.refresh(listenable.value.tabSelecionada);
                        }
                        return status;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
