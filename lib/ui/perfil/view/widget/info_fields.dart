import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoFields extends StatelessWidget {
  const InfoFields({
    required this.context,
    required this.label,
    required this.icon,
    required this.controller,
    required this.focusNode,
    required this.validator,
    required this.primaryColor,
    required this.backgroundColor,
    this.nextFocus,
    this.keyboardType,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onTap,
    super.key,
  });

  final BuildContext context;
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final Color primaryColor;
  final Color backgroundColor;
  final FocusNode? nextFocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label do campo
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Campo de entrada
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onTap: onTap,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: primaryColor.withAlpha(77),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: primaryColor.withAlpha(77),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: backgroundColor.withAlpha(200),
            prefixIcon: Container(
              width: 40,
              padding: const EdgeInsets.only(left: 6),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 20,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            color: primaryColor.withAlpha(230),
            fontWeight: FontWeight.w500,
          ),
          textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: (value) {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            } else if (onFieldSubmitted != null) {
              onFieldSubmitted!(value);
            }
          },
          validator: validator,
        ),
      ],
    );
  }
}
