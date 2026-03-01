import 'package:budgetopia/common/components/date_picker/cyber_date_picker_input.dart';
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_selector.dart';
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:budgetopia/common/components/date_picker/notifier/cyber_date_picker_notifier.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_selector_type.dart';
import 'package:flutter/material.dart';

class CyberDatePicker extends StatefulWidget {
  const CyberDatePicker({
    required this.onDateSelected,
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime) onDateSelected;

  @override
  _CyberDatePickerState createState() => _CyberDatePickerState();
}

class _CyberDatePickerState extends State<CyberDatePicker> with TickerProviderStateMixin {
  late CyberDatePickerModel _model;

  late AnimationController _glitchAnimController;
  late Animation<double> _glitchAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize model
    final now = DateTime.now();
    final normalizedNow = DateTime(now.year, now.month, now.day);
    _model = CyberDatePickerModel(
      initialDate: widget.initialDate ?? normalizedNow,
      onDateSelected: widget.onDateSelected,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    // Glitch animation controller
    _glitchAnimController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _glitchAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _glitchAnimController,
            curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
          ),
        );
  }

  @override
  void dispose() {
    _glitchAnimController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _model,
          builder: (context, child) {
            return Stack(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: context.backgroundColor,
                    ),
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Component selector (only visible in selector mode)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _model.mode == CyberDatePickerMode.selector ? 1.0 : 0.0,
                          child: CyberDatePickerSelectorType(
                            activeComponent: _model.activeComponent,
                            onComponentSelected: _model.switchComponent,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Mode toggle content
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: _model.mode == CyberDatePickerMode.selector
                              ?
                                // Selector mode
                                CyberDatePickerSelector(
                                  key: const ValueKey(CyberDatePickerMode.selector),
                                  selectedDate: _model.selectedDate,
                                  activeComponent: _model.activeComponent,
                                  firstDate: widget.firstDate,
                                  lastDate: widget.lastDate,
                                  glitchAnimation: _glitchAnimation,
                                  onDateChanged: _model.updateDate,
                                )
                              :
                                // Input mode
                                CyberDatePickerInput(
                                  key: const ValueKey(CyberDatePickerMode.input),
                                  dayController: _model.dayController,
                                  monthController: _model.monthController,
                                  yearController: _model.yearController,
                                  dayFocus: _model.dayFocus,
                                  monthFocus: _model.monthFocus,
                                  yearFocus: _model.yearFocus,
                                  model: _model,
                                  onSubmitted: (_) => _model.updateDateFromInput(),
                                ),
                        ),

                        const SizedBox(height: 40),

                        // Instructions text
                        SizedBox(
                          height: 40,
                          width: double.maxFinite,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              _model.mode == CyberDatePickerMode.selector
                                  ? 'Deslize horizontalmente para mudar o valor\nToque nos botões para mudar o campo'
                                  : 'Digite a data no formato DD/MM/AAAA',
                              textAlign: TextAlign.center,
                              style: context.instructionTextStyle(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Full date display for reference - clickable to toggle mode
                        GestureDetector(
                          onTap: _model.toggleMode,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: context.dateDisplayDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${_model.selectedDate.day} ${CyberDatePickerConstants.months[_model.selectedDate.month - 1]} ${_model.selectedDate.year}',
                                  style: context.dateDisplayTextStyle(),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  _model.mode == CyberDatePickerMode.selector
                                      ? Icons.edit
                                      : Icons.change_circle_outlined,
                                  color: context.accentColor,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Select Button
                        ElevatedButton(
                          onPressed: () {
                            if (_model.mode == CyberDatePickerMode.input) {
                              _model.updateDateFromInput();
                            }
                            widget.onDateSelected(_model.selectedDate);
                            Navigator.of(context).pop();
                          },
                          style: context.confirmButtonStyle(),
                          child: const Text(
                            'CONFIRMAR DATA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
