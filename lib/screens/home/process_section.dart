// ===============================
// File: lib/screens/home/process_section.dart
// Process: 6-step cards with step badge & icons (responsive + overflow-proof)
// ===============================
import 'package:flutter/material.dart';

import '../../constants/tokens.dart';
import '../../data/data.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key, this.onGetStarted});

  /// Call this to jump to Contact section (provided by HomeScreen)
  final VoidCallback? onGetStarted;

  void _fallback(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening contact section...')));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;

    // Clamp text scale so huge accessibility sizes don't break the grid/cards.
    final clampedMQ = mq.copyWith(
      textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
    );

    final icons = <IconData>[
      Icons.chat_bubble_rounded, // Initial Consultation
      Icons.remove_red_eye_rounded, // Property Assessment
      Icons.description_rounded, // Agreement & Onboarding
      Icons.groups_rounded, // Marketing & Tenant Placement
      Icons.settings_rounded, // Ongoing Management
      Icons.bar_chart_rounded, // Regular Reporting
    ];

    // Responsive header sizes
    final titleSize = w >= 1100 ? 34.0 : (w >= 700 ? 30.0 : 26.0);
    final subSize = w >= 700 ? 18.0 : 16.0;

    return MediaQuery(
      data: clampedMQ,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
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
                    'How It Works',
                    style: TextStyle(
                      color: AppColors.blue800,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Simple & Transparent Process',
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
                    'Getting started with Mirabella is easy. Follow our proven 6-step process to professional property management',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subSize,
                      height: 1.45,
                      color: const Color(0xFF4B5563), // gray-600
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---- CTAs (wire to Contact) ----
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.flag_rounded),
                      label: const Text('Get Started'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () =>
                          (onGetStarted ?? () => _fallback(context))(),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.support_agent_rounded),
                      label: const Text('Free Consultation'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.blue600,
                          width: 2,
                        ),
                        foregroundColor: AppColors.blue600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          (onGetStarted ?? () => _fallback(context))(),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ---- Grid ----
                LayoutBuilder(
                  builder: (context, c) {
                    int cross = 1;
                    if (c.maxWidth >= 1100) {
                      cross = 3;
                    } else if (c.maxWidth >= 760) {
                      cross = 2;
                    }

                    // Give more height on phones so long descriptions never overflow.
                    final double cardHeight = switch (cross) {
                      3 => 210, // desktop
                      2 => 230, // tablet
                      _ => 270, // phone (extra room)
                    };

                    // Add a tiny headroom for the floating step badge (which sits slightly outside).
                    final double mainExtent = cardHeight + 12;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: processData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cross,
                        mainAxisExtent: mainExtent,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, i) {
                        final step = processData[i];
                        final icon = icons[i % icons.length];
                        return _ProcessCard(
                          stepNumber: step.step,
                          title: step.title,
                          description: step.description,
                          icon: icon,
                        );
                      },
                    );
                  },
                ),

                // Optional: extra CTA at bottom (same callback)
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () => (onGetStarted ?? () => _fallback(context))(),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Start Now — Talk to an Expert'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProcessCard extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String description;
  final IconData icon;

  const _ProcessCard({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Use a Stack so the step badge can float without clipping.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
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
                // Icon badge
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE), // blue-100
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(icon, color: AppColors.blue600, size: 26),
                ),
                const SizedBox(height: 12),

                // Title (safe wrapping)
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gray900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),

                // Description fills remaining height
                Expanded(
                  child: Text(
                    description,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280), // gray-500/600
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Step badge (top-left) with light negative offset
        Positioned(
          top: -8,
          left: -8,
          child: Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.blueBr,
            ),
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
