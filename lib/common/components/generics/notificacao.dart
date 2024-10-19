import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Notificacao {
  factory Notificacao() => _instance;

  Notificacao.internal();
  static final Notificacao _instance = Notificacao.internal();

  static bool _isOpen = false;

  static GlobalKey<NavigatorState>? _navigatorKey;

  static void close() {
    _navigatorKey ??= ddi.get<GlobalKey<NavigatorState>>();
    if (_isOpen) {
      Navigator.pop(_navigatorKey!.currentContext!);
    }
    _isOpen = false;
  }

  static AlertStyle _alertStyle() {
    _navigatorKey ??= ddi.get<GlobalKey<NavigatorState>>();
    final ThemeData tema = Theme.of(_navigatorKey!.currentContext!);
    final bool darkMode = tema.brightness == Brightness.dark;

    return AlertStyle(
      constraints: const BoxConstraints(minHeight: 200),
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      backgroundColor: darkMode ? tema.colorScheme.onSecondary : tema.colorScheme.secondary,
      animationDuration: const Duration(milliseconds: 300),
      overlayColor: tema.colorScheme.secondaryContainer.withOpacity(0.4),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Double.VINTE),
      ),
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: darkMode ? Colors.white : tema.colorScheme.onPrimary,
        fontSize: Double.VINTE,
      ),
      descStyle: TextStyle(
        color: darkMode ? Colors.white : tema.colorScheme.onSecondary,
        fontSize: Double.QUINZE,
      ),
    );
  }

  static void erro(String mensagem, {Function? callbackErro}) {
    if (_isOpen) {
      return;
    }

    _isOpen = true;

    final ThemeData tema = Theme.of(_navigatorKey!.currentContext!);
    final bool darkMode = tema.brightness == Brightness.dark;

    Alert(
      context: _navigatorKey!.currentContext!,
      type: AlertType.error,
      title: Strings.ERRO,
      desc: mensagem,
      style: _alertStyle(),
      onWillPopActive: true,
      closeFunction: () {
        _isOpen = false;
        callbackErro?.call();
      },
      buttons: [
        DialogButton(
          onPressed: () {
            close();
            callbackErro?.call();
          },
          color: darkMode ? tema.colorScheme.onSecondary : tema.primaryColor,
          width: Double.CEM,
          child: const Text(
            Strings.OK,
            style: TextStyle(
              color: Colors.white,
              fontSize: Double.VINTE,
            ),
          ),
        ),
      ],
    ).show();
  }

  static void carregando(String mensagem) {
    if (_isOpen) {
      return;
    }

    _isOpen = true;
    Alert(
      context: _navigatorKey!.currentContext!,
      type: AlertType.none,
      onWillPopActive: true,
      title: Strings.CARREGANDO,
      closeFunction: () {
        _isOpen = false;
      },
      desc: mensagem,
      style: _alertStyle(),
    ).show();
  }

  static void vazia({
    required BuildContext context,
    required Widget content,
    bool autoClose = true,
    bool buttonDefault = true,
    AlertType type = AlertType.none,
    List<DialogButton> buttons = const [],
    String? title,
    String? mensagem,
    Function? onClose,
    AlertStyle? style,
    Function? onSucess,
  }) {
    style ??= _alertStyle();

    if (buttonDefault) {
      final ThemeData tema = Theme.of(context);
      final bool darkMode = tema.brightness == Brightness.dark;

      buttons = [
        DialogButton(
          onPressed: () {
            if (autoClose) {
              close();
            }
            onSucess?.call();
          },
          color: darkMode ? tema.colorScheme.onSecondary : tema.primaryColor,
          width: Double.CEM,
          child: const Text(
            Strings.OK,
            style: TextStyle(color: Colors.white, fontSize: Double.VINTE),
          ),
        ),
        DialogButton(
          onPressed: () {
            close();

            onClose?.call();
          },
          color: Colors.grey,
          width: Double.CEM,
          child: const Text(
            Strings.CANCELAR,
            style: TextStyle(color: Colors.white, fontSize: Double.VINTE),
          ),
        ),
      ];
    }

    _isOpen = true;
    Alert(
      context: context,
      type: type,
      onWillPopActive: true,
      title: title,
      closeFunction: () {
        close();
        onClose?.call();
      },
      desc: mensagem,
      style: style,
      content: FittedBox(
        fit: BoxFit.fitHeight,
        child: content,
      ),
      buttons: buttons,
    ).show();
  }

  static void sucesso(
    String mensagem, {
    String title = '',
    Function? onClose,
  }) {
    if (_isOpen) {
      return;
    }

    final ThemeData tema = Theme.of(_navigatorKey!.currentContext!);
    final bool darkMode = tema.brightness == Brightness.dark;

    _isOpen = true;
    Alert(
      context: _navigatorKey!.currentContext!,
      type: AlertType.success,
      title: title,
      onWillPopActive: true,
      closeFunction: () {
        _isOpen = false;
        onClose?.call();
      },
      desc: mensagem,
      style: _alertStyle(),
      buttons: [
        DialogButton(
          onPressed: () {
            close();
            onClose?.call();
          },
          color: darkMode ? tema.colorScheme.onSecondary : tema.primaryColor,
          width: Double.CEM,
          child: const Text(
            Strings.OK,
            style: TextStyle(color: Colors.white, fontSize: Double.VINTE),
          ),
        ),
      ],
    ).show();
  }
}
