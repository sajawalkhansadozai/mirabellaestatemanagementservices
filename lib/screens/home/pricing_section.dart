// ===============================
// File: lib/screens/home/pricing_section.dart
// Pricing plans (3 cards) + CTA (responsive + overflow-proof)
// ===============================
import 'package:flutter/material.dart';

import '../../constants/tokens.dart';
import '../../data/data.dart';

class PricingSection extends StatelessWidget {
  const PricingSection({super.key, this.onGetStarted});

  /// HomeScreen se aane wala callback (Contact section tak scroll)
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

    // Clamp text scale so huge accessibility sizes don't break layout.
    final clampedMQ = mq.copyWith(
      textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
    );

    // Responsive heading sizes
    final titleSize = w >= 1100 ? 34.0 : (w >= 700 ? 30.0 : 26.0);
    final subSize = w >= 700 ? 18.0 : 16.0;

    return MediaQuery(
      data: clampedMQ,
      child: Container(
        color: AppColors.white,
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
                    'Transparent Pricing',
                    style: TextStyle(
                      color: AppColors.blue800,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose Your Management Plan',
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
                    'Flexible pricing plans designed to fit your property management needs. No hidden fees, ever.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subSize,
                      height: 1.45,
                      color: const Color(0xFF4B5563), // gray-600
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ---- Grid ----
                LayoutBuilder(
                  builder: (context, c) {
                    // Columns
                    int cross = 1;
                    if (c.maxWidth >= 1100) {
                      cross = 3;
                    } else if (c.maxWidth >= 780) {
                      cross = 2;
                    }

                    // Card heights tuned per layout to avoid overflow of features
                    final double cardHeight = switch (cross) {
                      3 => 440, // desktop
                      2 => 480, // tablet
                      _ => 540, // phone (give more room)
                    };

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pricingPlansData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cross,
                        mainAxisExtent: cardHeight,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                      ),
                      itemBuilder: (context, i) {
                        final p = pricingPlansData[i];
                        return _PricingCard(
                          plan: p,
                          onGetStarted:
                              onGetStarted ?? () => _fallback(context),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Footer CTA under grid
                Column(
                  children: [
                    Text(
                      'Need a custom plan for multiple properties or special requirements?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: onGetStarted ?? () => _fallback(context),
                      child: const Text(
                        'Contact us for enterprise solutions →',
                        style: TextStyle(
                          color: AppColors.blue600,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final dynamic plan; // PricingPlan
  final VoidCallback onGetStarted;

  const _PricingCard({required this.plan, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final bool popular = plan.popular as bool;

    final card = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: popular
              ? AppColors.blue600
              : const Color(0xFFE5E7EB), // gray-200
          width: popular ? 4 : 2,
        ),
        boxShadow: popular ? AppShadows.medium : AppShadows.soft,
      ),
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
      child: Column(
        children: [
          // Popular ribbon
          if (popular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                gradient: AppGradients.blue,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Most Popular',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

          // Title + description + price
          Text(
            plan.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            plan.description,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.price,
                style: const TextStyle(
                  color: AppColors.blue600,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            plan.period,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Features (fills the available space in the card)
          Expanded(
            child: ListView.separated(
              itemCount: (plan.features as List).length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final String feature = plan.features[i];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: _FeatureText()),
                  ],
                ).withFeatureText(feature);
              },
            ),
          ),
          const SizedBox(height: 14),

          // CTA
          SizedBox(
            width: double.infinity,
            child: popular
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 10,
                    ),
                    onPressed: onGetStarted, // scroll to Contact
                    child: const Text('Get Started'),
                  )
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.blue600,
                        width: 2,
                      ),
                      foregroundColor: AppColors.blue600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onGetStarted, // scroll to Contact
                    child: const Text('Get Started'),
                  ),
          ),
        ],
      ),
    );

    return AnimatedScale(
      scale: popular ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: card,
    );
  }
}

/// Helper to inject dynamic feature text without rebuilding Row signature
class _FeatureText extends StatelessWidget {
  final String? text;
  const _FeatureText({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.35),
    );
  }
}

extension _FeatureRowExt on Widget {
  Widget withFeatureText(String text) {
    if (this is Row) {
      final row = this as Row;
      final children = row.children.map((w) {
        if (w is Expanded && w.child is _FeatureText) {
          return Expanded(child: _FeatureText(text: text));
        }
        return w;
      }).toList();
      return Row(
        crossAxisAlignment: row.crossAxisAlignment,
        mainAxisAlignment: row.mainAxisAlignment,
        children: children,
      );
    }
    return this;
  }
}
