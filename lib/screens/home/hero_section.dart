// ===============================
// File: lib/screens/home/hero_section.dart
// Hero: headline, CTAs, KPIs, hero image with ROI card (responsive/overflow-proof)
// ===============================
import 'package:flutter/material.dart';
import '../../constants/tokens.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  /// Get Free Consultation
  final VoidCallback? onPrimaryPressed;

  /// Explore Services
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final isVerySmall = w < 360;

    // Responsive sizes with gentle scaling on small screens
    final double titleSize = w >= 1100
        ? 46
        : (w >= 900
              ? 42
              : (w >= 700
                    ? 36
                    : (w >= 500
                          ? 32
                          : 28))); // stays readable on very small phones
    final double bodySize = w >= 700 ? 18 : 16;

    return Container(
      color: AppColors.slate50,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isVerySmall
            ? 28
            : 40, // trim vertical padding on tiny screens
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, c) {
              final isTwoCol = c.maxWidth > 900;

              // Keep image height in a safe, clamped range for all widths
              final double heroImgHeight = (isTwoCol ? 360.0 : w * 0.45).clamp(
                200.0,
                380.0,
              );

              return Flex(
                direction: isTwoCol ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: isTwoCol
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: [
                  // LEFT: Text & CTAs
                  SizedBox(
                    width: isTwoCol ? c.maxWidth * 0.48 : c.maxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chip
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBEAFE), // blue-100
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.workspace_premium_rounded,
                                size: 16,
                                color: AppColors.blue800,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '#1 Estate Management in Islamabad',
                                style: TextStyle(
                                  color: AppColors.blue800,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Headline (use textScaler clamp to avoid huge scaling overflow)
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: titleSize,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.gray900,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Professional Property Management\n',
                              ),
                              TextSpan(
                                text: 'You Can Trust',
                                style: TextStyle(color: AppColors.blue800),
                              ),
                            ],
                          ),
                          textScaler: MediaQuery.textScalerOf(
                            context,
                          ).clamp(maxScaleFactor: 1.2),
                        ),
                        const SizedBox(height: 12),

                        // Subhead
                        Text(
                          'Comprehensive estate management services tailored to protect and maximize your real estate investments. '
                          'From tenant screening to maintenance, we handle everything so you don’t have to.',
                          style: TextStyle(
                            fontSize: bodySize,
                            height: 1.5,
                            color: const Color(0xFF4B5563), // gray-600
                          ),
                          textScaler: MediaQuery.textScalerOf(
                            context,
                          ).clamp(maxScaleFactor: 1.2),
                        ),
                        const SizedBox(height: 18),

                        // CTAs (auto-wrap on narrow)
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 180),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.arrow_forward_rounded),
                                label: const Text('Get Free Consultation'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  backgroundColor: AppColors.blue600,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 6,
                                ),
                                onPressed:
                                    onPrimaryPressed ??
                                    () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'We’ll contact you within 24 hours.',
                                          ),
                                        ),
                                      );
                                    },
                              ),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 170),
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.chevron_right_rounded),
                                label: const Text('Explore Services'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  side: const BorderSide(
                                    color: AppColors.blue600,
                                    width: 2,
                                  ),
                                  foregroundColor: AppColors.blue600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed:
                                    onSecondaryPressed ??
                                    () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Navigate to Services'),
                                        ),
                                      );
                                    },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // KPIs (responsive: row on wide, wrap on narrow)
                        const _KpisRow(),
                      ],
                    ),
                  ),

                  SizedBox(height: isTwoCol ? 0 : 28, width: isTwoCol ? 28 : 0),

                  // RIGHT: Image + overlay card
                  SizedBox(
                    width: isTwoCol ? c.maxWidth * 0.45 : c.maxWidth,
                    // Reserve space so overlay never collides with next section
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // soft rotated gradient blob behind
                          Transform.rotate(
                            angle: 0.10, // ~6 degrees
                            child: Container(
                              height: heroImgHeight,
                              decoration: BoxDecoration(
                                gradient: AppGradients.blueBr,
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                          ),
                          // main image (resilient to errors)
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=1200',
                                  fit: BoxFit.cover,
                                  height: heroImgHeight,
                                  loadingBuilder: (ctx, child, evt) {
                                    if (evt == null) return child;
                                    return Container(
                                      height: heroImgHeight,
                                      color: AppColors.slate100,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                  errorBuilder: (ctx, err, st) => Container(
                                    height: heroImgHeight,
                                    color: AppColors.slate100,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: AppColors.gray900,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // ROI overlay card
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom:
                                -14, // slightly smaller offset for tiny screens
                            child: Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    _RoiText(
                                      title: 'Average ROI Increase',
                                      value: '+25%',
                                    ),
                                    Icon(
                                      Icons.trending_up_rounded,
                                      color: Colors.green,
                                      size: 44,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _KpisRow extends StatelessWidget {
  const _KpisRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final compact = c.maxWidth < 420; // very small widths
        final items = const [
          _KpiItem(number: '500+', label: 'Properties'),
          _KpiItem(number: '1000+', label: 'Clients'),
          _KpiItem(number: '10+', label: 'Years'),
        ];

        if (!compact) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items
                .map((e) => Expanded(child: Center(child: e)))
                .toList(growable: false),
          );
        }

        // Compact: wrap to avoid overflow
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items
              .map(
                (e) => SizedBox(
                  width: (c.maxWidth - 12) / 2, // ~2 per line
                  child: Center(child: e),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _KpiItem extends StatelessWidget {
  final String number;
  final String label;
  const _KpiItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.blue600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280), // gray-500
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RoiText extends StatelessWidget {
  final String title;
  final String value;
  const _RoiText({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textScaler: MediaQuery.textScalerOf(
            context,
          ).clamp(maxScaleFactor: 1.2),
          style: const TextStyle(
            color: Color(0xFF6B7280), // gray-500
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textScaler: MediaQuery.textScalerOf(
            context,
          ).clamp(maxScaleFactor: 1.2),
          style: const TextStyle(
            color: AppColors.blue600,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
