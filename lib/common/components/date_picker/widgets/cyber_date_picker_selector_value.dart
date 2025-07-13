import 'dart:math' as math;

import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:budgetopia/common/components/date_picker/notifier/cyber_date_picker_selector_notifier.dart';
import 'package:flutter/material.dart';

/// Widget responsável por exibir o valor atual selecionado no date picker
class CyberDatePickerSelectorValue extends StatelessWidget {
  const CyberDatePickerSelectorValue({
    required this.model,
    required this.glitchAnimation,
    required this.componentAnimation,
    required this.dateRotationAnimation,
    super.key,
  });

  final CyberDatePickerSelectorModel model;
  final Animation<double> glitchAnimation;
  final Animation<double> componentAnimation;
  final Animation<double> dateRotationAnimation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: dateRotationAnimation.value,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Efeito de glitch
          Opacity(
            opacity: glitchAnimation.value * 0.3,
            child: Text(
              model.getFormattedValue(model.selectedDate),
              style: TextStyle(
                fontSize: model.getFontSize(),
                fontWeight: FontWeight.bold,
                color: context.accentColor.withValues(alpha: 0.5),
                shadows: [
                  Shadow(
                    color: context.accentColor.withValues(alpha: 0.7),
                    blurRadius: 10,
                    offset: Offset(
                      math.sin(glitchAnimation.value * math.pi * 2) * 5,
                      math.cos(glitchAnimation.value * math.pi * 2) * 5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Valor principal
          Transform.scale(
            scale: 1.0 + (componentAnimation.value * 0.1),
            child: Text(
              model.getFormattedValue(model.selectedDate),
              style: context.valueOutlineTextStyle(
                fontSize: model.getFontSize(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
