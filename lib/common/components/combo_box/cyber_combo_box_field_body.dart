part of 'cyber_combo_box.dart';

class _CyberComboBoxFieldBody<T> extends StatelessWidget {
  const _CyberComboBoxFieldBody({
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.selectedOption,
    required this.focusNode,
    required this.isExpanded,
    required this.hasFocus,
    required this.expandAnimation,
    required this.maxMenuHeight,
    required this.onTapHeader,
    required this.onSelect,
    super.key,
  });

  final String label;
  final List<CyberComboBoxOption<T>> options;
  final T selectedValue;
  final CyberComboBoxOption<T> selectedOption;
  final FocusNode focusNode;
  final bool isExpanded;
  final bool hasFocus;
  final Animation<double> expandAnimation;
  final double maxMenuHeight;
  final VoidCallback onTapHeader;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color primaryColor = colors.primary;
    final Color backgroundColor = colors.surface;
    final Color borderColor = hasFocus ? primaryColor : primaryColor.withValues(alpha: 0.30);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        AnimatedBuilder(
          animation: expandAnimation,
          builder: (context, _) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1.5),
                color: backgroundColor.withValues(alpha: 0.78),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        focusNode: focusNode,
                        onTap: onTapHeader,
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 52),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              if (selectedOption.icon != null) ...[
                                SizedBox(width: 24, height: 24, child: selectedOption.icon),
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: Text(
                                  selectedOption.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor.withValues(alpha: 0.90),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              AnimatedRotation(
                                duration: const Duration(milliseconds: 250),
                                turns: isExpanded ? 0.5 : 0,
                                child: Icon(Icons.keyboard_arrow_down, color: primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: expandAnimation,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: math.min(options.length * 56, maxMenuHeight),
                        ),
                        color: backgroundColor.withValues(alpha: 0.92),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final CyberComboBoxOption<T> option = options[index];
                            final bool isSelected = option.value == selectedValue;

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => onSelect(option.value),
                                child: Container(
                                  height: 56,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: primaryColor.withValues(alpha: 0.10),
                                      ),
                                    ),
                                    color: isSelected ? primaryColor.withValues(alpha: 0.14) : Colors.transparent,
                                  ),
                                  child: Row(
                                    children: [
                                      if (option.icon != null) ...[
                                        SizedBox(width: 24, height: 24, child: option.icon),
                                        const SizedBox(width: 10),
                                      ],
                                      Expanded(
                                        child: Text(
                                          option.label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: primaryColor.withValues(alpha: 0.90),
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check,
                                          size: 18,
                                          color: primaryColor,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
