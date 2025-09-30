// ===============================
// File: lib/widgets/footer.dart
// Dark footer with brand, quick links, services, contact, and bottom bar
// Now supports: onTapItem (scroll) + legal page navigation (callbacks or routes)
// ===============================
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../constants/tokens.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({
    super.key,
    this.onTapItem, // e.g., (id) => _scrollTo(id)
    this.onOpenPrivacy, // e.g., () => Navigator.push(...PrivacyPolicyPage())
    this.onOpenTerms, // e.g., () => Navigator.push(...TermsOfServicePage())
    this.onOpenCookie, // e.g., () => Navigator.push(...CookiePolicyPage())
  });

  /// Called for in-page anchors: 'home' | 'services' | 'pricing' | 'contact'
  final void Function(String id)? onTapItem;

  /// Legal page openers (Navigator callbacks)
  final VoidCallback? onOpenPrivacy;
  final VoidCallback? onOpenTerms;
  final VoidCallback? onOpenCookie;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1220), // near gray-950
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // ----- Top area (responsive wrap; no overflow) -----
              LayoutBuilder(
                builder: (context, c) {
                  final gap = 20.0;
                  int cols = 1;
                  if (c.maxWidth >= 1100) {
                    cols = 4;
                  } else if (c.maxWidth >= 800) {
                    cols = 3;
                  } else if (c.maxWidth >= 600) {
                    cols = 2;
                  }
                  final itemWidth = (c.maxWidth - (cols - 1) * gap) / cols;

                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      SizedBox(width: itemWidth, child: const _BrandBlock()),
                      SizedBox(
                        width: itemWidth,
                        child: _QuickLinksBlock(onTapItem: onTapItem),
                      ),
                      SizedBox(width: itemWidth, child: const _ServicesBlock()),
                      SizedBox(width: itemWidth, child: const _ContactBlock()),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),
              const Divider(color: Color(0xFF1F2A44), height: 1),

              // ----- Middle contact rows (address/phone/email) -----
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final isWide = c.maxWidth >= 900;
                    final children = const [
                      _InfoRow(
                        icon: Icons.location_on_rounded,
                        title: 'Address',
                        text:
                            'E-18 Gulshan Sehat Mirabella Complex\nIslamabad, Pakistan',
                      ),
                      _InfoRow(
                        icon: Icons.phone_rounded,
                        title: 'Phone',
                        text: '+923300492037',
                      ),
                      _InfoRow(
                        icon: Icons.mail_outline_rounded,
                        title: 'Email',
                        text: 'info@mirabellaestatemanagementservices.com',
                      ),
                    ];

                    if (isWide) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children
                            .map(
                              (w) => Flexible(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 420,
                                  ),
                                  child: w,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }

                    // Mobile: wrap so nothing overflows
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: children
                          .map(
                            (w) => ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: w,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),

              const Divider(color: Color(0xFF1F2A44), height: 1),
              const SizedBox(height: 18),

              // ----- Bottom bar (wrap on mobile) -----
              LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 800;
                  final legal = Wrap(
                    spacing: 18,
                    runSpacing: 8,
                    children: [
                      _legalLink(
                        context,
                        label: 'Privacy Policy',
                        onTap: onOpenPrivacy,
                        fallbackRoute: '/privacy-policy',
                      ),
                      _legalLink(
                        context,
                        label: 'Terms of Service',
                        onTap: onOpenTerms,
                        fallbackRoute: '/terms-of-service',
                      ),
                      _legalLink(
                        context,
                        label: 'Cookie Policy',
                        onTap: onOpenCookie,
                        fallbackRoute: '/cookie-policy',
                      ),
                    ],
                  );

                  final copy = const Text(
                    '© 2025 Mirabella Estate Management Services. All rights reserved.',
                    style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 12),
                  );

                  if (isWide) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: copy),
                        const SizedBox(width: 10),
                        legal,
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [copy, const SizedBox(height: 10), legal],
                  );
                },
              ),

              const SizedBox(height: 10),
              const Text(
                'Licensed Real Estate Management Company',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF606B85), fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Prefers Navigator callbacks; otherwise tries named route; finally falls back to launching a URL (web).
  static Widget _legalLink(
    BuildContext context, {
    required String label,
    required VoidCallback? onTap,
    required String fallbackRoute,
  }) {
    return InkWell(
      onTap: () async {
        if (onTap != null) {
          onTap();
          return;
        }
        // Try pushNamed (Flutter routes)
        try {
          await Navigator.of(context).pushNamed(fallbackRoute);
          return;
        } catch (_) {
          // No named route available — fall back to opening as URL (Flutter web)
          final ok = await launchUrlString(
            fallbackRoute,
            mode: LaunchMode.externalApplication,
          );
          if (!ok) {
            // swallow silently to avoid crashes in release
          }
        }
      },
      child: const Text(
        // style applied below to keep const above? (we want dynamic label)
        '',
      ),
    );
  }
}

