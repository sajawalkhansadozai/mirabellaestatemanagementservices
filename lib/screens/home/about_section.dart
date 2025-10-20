// ===============================
// File: lib/screens/home/about_section.dart
// Dark "About Mirabella" split layout (fully responsive + overflow-proof)
// ===============================
import 'package:flutter/material.dart';
import '../../constants/tokens.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final textScaler = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: 1.2);

    // Responsive typography
    final double titleSize = w >= 1200
        ? 38
        : (w >= 950 ? 34 : (w >= 700 ? 30 : 26));
    final double bodySize = w >= 700 ? 16 : 15;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF1F2937)], // gray-900 → gray-800
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: w < 360 ? 36 : 48, // a bit tighter on very small phones
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, c) {
              final twoCol = c.maxWidth >= 950;

              // Right-side collage image heights (clamped for safety)
              final double collageH = twoCol ? 240 : (w * 0.42).clamp(180, 260);

              return Flex(
                direction: twoCol ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: twoCol
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  // LEFT: Copy/content
                  SizedBox(
                    width: twoCol ? c.maxWidth * 0.52 : c.maxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue600,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'About Mirabella',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Heading
                        Text(
                          'Your Trusted Partner in Real Estate Management',
                          textScaler: textScaler,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleSize,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Paragraphs
                        Text(
                          'Established in 2015, MEMS has grown to become Islamabad\'s most trusted property management company. With over a decade of experience, we\'ve successfully managed hundreds of properties and served thousands of satisfied clients.',
                          textScaler: textScaler,
                          style: TextStyle(
                            color: const Color(0xFF9CA3AF), // gray-400
                            fontSize: bodySize,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Our mission is simple: to provide property owners with peace of mind through professional, transparent, and efficient management services. We combine local market expertise with modern technology to deliver exceptional results.',
                          textScaler: textScaler,
                          style: TextStyle(
                            color: const Color(0xFF9CA3AF),
                            fontSize: bodySize,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Feature tiles (wrap safely on small widths)
                        _FeatureGrid(),
                      ],
                    ),
                  ),

                  SizedBox(height: twoCol ? 0 : 28, width: twoCol ? 28 : 0),

                  // RIGHT: Image collage + floating card (falls back on mobile)
                  SizedBox(
                    width: twoCol ? c.maxWidth * 0.44 : c.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 28,
                      ), // space for the float
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            children: [
                              _CollageImage(
                                url:
                                    'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800',
                                height: collageH,
                              ),
                              const SizedBox(height: 12),
                              _CollageImage(
                                url:
                                    'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800',
                                height: collageH,
                              ),
                            ],
                          ),

                          // Floating stat card: overlay on wide, inline on mobile
                          if (twoCol)
                            Positioned(
                              right: 16,
                              bottom: -16,
                              left: 16,
                              child: const _StatCard(),
                            )
                          else
                            const Positioned(
                              left: 0,
                              right: 0,
                              bottom: -8,
                              child:
                                  _StatCard(), // still has padding to avoid clash
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

class _FeatureGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        // Decide columns responsively (2 on medium/wide, 1 on narrow)
        final double maxW = c.maxWidth;
        final int cols = maxW >= 520 ? 2 : 1;
        const double gap = 12;
        final double tileW = cols == 2
            ? (maxW - gap) / 2
            : maxW; // exact widths to prevent wrap jitter

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            SizedBox(
              width: tileW,
              child: const _MiniFeatureTile(
                icon: Icons.verified_user_rounded,
                title: 'Professional Team',
                subtitle: 'Licensed experts dedicated to your success',
              ),
            ),
            SizedBox(
              width: tileW,
              child: const _MiniFeatureTile(
                icon: Icons.public_rounded,
                title: 'Wide Coverage',
                subtitle: 'Serving all major areas in twin cities',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CollageImage extends StatelessWidget {
  final String url;
  final double height;
  const _CollageImage({required this.url, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, evt) {
          if (evt == null) return child;
          return Container(
            height: height,
            color: const Color(0xFF0F172A), // slate-900-ish
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        },
        errorBuilder: (ctx, err, st) => Container(
          height: height,
          color: const Color(0xFF0F172A),
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.white70,
            size: 32,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 14,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _StatItem(value: '500+', label: 'Properties Managed'),
            _DividerDot(),
            _StatItem(value: '4.8/5', label: 'Average Rating'),
            _DividerDot(),
            _StatItem(value: '10+ yrs', label: 'Experience'),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);
    return Flexible(
      fit: FlexFit.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            textScaler: scaler,
            style: const TextStyle(
              color: AppColors.blue600,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textScaler: scaler,
            style: const TextStyle(
              color: Color(0xFF374151), // gray-700
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerDot extends StatelessWidget {
  const _DividerDot();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Icon(Icons.fiber_manual_record, size: 6, color: Color(0xFF94A3B8)),
    );
  }
}

class _MiniFeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MiniFeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937), // gray-800
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.blue600, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            textScaler: scaler,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textScaler: scaler,
            style: const TextStyle(
              color: Color(0xFF9CA3AF), // gray-400
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
