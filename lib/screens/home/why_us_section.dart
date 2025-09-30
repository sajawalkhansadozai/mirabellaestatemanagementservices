// ===============================
// File: lib/screens/home/why_us_section.dart
// "Why Choose Mirabella" feature grid (8 items) — responsive & overflow-proof
// ===============================
import 'package:flutter/material.dart';

import '../../constants/tokens.dart';
import '../../data/data.dart';

class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;

    // Prevent extreme accessibility scaling from breaking layouts
    final clamped = mq.copyWith(
      textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
    );

    final icons = <IconData>[
      Icons.shield_rounded, // Licensed & Insured
      Icons.schedule_rounded, // 24/7 Availability
      Icons.trending_up_rounded, // Maximize ROI
      Icons.check_circle_rounded, // Thorough Screening
      Icons.flash_on_rounded, // Quick Response
      Icons.description_rounded, // Transparent Reporting
      Icons.center_focus_strong_rounded, // Market Expertise
      Icons.favorite_rounded, // Customer First
    ];

    // Responsive header sizes
    final titleSize = w >= 1100 ? 34.0 : (w >= 700 ? 30.0 : 26.0);
    final subtitleSz = w >= 700 ? 18.0 : 16.0;

    return MediaQuery(
      data: clamped,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEFF6FF), Colors.white], // blue-50 → white
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                // ---- Header ----
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE), // blue-100
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Why Choose Mirabella',
                    style: TextStyle(
                      color: AppColors.blue800,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'What Sets Us Apart',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gray900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Experience the difference with our professional, transparent, and client-focused approach to property management',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subtitleSz,
                      height: 1.45,
                      color: const Color(0xFF4B5563), // gray-600
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ---- Grid ----
                LayoutBuilder(
                  builder: (context, c) {
                    int cross = 1;
                    if (c.maxWidth >= 1100) {
                      cross = 4;
                    } else if (c.maxWidth >= 700) {
                      cross = 2;
                    }

                    // Stable card heights per breakpoint to prevent overflow
                    final double cardHeight = switch (cross) {
                      4 => 170, // desktop
                      2 => 180, // tablet
                      _ => 200, // phones
                    };

                    // Allow a bit more copy on phones where columns = 1
                    final int descLines = switch (cross) {
                      4 => 3,
                      2 => 3,
                      _ => 4,
                    };

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: whyUsData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cross,
                        mainAxisExtent: cardHeight,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, i) {
                        final item = whyUsData[i];
                        final icon = icons[i % icons.length];

                        return _WhyTile(
                          icon: icon,
                          title: item.title,
                          description: item.description,
                          descMaxLines: descLines,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WhyTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int descMaxLines;

  const _WhyTile({
    required this.icon,
    required this.title,
    required this.description,
    this.descMaxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppShadows.soft,
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // icon badge
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE), // blue-100
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: AppColors.blue600, size: 24),
            ),
            const SizedBox(height: 10),

            // Title kept to 2 lines to avoid overflow at small widths
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.gray900,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),

            // Description line-clamped so card height stays stable
            Expanded(
              child: Text(
                description,
                maxLines: descMaxLines,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280), // gray-500/600
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