// We need the label text styled; build with a separate widget to keep above logic clean.
// ignore: unused_element
class _LegalLinkText extends StatelessWidget {
  final String label;
  const _LegalLinkText(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: AppColors.blue400,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo area (kept as icon; swap with Image.asset if desired)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.blueBr,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.apartment_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mirabella',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Estate Management Services',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Color(0xFF8A94AE)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Professional property management services in Islamabad and Rawalpindi. '
          'We help property owners maximize returns while minimizing stress through expert management solutions.',
          style: TextStyle(color: Color(0xFFA0AEC0), height: 1.5),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

class _QuickLinksBlock extends StatelessWidget {
  const _QuickLinksBlock({this.onTapItem});
  final void Function(String id)? onTapItem;

  @override
  Widget build(BuildContext context) {
    return _LinkListBlock(
      title: 'Quick Links',
      items: [
        _LinkItem(text: 'Home', onTap: () => onTapItem?.call('home')),
        _LinkItem(text: 'Services', onTap: () => onTapItem?.call('services')),
        _LinkItem(text: 'Pricing', onTap: () => onTapItem?.call('pricing')),
        _LinkItem(text: 'Contact', onTap: () => onTapItem?.call('contact')),
      ],
    );
  }
}

class _ServicesBlock extends StatelessWidget {
  const _ServicesBlock();

  @override
  Widget build(BuildContext context) {
    final items = [
      'Property Management',
      'Rental Services',
      'Maintenance',
      'Tenant Relations',
      'Financial Management',
      'Legal Services',
    ];
    return _LinkListBlock(
      title: 'Our Services',
      items: items.map((t) => _LinkItem(text: t, onTap: () {})).toList(),
    );
  }
}

class _LinkListBlock extends StatelessWidget {
  final String title;
  final List<_LinkItem> items;
  const _LinkListBlock({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            ...items.map((it) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: InkWell(
                  onTap: it.onTap,
                  child: Text(
                    it.text,
                    softWrap: true,
                    style: const TextStyle(
                      color: Color(0xFFA0AEC0),
                      height: 1.3,
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _LinkItem {
  final String text;
  final VoidCallback onTap;
  _LinkItem({required this.text, required this.onTap});
}

class _ContactBlock extends StatelessWidget {
  const _ContactBlock();

  @override
  Widget build(BuildContext context) {
    const linkStyle = TextStyle(
      color: AppColors.blue400,
      fontWeight: FontWeight.w700,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        _contactRow(
          icon: Icons.place_rounded,
          child: const Text(
            'E-18 Gulshan Sehat Mirabella Complex\nIslamabad, Pakistan',
            style: TextStyle(color: Color(0xFFA0AEC0), height: 1.5),
          ),
        ),
        const SizedBox(height: 8),
        _contactRow(
          icon: Icons.phone_rounded,
          child: Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              InkWell(
                onTap: () => launchUrlString('tel:+923300492037'),
                child: const Text('+923300492037', style: linkStyle),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _contactRow(
          icon: Icons.mail_outline_rounded,
          child: Wrap(
            spacing: 10,
            runSpacing: 4,
            children: const [
              InkWell(
                child: Text(
                  'info@mirabellaestatemanagementservices.com',
                  style: linkStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _contactRow({required IconData icon, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.blue400, size: 20),
        const SizedBox(width: 8),
        Expanded(child: child),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _InfoRow({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.blue400, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          text,
          softWrap: true,
          style: const TextStyle(
            color: Color(0xFFB8C2DC),
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
