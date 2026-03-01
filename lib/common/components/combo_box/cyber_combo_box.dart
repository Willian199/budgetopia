import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'cyber_combo_box_field_body.dart';

final class CyberComboBoxOption<T> {
  const CyberComboBoxOption({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final Widget? icon;
}

class CyberComboBoxField<T> extends StatefulWidget {
  const CyberComboBoxField({
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
    this.valueListenable,
    this.focusNode,
    this.onSubmitted,
    this.maxMenuHeight = 300,
    super.key,
  }) : assert(options.length > 0, 'CyberComboBoxField requires at least one option'),
       assert(
         (value != null) != (valueListenable != null),
         'Provide either value or valueListenable',
       );

  final String label;
  final List<CyberComboBoxOption<T>> options;
  final T? value;
  final ValueListenable<T>? valueListenable;
  final ValueChanged<T> onChanged;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;
  final double maxMenuHeight;

  @override
  State<CyberComboBoxField<T>> createState() => _CyberComboBoxFieldState<T>();
}

class _CyberComboBoxFieldState<T> extends State<CyberComboBoxField<T>> with SingleTickerProviderStateMixin {
  late final AnimationController _expandController;
  late final Animation<double> _expandAnimation;
  late FocusNode _focusNode;
  late bool _ownsFocusNode;
  bool _isExpanded = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _configureFocusNode(widget.focusNode);
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutCubic,
    );
  }

  void _configureFocusNode(FocusNode? externalFocusNode) {
    _ownsFocusNode = externalFocusNode == null;
    _focusNode = externalFocusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _hasFocus = _focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(covariant CyberComboBoxField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode == widget.focusNode) {
      return;
    }

    _focusNode.removeListener(_onFocusChanged);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }

    _configureFocusNode(widget.focusNode);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    _expandController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_hasFocus != _focusNode.hasFocus) {
      setState(() => _hasFocus = _focusNode.hasFocus);
    }

    if (_focusNode.hasFocus && !_isExpanded) {
      _expandController.forward();
      setState(() => _isExpanded = true);
      return;
    }

    if (!_focusNode.hasFocus && _isExpanded) {
      _expandController.reverse();
      setState(() => _isExpanded = false);
    }
  }

  CyberComboBoxOption<T> _selectedOption(T selectedValue) {
    for (final option in widget.options) {
      if (option.value == selectedValue) {
        return option;
      }
    }
    return widget.options.first;
  }

  void _toggle() {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
      return;
    }

    if (_isExpanded) {
      _focusNode.unfocus();
      return;
    }

    _expandController.forward();
    setState(() => _isExpanded = true);
  }

  void _select(T value) {
    widget.onChanged(value);
    widget.onSubmitted?.call();
    _expandController.reverse();
    setState(() => _isExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.valueListenable != null) {
      return ValueListenableBuilder<T>(
        valueListenable: widget.valueListenable!,
        builder: (context, selectedValue, _) {
          return _CyberComboBoxFieldBody<T>(
            label: widget.label,
            options: widget.options,
            selectedValue: selectedValue,
            selectedOption: _selectedOption(selectedValue),
            focusNode: _focusNode,
            isExpanded: _isExpanded,
            hasFocus: _hasFocus,
            expandAnimation: _expandAnimation,
            maxMenuHeight: widget.maxMenuHeight,
            onTapHeader: _toggle,
            onSelect: _select,
          );
        },
      );
    }

    final selectedValue = widget.value as T;
    return _CyberComboBoxFieldBody<T>(
      label: widget.label,
      options: widget.options,
      selectedValue: selectedValue,
      selectedOption: _selectedOption(selectedValue),
      focusNode: _focusNode,
      isExpanded: _isExpanded,
      hasFocus: _hasFocus,
      expandAnimation: _expandAnimation,
      maxMenuHeight: widget.maxMenuHeight,
      onTapHeader: _toggle,
      onSelect: _select,
    );
  }
}
