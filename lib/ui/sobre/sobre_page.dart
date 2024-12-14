import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/generics/default_back_button.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:flutter/material.dart';

class SobrePage extends StatefulWidget {
  const SobrePage({
    super.key,
  });

  @override
  State<SobrePage> createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = AdaptiveTheme.of(context).theme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App'),
        leading: const DefaultBackButton(),
      ),
      body: Container(
        height: double.infinity,
        decoration: Degrade.efeitoDegrade(
          cores: <Color>[
            tema.colorScheme.primaryContainer,
            tema.colorScheme.onSecondary,
          ],
        ),
        child: const SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '''
            Gerencie suas finanças com facilidade. Budgetopia permite que você acompanhe suas entradas e saídas financeiras de forma simples e eficaz. Com recursos práticos e uma interface amigável, você pode manter suas finanças sob controle, alcançando seus objetivos financeiros com mais tranquilidade.
                  
            Mantenha-se no comando das suas finanças com Budgetopia - seu parceiro confiável para uma jornada financeira mais inteligente. 
                  ''',
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Versão:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '1.0.0',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
