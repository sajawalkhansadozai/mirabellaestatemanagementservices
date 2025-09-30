// ===============================
// File: lib/screens/home/home_screen.dart
// Master scaffold + navigation + section anchors
// Mobile-first + overflow-proof
// ===============================
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/tokens.dart';
import '../../widgets/header_nav.dart';
import '../../widgets/footer.dart';

// Sections
import 'hero_section.dart';
import 'stats_strip.dart';
import 'services_section.dart';
import 'process_section.dart';
import 'pricing_section.dart';
import 'faq_section.dart';
import 'about_section.dart';
import 'contact_section.dart';
import 'newsletter_strip.dart';
import 'why_us_section.dart';

// Legal pages (ensure these exist)
import 'package:mirabellaestatemanagementservices/screens/legal/privacy_policy_screen.dart';
import 'package:mirabellaestatemanagementservices/screens/legal/terms_screen.dart';
import 'package:mirabellaestatemanagementservices/screens/legal/cookie_policy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scroll = ScrollController();

  // Anchor keys
  final _homeKey = GlobalKey();
  final _servicesKey = GlobalKey();
  final _processKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _aboutKey = GlobalKey();

  bool _mobileMenuOpen = false;

  void _scrollTo(String id) {
    final map = <String, GlobalKey>{
      'home': _homeKey,
      'services': _servicesKey,
      'process': _processKey,
      'pricing': _pricingKey,
      'contact': _contactKey,
      'about': _aboutKey,
    };
    final key = map[id];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.08, // sticky header offset
      );
    }
    setState(() => _mobileMenuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final isMobile = width < 900;

    // Clamp text scaling globally on this screen to prevent overflow
    final clampedMQ = mq.copyWith(
      textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
    );

    final bottomPad = 16.0 + mq.padding.bottom; // FABs avoid gesture area

    return MediaQuery(
      data: clampedMQ,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              // protect under status bar + notches
              top: true,
              bottom: false,
              child: CustomScrollView(
                controller: _scroll,
                slivers: [
                  const SliverToBoxAdapter(child: _TopBar()),
                  SliverToBoxAdapter(
                    child: HeaderNav(
                      onTapItem: _scrollTo,
                      onToggleMenu: () =>
                          setState(() => _mobileMenuOpen = !_mobileMenuOpen),
                      isMobile: isMobile,
                      mobileOpen: _mobileMenuOpen,
                    ),
                  ),
                  if (_mobileMenuOpen && isMobile)
                    SliverToBoxAdapter(child: _MobileMenu(onTap: _scrollTo)),

                  // Sections
                  SliverToBoxAdapter(
                    child: HeroSection(
                      key: _homeKey,
                      onPrimaryPressed: () => _scrollTo('contact'), // Contact
                      onSecondaryPressed: () =>
                          _scrollTo('services'), // Services
                    ),
                  ),
                  const SliverToBoxAdapter(child: StatsStrip()),
                  SliverToBoxAdapter(child: ServicesSection(key: _servicesKey)),
                  const SliverToBoxAdapter(child: WhyUsSection()),
                  SliverToBoxAdapter(
                    child: ProcessSection(
                      key: _processKey,
                      onGetStarted: () => _scrollTo('contact'), // → Contact
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: PricingSection(
                      key: _pricingKey,
                      onGetStarted: () => _scrollTo('contact'), // → Contact
                    ),
                  ),
                  const SliverToBoxAdapter(child: FAQSection()),
                  SliverToBoxAdapter(child: AboutSection(key: _aboutKey)),
                  SliverToBoxAdapter(child: ContactSection(key: _contactKey)),
                  const SliverToBoxAdapter(child: NewsletterStrip()),

                  // Footer with in-page scroll + legal navigation
                  SliverToBoxAdapter(
                    child: SiteFooter(
                      onTapItem: _scrollTo,
                      onOpenPrivacy: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      ),
                      onOpenTerms: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TermsOfServicePage(),
                        ),
                      ),
                      onOpenCookie: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CookiePolicyPage(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Floating WhatsApp
            Positioned(
              right: 16,
              bottom: bottomPad,
              child: _CircleFab(
                color: Colors.green,
                icon: Icons.forum_rounded,
                onTap: () => launchUrlString(
                  'https://wa.me/923300492037',
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ),
            // Scroll-to-top
            Positioned(
              left: 16,
              bottom: bottomPad,
              child: _CircleFab(
                color: AppColors.blue600,
                icon: Icons.arrow_upward_rounded,
                onTap: () => _scroll.animateTo(
                  0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleFab extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final IconData icon;
  const _CircleFab({
    required this.onTap,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 8,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.blue),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const _TopBarRow(),
    );
  }
}

class _TopBarRow extends StatelessWidget {
  const _TopBarRow();

  @override
  Widget build(BuildContext context) {
    // Use Flexible + ellipsis so long strings never overflow on small phones
    return Row(
      children: const [
        Flexible(
          child: _TopBarItem(icon: Icons.phone_rounded, text: AppMeta.phone),
        ),
        SizedBox(width: 12),
        Flexible(
          child: _TopBarItem(
            icon: Icons.mail_outline_rounded,
            text: AppMeta.email,
          ),
        ),
        Spacer(),
        Flexible(
          child: Text(
            AppMeta.officeHours,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _TopBarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TopBarItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // keep it compact
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final void Function(String id) onTap;
  const _MobileMenu({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = const [
      ['Home', 'home'],
      ['Services', 'services'],
      ['Process', 'process'],
      ['Pricing', 'pricing'],
      ['Contact', 'contact'],
    ];

    // Make the menu scrollable if content exceeds viewport height
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 360),
        child: ListView(
          shrinkWrap: true,
          children: items.map((e) {
            return ListTile(
              title: Text(e[0]),
              onTap: () => onTap(e[1]),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
            );
          }).toList(),
        ),
      ),
    );
  }
}
