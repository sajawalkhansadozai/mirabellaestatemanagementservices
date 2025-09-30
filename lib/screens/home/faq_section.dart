// ===============================
// File: lib/screens/home/faq_section.dart
// FAQ accordion (ExpansionTiles) + responsive header
// Fully responsive + overflow-proof
// ===============================
import 'package:flutter/material.dart';

import '../../constants/tokens.dart';
import '../../data/data.dart';

class FAQSection extends StatelessWidget {
  const FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);

    // Responsive title sizes
    final double titleSize = w > 900 ? 34 : (w > 600 ? 30 : 26);
    final double subtitleSize = w > 600 ? 18 : 16;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
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
                  'FAQ',
                  style: TextStyle(
                    color: AppColors.blue800,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Frequently Asked Questions',
                textScaler: scaler,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.gray900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Everything you need to know about our property management services',
                  textScaler: scaler,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: subtitleSize,
                    height: 1.45,
                    color: const Color(0xFF4B5563), // gray-600
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ---- Accordion ----
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: faqsData.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final item = faqsData[i];
                  return _FaqTile(question: item.question, answer: item.answer);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> with TickerProviderStateMixin {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias, // ensure ripples/ink don't overflow radius
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.soft,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashFactory: InkRipple.splashFactory,
          ),
          child: ExpansionTile(
            // Keep alignments tidy on wrap
            expandedAlignment: Alignment.centerLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            maintainState: true,
            initiallyExpanded: _open,
            onExpansionChanged: (v) => setState(() => _open = v),

            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            childrenPadding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),

            trailing: AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: _open ? 0.5 : 0.0,
              child: const Icon(
                Icons.expand_more_rounded,
                color: AppColors.blue600,
              ),
            ),

            // Multi-line, wrapping question text (no overflow on small screens)
            title: Text(
              widget.question,
              textScaler: scaler,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
                fontSize: 16,
                height: 1.35,
              ),
            ),

            children: [
              // Multi-line, wrapping answer text
              Text(
                widget.answer,
                textScaler: scaler,
                softWrap: true,
                style: const TextStyle(
                  color: Color(0xFF4B5563), // gray-600
                  height: 1.6,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
