import 'package:flutter_test/flutter_test.dart';
import 'package:heimdall_test/heimdall_test.dart';

void main() {
  group('Budgetopia architecture', () {
    late final HeimdallProject project = const HeimdallFileImporter().importPath();

    test('keeps Dart sources parseable and dependency directives healthy', () {
      Heimdall.code().shouldParse().check(project).assertNoFindings();
      Heimdall.code().shouldNotImportDartMirrors().check(project).assertNoFindings();
    });

    test('keeps data layer independent from presentation implementation', () {
      Heimdall.files()
          .that()
          .resideInPath('data/**')
          .should()
          .noImportUriMatching(
            RegExp(r'^package:budgetopia/ui/.*/(controllers?|modules?|mixins?|states?|usecases?|views?|widgets?)/'),
          )
          .check(project)
          .assertNoFindings();
    });

    test('keeps repository and service responsibilities separated', () {
      Heimdall.layers()
          .layer('Service')
          .definedBy(['data/service/**/*_service.dart'])
          .layer('Repository')
          .definedBy(['data/repository/**/*_repository.dart'])
          .layer('Common')
          .definedBy(['common/**'])
          .layer('Banco')
          .definedBy(['config/banco/**'])
          .layer('Model')
          .definedBy(['config/model/**'])
          .whereLayer('Repository')
          .mayOnlyBeAccessedByLayers(['Repository'])
          .whereLayer('Service')
          .mayOnlyBeAccessedByLayers(['Repository'])
          .asRule()
          .because('data services should not access repositories')
          .check(project)
          .assertNoFindings();
    });

    test('uses AdaptiveTheme as the single application theme boundary', () {
      Heimdall.noFiles()
          .should()
          .containSourceMatching(RegExp(r'(^|[^A-Za-z0-9_])Theme\.of\('))
          .check(project)
          .assertNoFindings();
      Heimdall.noFiles()
          .that()
          .satisfy(
            HeimdallPredicate(
              'are not the app bootstrap',
              (file, _) => file.relativePath != 'main.dart',
            ),
          )
          .should()
          .containSource('AdaptiveTheme(')
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('main.dart')
          .should()
          .importUri('package:adaptive_theme/adaptive_theme.dart')
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('main.dart')
          .should()
          .containAllSource([
            'AdaptiveTheme(',
            'light: LightTheme.getTheme()',
            'dark: DarkTheme.getTheme()',
            'initial: ddi.get<AdaptiveThemeMode>',
            'theme: theme',
            'darkTheme: darkTheme',
          ])
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('config/modules/start_module.dart')
          .should()
          .containAllSource([
            'AdaptiveTheme.getThemeMode()',
            'AdaptiveThemeMode.system',
            'Qualifier.adaptive_theme_mode',
            'Qualifier.dark_mode',
          ])
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('common/constantes/qualifiers.dart')
          .should()
          .containAllSource([
            'adaptive_theme_mode',
            'dark_mode',
          ])
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('common/extensions/context_extension.dart')
          .should()
          .containAllSource([
            'ThemeData get theme => AdaptiveTheme.of(this).theme',
            'ColorScheme get colorScheme => theme.colorScheme',
            'bool get isDark => AdaptiveTheme.of(this).mode == AdaptiveThemeMode.dark',
          ])
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('ui/drawer/view/widget/drawer_item.dart')
          .should()
          .containAllSource([
            'AdaptiveTheme.of(context).setLight()',
            'AdaptiveTheme.of(context).setDark()',
          ])
          .check(project)
          .assertNoFindings();
    });

    test('uses flutter_ddi for app bootstrap and feature modules', () {
      Heimdall.noFiles()
          .that()
          .satisfy(
            HeimdallPredicate(
              'are not the app bootstrap',
              (file, _) => file.relativePath != 'main.dart',
            ),
          )
          .should()
          .containSource('MaterialApp(')
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('main.dart')
          .should()
          .importUri('package:flutter_ddi/flutter_ddi.dart')
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('main.dart')
          .should()
          .containAllSource([
            'FlutterDDIBuilder(',
            'module: StartModule.new',
            'navigatorKey: ddi.get<GlobalKey<NavigatorState>>()',
          ])
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('config/modules/start_module.dart')
          .should()
          .containAllSource([
            'with DDIModule',
            'object<GlobalKey<NavigatorState>>',
            'singleton<Database>',
          ])
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('**/*_module.dart')
          .or()
          .resideInPath('config/modules/*.dart')
          .should()
          .importUri('package:flutter_ddi/flutter_ddi.dart')
          .check(project)
          .assertNoFindings();
      Heimdall.files()
          .that()
          .resideInPath('**/*_module.dart')
          .or()
          .resideInPath('config/modules/*.dart')
          .should()
          .containAnySource([
            'with DDIModule',
            'extends LoaderModuleInterface',
            'extends ErrorModuleInterface',
          ])
          .check(project)
          .assertNoFindings();
    });

    test('keeps persistence and platform boundaries explicit', () {
      Heimdall.noFiles()
          .that()
          .resideInPath('**/*.g.dart')
          .should()
          .exist()
          .allowEmpty()
          .check(project)
          .assertNoFindings();
      Heimdall.files().should().noImportUri('dart:html').allowEmpty().check(project).assertNoFindings();
      Heimdall.files().should().noImportUri('dart:js').allowEmpty().check(project).assertNoFindings();
    });
  });
}
