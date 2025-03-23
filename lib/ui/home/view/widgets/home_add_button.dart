// cyberpunk_add_button.dart
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class HomeAddButton extends StatelessWidget {
  const HomeAddButton({
    required this.animation,
    required this.onPressed,
    super.key,
  });
  final Animation<double> animation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final Color tertiaryColor = theme.colorScheme.tertiary;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: FloatingActionButton(
            elevation: 8,
            backgroundColor: tertiaryColor,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tertiaryColor,
                boxShadow: [
                  BoxShadow(
                    color: tertiaryColor.withAlpha(100),
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Icon(
                Icons.add,
                color: theme.colorScheme.onPrimary,
                size: 28,
              ),
            ),
            onPressed: onPressed,
          ),
        );
      },
    );
  }
}
