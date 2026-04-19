// cyberpunk_segmented_tabs.dart
import 'package:budgetopia/common/components/cyber_segmented_button/cyber_segmented_button.dart';
import 'package:budgetopia/common/components/cyber_segmented_button/cyber_segmented_notifier.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/ui/home/controller/home_controller.dart';
import 'package:budgetopia/ui/home/view/widgets/home_segmented_button_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeSegmentedButton extends StatefulWidget {
  const HomeSegmentedButton({
    super.key,
  });

  @override
  State<HomeSegmentedButton> createState() => _HomeSegmentedButtonState();
}

class _HomeSegmentedButtonState extends ListenableState<HomeSegmentedButton, HomeController> {
  @override
  Widget build(BuildContext context) {
    // Determinar a cor do acento com base na aba selecionada
    final TipoRegistroEnum itemSelected;
    final Color accentColor;

    if (listenable.value.tabSelecionada.first == TipoRegistroEnum.todos) {
      accentColor = listenable.value.valorSaldo > 0 ? Colors.green.shade600 : Colors.red.shade600;
      itemSelected = TipoRegistroEnum.todos;
    } else if (listenable.value.tabSelecionada.first == TipoRegistroEnum.entrada) {
      accentColor = Colors.green.shade600;
      itemSelected = TipoRegistroEnum.entrada;
    } else {
      accentColor = Colors.red.shade600;
      itemSelected = TipoRegistroEnum.saida;
    }

    return CyberSegmentedButton<TipoRegistroEnum>(
      selected: {itemSelected},
      onSelectionChanged: listenable.refresh,
      accentColor: accentColor,
      height: 80,
      useNeomorphism: false,
      segments: [
        CyberSegmentItem<TipoRegistroEnum>(
          value: TipoRegistroEnum.todos,
          label: HomeSegmentedButtonContent(
            title: Strings.SALDO,
            value: listenable.value.valorSaldo,
            isSelected: listenable.value.tabSelecionada.first == TipoRegistroEnum.todos,
          ),
        ),
        CyberSegmentItem<TipoRegistroEnum>(
          value: TipoRegistroEnum.entrada,
          label: HomeSegmentedButtonContent(
            title: Strings.ENTRADA,
            value: listenable.value.valorEntrada,
            isSelected: listenable.value.tabSelecionada.first == TipoRegistroEnum.entrada,
            showUpIcon: true,
          ),
        ),
        CyberSegmentItem<TipoRegistroEnum>(
          value: TipoRegistroEnum.saida,
          label: HomeSegmentedButtonContent(
            title: Strings.SAIDA,
            value: listenable.value.valorSaida,
            isSelected: listenable.value.tabSelecionada.first == TipoRegistroEnum.saida,
            showUpIcon: false,
          ),
        ),
      ],
    );
  }
}
