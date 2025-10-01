// ===============================
// File: lib/screens/home/hero_section.dart
// Hero: Commercial Plots Ad - Gulshan-e-Sehat E-18
// ===============================
import 'package:flutter/material.dart';
import '../../constants/tokens.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  /// Book Your Plot Now
  final VoidCallback? onPrimaryPressed;

  /// Payment Plans
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
                            color: const Color(0xFFDCFCE7), // green-100
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
                                Icons.new_releases_rounded,
                                size: 16,
                                color: Color(0xFF166534), // green-800
                              ),
                              SizedBox(width: 8),
                              Text(
                                '🔥 NEW LAUNCH - Limited Plots Available',
                                style: TextStyle(
                                  color: Color(0xFF166534),
                                  fontWeight: FontWeight.w700,
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
                              TextSpan(text: 'Commercial Plots Launched\n'),
                              TextSpan(
                                text: 'Gulshan-e-Sehat E-18',
                                style: TextStyle(color: AppColors.blue600),
                              ),
                            ],
                          ),
                          textScaler: MediaQuery.textScalerOf(
                            context,
                          ).clamp(maxScaleFactor: 1.2),
                        ),
                        const SizedBox(height: 12),

                        // Subhead - Info Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7), // amber-100
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFF59E0B), // amber-500
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF92400E),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Prime Location: Gulshan-e-Sehat E-18, Islamabad',
                                      style: TextStyle(
                                        fontSize: bodySize - 2,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF92400E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.square_foot,
                                    color: Color(0xFF92400E),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Plot Size: 40\' × 70\' (2,800 sq ft)',
                                    style: TextStyle(
                                      fontSize: bodySize - 2,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF92400E),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.payments_rounded,
                                    color: Color(0xFF92400E),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Price: PKR 45,000,000',
                                    style: TextStyle(
                                      fontSize: bodySize + 2,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF92400E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                                icon: const Icon(Icons.call_rounded),
                                label: const Text('Book Your Plot Now'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  backgroundColor: const Color(
                                    0xFF059669,
                                  ), // green-600
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
                                            'Our team will contact you shortly!',
                                          ),
                                        ),
                                      );
                                    },
                              ),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 170),
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.info_outline_rounded),
                                label: const Text('Payment Plans'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF059669),
                                    width: 2,
                                  ),
                                  foregroundColor: const Color(0xFF059669),
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
                                          content: Text('View Payment Plans'),
                                        ),
                                      );
                                    },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Payment Plans Section
                        const _PaymentPlansRow(),
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
                                child: Image.asset(
                                  'assets/commercial_plot.png', // Your asset image
                                  fit: BoxFit.cover,
                                  height: heroImgHeight,
                                  errorBuilder: (ctx, err, st) => Container(
                                    height: heroImgHeight,
                                    color: AppColors.slate100,
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.villa_rounded,
                                          color: AppColors.blue600,
                                          size: 48,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Commercial Plot',
                                          style: TextStyle(
                                            color: AppColors.gray900,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
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
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF059669), // green-600
                                      Color(0xFF10B981), // green-500
                                    ],
                                  ),
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
                                      title: 'Flexible Payment Plans',
                                      value: 'Available',
                                      isWhiteText: true,
                                    ),
                                    Icon(
                                      Icons.payment_rounded,
                                      color: Colors.white,
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

class _PaymentPlansRow extends StatelessWidget {
  const _PaymentPlansRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💳 Payment Plans Available:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          _PaymentPlanItem(
            icon: Icons.looks_one_rounded,
            title: 'Plan 1',
            description: '50% advance, 50% within one month',
          ),
          const Divider(height: 20),
          _PaymentPlanItem(
            icon: Icons.looks_two_rounded,
            title: 'Plan 2',
            description: '6 installments, 2 quarterly payments',
          ),
          const Divider(height: 20),
          _PaymentPlanItem(
            icon: Icons.looks_3_rounded,
            title: 'Plan 3',
            description: '50% booking, 50% in 4 quarterly (PKR 5M each)',
          ),
          const SizedBox(height: 8),
          const Text(
            '* Terms and conditions apply',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentPlanItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PaymentPlanItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.blue600, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
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
  final bool isWhiteText;
  const _RoiText({
    required this.title,
    required this.value,
    this.isWhiteText = false,
  });

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
          style: TextStyle(
            color: isWhiteText
                ? Colors.white.withOpacity(0.9)
                : const Color(0xFF6B7280),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textScaler: MediaQuery.textScalerOf(
            context,
          ).clamp(maxScaleFactor: 1.2),
          style: TextStyle(
            color: isWhiteText ? Colors.white : AppColors.blue600,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
