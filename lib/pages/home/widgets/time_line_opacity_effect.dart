import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:budgetopia/pages/home/model/opacity_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TimeLineOpacityeffect extends StatefulWidget {
  const TimeLineOpacityeffect({super.key});

  @override
  State<TimeLineOpacityeffect> createState() => _TimeLineOpacityeffectState();
}

class _TimeLineOpacityeffectState extends EventListenerState<TimeLineOpacityeffect, OpacityState> {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = AdaptiveTheme.of(context).theme;
    return AnimatedOpacity(
      opacity: (state?.position ?? 0) > 10 ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: Degrade.efeitoDegrade(
          cores: <Color>[
            tema.colorScheme.primaryContainer.withOpacity(0.9),
            tema.colorScheme.primaryContainer.withOpacity(0.7),
            tema.colorScheme.primaryContainer.withOpacity(0.2),
            tema.colorScheme.primaryContainer.withOpacity(0)
          ],
        ),
      ),
    );
  }
}
