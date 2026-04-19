import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/cyber_segmented_button/cyber_segmented_button.dart';
import 'package:budgetopia/common/components/cyber_segmented_button/cyber_segmented_notifier.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:budgetopia/ui/movimentacao/enum/tipo_cadastro_movimentacao_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class ModoCadastroMovimentacao extends StatefulWidget {
  const ModoCadastroMovimentacao({super.key});

  @override
  State<ModoCadastroMovimentacao> createState() => _ModoCadastroMovimentacaoState();
}

class _ModoCadastroMovimentacaoState extends State<ModoCadastroMovimentacao> with DDIInject<MovimentacaoController> {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = AdaptiveTheme.of(context).theme.colorScheme.primary;

    return ValueListenableBuilder<TipoCadastroMovimentacaoEnum>(
      valueListenable: instance.tipoCadastro,
      builder: (context, tipoCadastro, child) {
        return CyberSegmentedButton<TipoCadastroMovimentacaoEnum>(
          selected: {tipoCadastro},
          accentColor: primaryColor,
          height: 62,
          useNeomorphism: false,
          onSelectionChanged: (Set<TipoCadastroMovimentacaoEnum> values) {
            if (values.isEmpty) {
              return;
            }
            instance.alterarTipoCadastro(values.first);
          },
          segments: TipoCadastroMovimentacaoEnum.values
              .map(
                (item) => CyberSegmentItem<TipoCadastroMovimentacaoEnum>(
                  value: item,
                  label: Center(
                    child: Text(
                      item.nome,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}
