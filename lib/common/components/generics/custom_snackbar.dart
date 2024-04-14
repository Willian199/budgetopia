import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:lottie/lottie.dart';

class CustomSnackBar {
  static void sucessoTitulo({
    String titulo = 'Sucesso!!!',
    String mensagem = 'Ação executada com sucesso',
  }) {
    final ColorScheme schema = AdaptiveTheme.of(ddi<GlobalKey<NavigatorState>>().currentContext!).theme.colorScheme;

    late Color textColor;
    late Color backgroundColor;
    if (ddi.get(qualifier: Qualifier.dark_mode)) {
      textColor = schema.primary;
      backgroundColor = schema.onPrimary;
    } else {
      textColor = schema.onPrimary;
      backgroundColor = schema.primary;
    }

    Flushbar(
      titleText: Padding(
        padding: const EdgeInsets.only(left: Double.DEZ),
        child: Text(
          titulo,
          style: TextStyle(color: textColor, fontSize: 20),
        ),
      ),
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(Double.QUINZE),
      shouldIconPulse: false,
      borderRadius: BorderRadius.circular(20),
      icon: Padding(
        padding: const EdgeInsets.only(left: Double.CINCO),
        child: Lottie.asset(
          "assets/lottie/ok.json",
          fit: BoxFit.scaleDown,
          frameRate: FrameRate.max,
          height: 80,
          width: 60,
          repeat: false,
        ),
      ),
      duration: const Duration(seconds: 3),
      messageText: Padding(
        padding: const EdgeInsets.only(left: Double.DEZ),
        child: Text(
          mensagem,
          style: TextStyle(color: textColor),
        ),
      ),
    ).show(ddi<GlobalKey<NavigatorState>>().currentContext!);
  }

  static void sucesso({
    String mensagem = 'Ação executada com sucesso',
    void Function(Flushbar)? onTap,
    void Function(FlushbarStatus?)? onStatusChanged,
  }) {
    padrao(
      onTap: onTap,
      onStatusChanged: onStatusChanged,
      mensagem: mensagem,
      asset: 'ok',
    );
  }

  static void informacacao({
    String mensagem = 'A solicitação foi executa',
    void Function(Flushbar)? onTap,
    void Function(FlushbarStatus?)? onStatusChanged,
  }) {
    padrao(
      onTap: onTap,
      onStatusChanged: onStatusChanged,
      mensagem: mensagem,
      asset: 'info',
      repeat: true,
    );
  }

  static void padrao({
    required String mensagem,
    required String asset,
    void Function(Flushbar)? onTap,
    void Function(FlushbarStatus?)? onStatusChanged,
    bool repeat = false,
  }) {
    final context = ddi<GlobalKey<NavigatorState>>().currentContext!;
    final ColorScheme schema = AdaptiveTheme.of(context).theme.colorScheme;

    Color? textColor;
    late Color backgroundColor;
    if (ddi.get(qualifier: Qualifier.dark_mode)) {
      backgroundColor = schema.tertiaryContainer;
    } else {
      textColor = schema.onPrimary;
      backgroundColor = schema.tertiary;
    }

    Flushbar(
      backgroundColor: backgroundColor,
      onTap: onTap,
      onStatusChanged: onStatusChanged,
      margin: const EdgeInsets.all(Double.DEZ),
      borderRadius: BorderRadius.circular(20),
      icon: Padding(
        padding: const EdgeInsets.only(left: Double.CINCO),
        child: Lottie.asset(
          "assets/lottie/$asset.json",
          fit: BoxFit.scaleDown,
          frameRate: FrameRate.max,
          height: 80,
          width: 60,
          repeat: repeat,
        ),
      ),
      duration: const Duration(seconds: 3),
      messageText: Padding(
        padding: const EdgeInsets.only(left: Double.DEZ),
        child: Text(
          mensagem,
          style: TextStyle(color: textColor),
        ),
      ),
    ).show(context);
  }
}
