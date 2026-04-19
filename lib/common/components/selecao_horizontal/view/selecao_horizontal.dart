import 'dart:async';
import 'dart:ui';

import 'package:budgetopia/common/components/selecao_horizontal/config/update_interface.dart';
import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/completer_extension.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeSelecaoMes<ModuleT extends DDIModule, CaseT extends UpdateInterface> extends StatefulWidget {
  const HomeSelecaoMes({super.key});

  @override
  State<HomeSelecaoMes<ModuleT, CaseT>> createState() => _HomeSelecaoMesState<ModuleT, CaseT>();
}

class _HomeSelecaoMesState<ModuleT extends DDIModule, CaseT extends UpdateInterface>
    extends State<HomeSelecaoMes<ModuleT, CaseT>>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;

  late final SelecaoHorizontalController<CaseT> instance = ddi.get<SelecaoHorizontalController<CaseT>>(
    qualifier: '$ModuleT${SelecaoHorizontalController<CaseT>}',
  );

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  final Completer<void> complete = Completer();

  @override
  void initState() {
    super.initState();
    instance.addListener(_onEvent);
    instance.alterouPosicao(0);

    complete.onComplete((_) => _pageController.jumpToPage(instance.value.posicao));

    _pageController = PageController(
      onAttach: (position) {
        if (!complete.isCompleted) {
          complete.complete();
        }
      },
    );

    // Configuração das animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  void _onEvent() {
    if (complete.isCompleted) {
      if (((_pageController.page?.toInt() ?? 0).abs() - instance.value.posicao).abs() > 1) {
        _pageController.jumpToPage(instance.value.posicao);
      } else {
        _pageController.animateToPage(instance.value.posicao, duration: Durations.medium2, curve: Curves.easeOutCubic);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    instance.removeListener(_onEvent);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDarkMode = theme.brightness == Brightness.dark;

    // Cores do tema
    final Color primaryColor = theme.colorScheme.primary;
    final Color secondaryColor = theme.colorScheme.secondary;

    return ListenableBuilder(
      listenable: instance,
      builder: (context, child) {
        if (instance.value.itens.isEmpty) {
          return const Center(
            child: Text(Strings.NENHUM_MES_DISPONIVEL),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Botão de mês anterior estilizado
              _buildNavigationButton(
                icon: Icons.chevron_left,
                color: primaryColor,
                enabled: (instance.value.posicao) > 0,
                onTap: (instance.value.posicao) > 0
                    ? () {
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                        _pageController.animateToPage(
                          instance.value.posicao - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),

              // Container central com efeito de fundo
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? primaryColor.withAlpha(20) : Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: secondaryColor.withAlpha(50 + (30 * _glowAnimation.value).toInt()),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withAlpha(15 + (20 * _glowAnimation.value).toInt()),
                            blurRadius: 8 + (4 * _glowAnimation.value),
                            spreadRadius: 1 + _glowAnimation.value,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: child,
                          ),
                        ),
                      ),
                    );
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: instance.value.itens.length,
                    onPageChanged: (page) {
                      instance.updatePosition(page);
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                    },
                    itemBuilder: (context, index) {
                      // Animação para o item selecionado
                      final bool isSelected = index == instance.value.posicao;

                      // Adicionar efeito de pulso ao mês selecionado
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? RadialGradient(
                                      colors: [
                                        primaryColor.withAlpha((40 * value).toInt()),
                                        Colors.transparent,
                                      ],
                                      radius: 1.0,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                instance.value.itens[index].capitalize,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: primaryColor,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: primaryColor.withAlpha(isSelected ? 100 : 50),
                                      blurRadius: 3 + (2 * value),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Botão de próximo mês estilizado
              _buildNavigationButton(
                icon: Icons.chevron_right,
                color: primaryColor,
                enabled: (instance.value.posicao) < (instance.value.itens.length - 1),
                onTap: (instance.value.posicao) < (instance.value.itens.length - 1)
                    ? () {
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                        final int pos = instance.value.posicao + 1;
                        _pageController.animateToPage(
                          pos,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        onTapDown: enabled ? (_) => _animationController.forward() : null,
        onTapUp: enabled ? (_) => _animationController.reverse() : null,
        onTapCancel: enabled ? () => _animationController.reverse() : null,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            // Aplicar efeito de brilho apenas se estiver habilitado
            final glowValue = enabled ? _glowAnimation.value : 0.0;

            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withAlpha(enabled ? 150 : 70),
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(enabled ? (77 + (50 * glowValue).toInt()) : 30),
                    blurRadius: 8 + (4 * glowValue),
                    spreadRadius: 1 + glowValue,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color.withValues(alpha: enabled ? 1.0 : 0.5),
              ),
            );
          },
        ),
      ),
    );
  }
}
