import 'package:budgetopia/common/components/generics/default_back_button.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        leading: const DefaultBackButton(),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sobre o App',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Text(
                  '''
            O aplicativo de carro, mecânica e lavação é uma solução inovadora para os proprietários de veículos. Com esse aplicativo, você pode facilmente encontrar oficinas mecânicas e serviços de lavagem de carro próximos a você, agendar serviços e obter preços competitivos. 
                
            Além disso, o aplicativo também oferece a conveniência de realizar pagamentos eletronicamente e manter um histórico de serviços de manutenção do seu veículo. Com o aplicativo de carro, mecânica e lavação, você pode economizar tempo e dinheiro, bem como manter o seu carro em perfeitas condições.
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
    );
  }
}
