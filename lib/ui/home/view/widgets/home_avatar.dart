import 'package:budgetopia/common/components/user_imagem/view/user_image.dart';
import 'package:budgetopia/ui/home/view/widgets/home_notification_badge.dart';
import 'package:flutter/material.dart';

class HomeAvatar extends StatelessWidget {
  const HomeAvatar({
    required this.tertiaryColor,
    required this.notificationCount,
    super.key,
  });
  final Color tertiaryColor;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: tertiaryColor.withAlpha(128),
            ),
            boxShadow: [
              BoxShadow(
                color: tertiaryColor.withAlpha(77),
                blurRadius: 8,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: tertiaryColor.withAlpha(100),
                blurRadius: 9,
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(1.0),
            child: ClipOval(child: UserImage()),
          ),
        ),
        if (notificationCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: NotificationBadge(
              tertiaryColor: tertiaryColor,
              count: notificationCount,
            ),
          ),
      ],
    );
  }
}
