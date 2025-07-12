import 'package:budgetopia/common/components/home_transaction/alternative_atom/controller/alternative_atom_group_notifier.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/group_widgets/alternative_atom_date_circle.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/group_widgets/alternative_atom_expand_button.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/group_widgets/alternative_atom_item_count.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/group_widgets/alternative_atom_light_indicators.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/group_widgets/alternative_atom_retro_label.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/group_widgets/alternative_atom_total_display.dart';
import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AlternativeAtomControlPanel extends StatelessWidget {
  const AlternativeAtomControlPanel({
    required this.day,
    required this.month,
    required this.totalValue,
    required this.transactionsCount,
    required this.notifier,
    super.key,
  });

  final int day;
  final String month;
  final double totalValue;
  final int transactionsCount;
  final AlternativeAtomGroupNotifier notifier;

  @override
  Widget build(BuildContext context) {
    print('refresh');
    return GestureDetector(
      onTap: notifier.toggleExpand,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main control panel
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: AtomPunkColorPalette.darkGreen,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: AtomPunkColorPalette.cream.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                // Date indicator
                AlternativeAtomDateCircle(day: day, month: month),

                // Main content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        // Title
                        Row(
                          spacing: 8,
                          children: [
                            const AtompunkRetroLabel(),
                            AlternativeAtomItemCount(count: transactionsCount),
                          ],
                        ),

                        // Total value display
                        AtompunkTotalDisplay(totalValue: totalValue),
                      ],
                    ),
                  ),
                ),

                // Expand button
                ListenableBuilder(
                  listenable: notifier,
                  builder: (context, child) {
                    return AlternativeAtomExpandButton(
                      isExpanded: notifier.isExpanded,
                    );
                  },
                ),
              ],
            ),
          ),

          // Light indicators on top edge
          Positioned(
            top: -3,
            left: 100,
            right: 100,
            child: AlternativeAtomLightIndicators(),
          ),
        ],
      ),
    );
  }
}
