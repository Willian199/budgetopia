import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/config/modules/start_module.dart';
import 'package:budgetopia/config/theme/dark_theme.dart';
import 'package:budgetopia/config/theme/light_theme.dart';
import 'package:budgetopia/pages/drawer/view/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  ddi.setDebugMode(false);

  // Necesário fazer o reigstro do StartModule antes de chamar o runApp.
  // Para evitar perder a rota ao salvar alguma alteração de código durante o desenvolvimento.
  await ddi.registerObject(const StartModule());

  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: LightTheme.getTheme(),
      dark: DarkTheme.getTheme(),
      initial: ddi.get<AdaptiveThemeMode>(qualifier: Qualifier.adaptive_theme_mode),
      builder: (theme, darkTheme) {
        return MaterialApp(
          title: Strings.APP_NAME,
          navigatorKey: ddi<GlobalKey<NavigatorState>>(),
          color: Colors.transparent,
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: const DrawerPage(),
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale('pt'),
          ],
        );
      },
    );
  }
}
