import 'package:flutter/material.dart';

import '../../res/theme/app_colors.dart';

/// Checkbox-list multi-select behind a bottom sheet — same fix applied to
/// the web app's native `<select multiple>` (which required ctrl/cmd-click
/// and read as broken). One tap opens a scrollable checkbox list instead.
class MultiSelectField extends StatelessWidget {
  final String hint;
  final List<String> options;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  const MultiSelectField({
    super.key,
    required this.hint,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  Future<void> _openSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Select services', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: options.map((option) {
                          final checked = selected.contains(option);
                          return CheckboxListTile(
                            value: checked,
                            title: Text(option),
                            activeColor: AppColors.primary,
                            onChanged: (_) {
                              onToggle(option);
                              setSheetState(() {});
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openSheet(context),
      child: InputDecorator(
        decoration: const InputDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selected.isEmpty ? hint : selected.join(', '),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected.isEmpty ? AppColors.textFaint : AppColors.textDark,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.textFaint),
          ],
        ),
      ),
    );
  }
}
