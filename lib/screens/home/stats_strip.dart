// ===============================
// File: lib/screens/home/stats_strip.dart
// Blue gradient KPIs strip (4 items) — fully responsive (no overflows)
// ===============================
import 'package:flutter/material.dart';
import '../../constants/tokens.dart';
import '../../data/data.dart';

class StatsStrip extends StatelessWidget {
  const StatsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = <IconData>[
      Icons.apartment_rounded,
      Icons.people_alt_rounded,
      Icons.workspace_premium_rounded,
      Icons.star_rate_rounded,
    ];

    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.blue),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              const gap = 16.0;

              // Breakpoints: 4 cols (desktop), 2 cols (tablet), 1 col (mobile)
              final cols = w >= 1100 ? 4 : (w >= 740 ? 2 : 1);
              final cardW = (w - (cols - 1) * gap) / cols;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                alignment: WrapAlignment.center,
                children: List.generate(statsData.length, (i) {
                  final item = statsData[i];
                  final icon = icons[i % icons.length];

                  return SizedBox(
                    width: cardW,
                    child: _StatTile(
                      icon: icon,
                      number: item.number,
                      label: item.label,
                      subtext: item.subtext,
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String number;
  final String label;
  final String subtext;

  const _StatTile({
    required this.icon,
    required this.number,
    required this.label,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        // Room for multi-line subtext on small screens
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min, // <- key to avoid overflow
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 10),
            Text(
              number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtext,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2, // safety on narrow widths
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
