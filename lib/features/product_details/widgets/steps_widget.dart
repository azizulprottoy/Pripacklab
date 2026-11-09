import 'package:flutter/material.dart';

import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';

class _Step {
  final String number;
  final String label;
  final String? text;
  final Color color;

  _Step({required this.number, required this.label, required this.text, required this.color});
}

class StepsWidget extends StatelessWidget {
  final String? step1;
  final String? step2;
  final String? step3;

  const StepsWidget({super.key, this.step1, this.step2, this.step3});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _Step(number: '01', label: 'Place Order', text: step1, color: AppColors.primary),
      _Step(number: '02', label: 'We Process', text: step2, color: AppColors.cyan),
      _Step(number: '03', label: 'Get Delivered', text: step3, color: AppColors.amberYellow),
    ].where((s) => s.text != null && s.text!.isNotEmpty).toList();

    if (steps.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How It Works', style: AppTextStyles.subheading),
          const SizedBox(height: 12),
          ...steps.map((step) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: step.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.number,
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: step.color.withValues(alpha: 0.5)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.label.toUpperCase(),
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: step.color, letterSpacing: 0.6),
                          ),
                          const SizedBox(height: 4),
                          Text(step.text!, style: AppTextStyles.bodyMuted),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
