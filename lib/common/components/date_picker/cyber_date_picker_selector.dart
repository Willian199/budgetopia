import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:budgetopia/common/components/date_picker/notifier/cyber_date_picker_selector_notifier.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_selector_value.dart';
import 'package:flutter/material.dart';

class CyberDatePickerSelector extends StatefulWidget {
  const CyberDatePickerSelector({
    required this.selectedDate,
    required this.activeComponent,
    required this.glitchAnimation,
    required this.onDateChanged,
    super.key,
    this.firstDate,
    this.lastDate,
  });

  final DateTime selectedDate;
  final CyberDateComponent activeComponent;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Animation<double> glitchAnimation;
  final Function(DateTime) onDateChanged;

  @override
  _CyberDatePickerSelectorState createState() => _CyberDatePickerSelectorState();
}

class _CyberDatePickerSelectorState extends State<CyberDatePickerSelector> with SingleTickerProviderStateMixin {
  // Para animações
  late AnimationController _componentAnimController;
  late Animation<double> _componentAnimation;
  late Animation<double> _dateRotationAnimation;

  // Modelo
  late CyberDatePickerSelectorModel _model;

  @override
  void initState() {
    super.initState();

    // Inicializar modelo
    _model = CyberDatePickerSelectorModel(
      selectedDate: widget.selectedDate,
      activeComponent: widget.activeComponent,
      onDateChanged: widget.onDateChanged,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    // Controlador de animação do componente
    _componentAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _componentAnimation = CurvedAnimation(
      parent: _componentAnimController,
      curve: Curves.easeInOut,
    );

    _dateRotationAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(
        parent: _componentAnimController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(CyberDatePickerSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Atualizar modelo quando as props do widget mudarem
    _model = CyberDatePickerSelectorModel(
      selectedDate: widget.selectedDate,
      activeComponent: widget.activeComponent,
      onDateChanged: widget.onDateChanged,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (oldWidget.activeComponent != widget.activeComponent) {
      _componentAnimController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _componentAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _model,
      builder: (context, _) {
        final previousDate = _model.getPreviousValue();
        final nextDate = _model.getNextValue();

        return GestureDetector(
          onHorizontalDragStart: (_) => _model.onDragStart(),
          onHorizontalDragUpdate: (details) => _model.onDragUpdate(details),
          onHorizontalDragEnd: (_) => _model.onDragEnd(),
          child: SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPreviousValueWidget(context, previousDate),

                // Usando o widget separado para o valor atual
                CyberDatePickerSelectorValue(
                  model: _model,
                  glitchAnimation: widget.glitchAnimation,
                  componentAnimation: _componentAnimation,
                  dateRotationAnimation: _dateRotationAnimation,
                ),

                _buildNextValueWidget(context, nextDate),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget para o valor anterior (esquerda)
  Widget _buildPreviousValueWidget(BuildContext context, DateTime previousDate) {
    if (previousDate.isAtSameMomentAs(_model.selectedDate)) {
      return const SizedBox(width: 90);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => _model.onDateChanged(previousDate),
        child: SizedBox(
          width: 80,
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: 0.5,
              child: Text(
                _model.getFormattedValue(previousDate),
                style: TextStyle(
                  fontSize: _model.activeComponent == CyberDateComponent.day ? 40 : 30,
                  color: context.accentColor.withValues(alpha: .5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget para o próximo valor (direita)
  Widget _buildNextValueWidget(BuildContext context, DateTime nextDate) {
    if (nextDate.isAtSameMomentAs(_model.selectedDate)) {
      return const SizedBox(width: 90);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: GestureDetector(
        onTap: () => _model.onDateChanged(nextDate),
        child: SizedBox(
          width: 80,
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: 0.5,
              child: Text(
                _model.getFormattedValue(nextDate),
                style: TextStyle(
                  fontSize: _model.activeComponent == CyberDateComponent.day ? 40 : 30,
                  color: context.accentColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
