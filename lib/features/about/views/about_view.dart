import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';

const _stats = [
  ('Products Delivered', '50,000+'),
  ('Happy Clients', '3,000+'),
  ('Years in Business', '5+'),
  ('Cities Served', '64'),
];

const _values = [
  (Icons.inventory_2_outlined, 'Premium Quality', 'Every product is crafted with precision using industry-grade materials, ensuring your brand stands out.'),
  (Icons.access_time_filled, 'Fast Turnaround', 'From order to delivery — we move fast without compromising quality, so your deadlines are always met.'),
  (Icons.shield_outlined, 'Trusted & Reliable', 'Thousands of businesses across Bangladesh trust PripackLab for consistent, dependable printing solutions.'),
  (Icons.emoji_events_outlined, 'Certified Excellence', 'Our processes meet international quality benchmarks, giving you professional results every time.'),
];

/// Ports reacttemplate's AboutUs.jsx — static content, no scroll-reveal
/// animations or the Bangladesh map illustration since neither add
/// functional value on mobile.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 4, backgroundColor: AppColors.primary),
                SizedBox(width: 8),
                Text('About PripackLab', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text("Bangladesh's Most Trusted Printing Partner", style: AppTextStyles.heading),
          const SizedBox(height: 14),
          const Text(
            'PripackLab is a Dhaka-based premium printing and packaging company dedicated to helping businesses build powerful brand identities. From custom business cards and ID cards to full-scale packaging solutions, we deliver quality that speaks for itself.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 10),
          const Text(
            'Founded in Mirpur-10, Dhaka, we have grown to serve over 3,000 businesses across all 64 districts of Bangladesh. Our state-of-the-art production facility combines cutting-edge technology with skilled craftsmanship to produce materials that meet international standards.',
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.location_on_outlined, color: AppColors.primaryDark),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HEAD OFFICE', style: AppTextStyles.label),
                      Text('Mirpur-10, Dhaka-1216, Bangladesh', style: AppTextStyles.body),
                      Text('support@pripacklab.com', style: AppTextStyles.bodyMuted),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: _stats
                .map((s) => Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF2DD4BF), Color(0xFF22D3EE), Color(0xFFFDE047)]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.$2, style: AppTextStyles.heading),
                            const SizedBox(height: 2),
                            Text(s.$1, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: _values
                .map((v) => Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                            child: Icon(v.$1, size: 18, color: AppColors.primaryDark),
                          ),
                          const SizedBox(height: 8),
                          Text(v.$2, style: AppTextStyles.subheading.copyWith(fontSize: 13)),
                          const SizedBox(height: 4),
                          Expanded(child: Text(v.$3, style: AppTextStyles.bodyMuted.copyWith(fontSize: 11))),
                        ],
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 28),
          const Text('Ready to Elevate Your Brand?', style: AppTextStyles.heading, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text(
            'Join thousands of businesses that rely on PripackLab for premium printing, fast delivery, and unmatched quality across Bangladesh.',
            style: AppTextStyles.bodyMuted,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => launchUrl(Uri.parse('mailto:support@pripacklab.com')),
            icon: const Icon(Icons.mail_outline),
            label: const Text('Contact Us'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
