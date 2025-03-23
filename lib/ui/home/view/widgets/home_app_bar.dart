// cyberpunk_app_bar.dart
import 'package:budgetopia/common/components/button/container_back_button.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/ui/home/view/widgets/home_cricle_avatar.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    required this.animation,
    required this.title,
    required this.notificationCount,
    super.key,
  });
  final Animation<double> animation;
  final String title;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;

    final Color primaryColor = theme.colorScheme.primary;
    final Color tertiaryColor = theme.colorScheme.tertiary;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: child!,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botão de menu
            const ContainerBackButton(),

            // Título com estilo futurista
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                color: primaryColor,
                shadows: [
                  Shadow(
                    color: primaryColor.withAlpha(128),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),

            // Avatar com badge de notificação
            CyberpunkAvatar(
              tertiaryColor: tertiaryColor,
              notificationCount: notificationCount,
            ),
          ],
        ),
      ),
    );
  }
}
