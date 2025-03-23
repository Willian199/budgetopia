import 'dart:math' as math;
import 'dart:ui';

import 'package:budgetopia/common/components/cyber_segmented_button/cyber_segmented_notifier.dart';
import 'package:budgetopia/common/components/painter/cyber_glow_painter.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';

// Modelo para gerenciar o estado do botão segmentado

class CyberSegmentedButton<T> extends StatefulWidget {
  const CyberSegmentedButton({
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    required this.accentColor,
    this.baseColor,
    this.height = 90.0,
    this.useNeomorphism = true,
    super.key,
  });
  final List<CyberSegmentItem<T>> segments;
  final Set<T> selected;
  final Function(Set<T>) onSelectionChanged;
  final Color? baseColor;
  final Color accentColor;
  final double height;
  final bool useNeomorphism;

  @override
  State<CyberSegmentedButton<T>> createState() => _CyberSegmentedButtonState<T>();
}

class _CyberSegmentedButtonState<T> extends State<CyberSegmentedButton<T>> {
  // Modelo para gerenciar o estado
  late final SegmentedButtonModel<T> _model;

  // Duração da animação de deslizamento
  final Duration _animationDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _model = SegmentedButtonModel<T>();
    _model.updateFromValue(widget.selected, widget.segments);
  }

  @override
  void didUpdateWidget(CyberSegmentedButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _model.updateFromValue(widget.selected, widget.segments);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDarkMode = theme.brightness == Brightness.dark;

    // Definir cores baseadas no tema ou nas props
    final baseColor = widget.baseColor ?? (isDarkMode ? const Color(0xFF002215) : const Color(0xFFebffe5));
    final accentColor = widget.accentColor;
    final textColor = isDarkMode ? Colors.white.withValues(alpha: 0.9) : Colors.black.withValues(alpha: 0.8);
    final selectedTextColor = isDarkMode ? Colors.white : Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = constraints.maxWidth / widget.segments.length;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            boxShadow: widget.useNeomorphism
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.05),
                      offset: const Offset(-4, -4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AnimatedBuilder(
                animation: _model,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // Borda
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                      ),

                      // Divisórias entre segmentos
                      Stack(
                        children: List.generate(widget.segments.length - 1, (index) {
                          return Positioned(
                            left: segmentWidth * (index + 1),
                            child: SizedBox(
                              height: widget.height,
                              child: Center(
                                child: Container(
                                  height: widget.height * 0.4,
                                  width: 1,
                                  color: accentColor.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      // Indicador de seleção com AnimatedPositioned para garantir a animação de deslizamento
                      AnimatedPositioned(
                        duration: _animationDuration,
                        curve: Curves.easeInOut,
                        left: _model.selectedIndex * segmentWidth,
                        top: 5,
                        bottom: 5,
                        width: segmentWidth,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                accentColor.withBlue(math.min(255, accentColor.b + 30).round()),
                                accentColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.6),
                                blurRadius: 12,
                                spreadRadius: -2,
                              ),
                              BoxShadow(
                                color: accentColor.withValues(alpha: .3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            painter: CyberglowPainter(
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),

                      // Botões segmentados
                      Row(
                        children: List.generate(widget.segments.length, (index) {
                          final bool isSelected = widget.selected.contains(widget.segments[index].value);

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (_model.selectedIndex != index) {
                                  // Atualizar o modelo
                                  _model.updateSelectedIndex(index);
                                  // Notificar o widget pai sobre a mudança
                                  widget.onSelectionChanged({widget.segments[index].value});
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: widget.height,
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  style: TextStyle(
                                    color: isSelected ? selectedTextColor : textColor,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: isSelected ? 14 : 13,
                                  ),
                                  child: widget.segments[index].label,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
