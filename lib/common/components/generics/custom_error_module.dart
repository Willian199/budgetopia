import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:lottie/lottie.dart';

final class CustomErrorModule extends ErrorModuleInterface {
  const CustomErrorModule(super.snapshot);

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = AdaptiveTheme.of(context).theme;
    return Scaffold(
      body: Container(
        decoration: Degrade.efeitoDegrade(
          cores: <Color>[
            tema.colorScheme.primaryContainer,
            tema.colorScheme.onSecondary,
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/lottie/module_error.json",
                fit: BoxFit.scaleDown,
                frameRate: FrameRate.max,
                height: 150,
                width: 150,
                repeat: false,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('Oops, algo deu errado!'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(snapshot.error.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
