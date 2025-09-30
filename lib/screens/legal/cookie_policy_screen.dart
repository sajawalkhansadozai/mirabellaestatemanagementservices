// ===============================
// File: lib/screens/legal/cookie_policy.dart
// Cookie Policy (SEO-friendly, responsive)
// ===============================
import 'package:flutter/material.dart';
import '../../constants/tokens.dart';

class CookiePolicyPage extends StatelessWidget {
  const CookiePolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final titleSize = w > 900 ? 40.0 : (w > 600 ? 34.0 : 28.0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header band
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(gradient: AppGradients.blue),
                padding: const EdgeInsets.fromLTRB(16, 36, 16, 36),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cookie Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: titleSize,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'How and why Mirabella uses cookies and similar technologies.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Last updated: September 2025',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 28,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Section(
                          title: 'What Are Cookies?',
                          body:
                              'Cookies are small text files stored on your device by your browser. They help websites function properly, remember preferences, and understand performance.',
                        ),
                        Section(
                          title: 'Types of Cookies We Use',
                          bullets: [
                            'Essential cookies — required for core features and security.',
                            'Performance cookies — help us measure and improve site performance.',
                            'Functionality cookies — remember your choices and preferences.',
                            'Analytics cookies — provide aggregated insights on how the site is used.',
                            'Advertising/retargeting cookies — show relevant ads (used only if applicable and subject to your consent).',
                          ],
                        ),
                        Section(
                          title: 'How We Use Cookies',
                          bullets: [
                            'Maintain session security and prevent abuse.',
                            'Remember preferences (e.g., language, forms).',
                            'Analyze traffic to improve content and user experience.',
                            'Measure marketing effectiveness and website performance.',
                          ],
                          footer:
                              'Some cookies are set by third parties (e.g., analytics providers). We do not control their cookies; please review their policies.',
                        ),
                        Section(
                          title: 'Managing Cookies',
                          body:
                              'You can control cookies through your browser settings. Most browsers allow you to block or delete cookies. Blocking some cookies may affect site functionality. Where required, we request consent for non-essential cookies.',
                        ),
                        Section(
                          title: 'Do Not Track',
                          body:
                              'Some browsers offer a “Do Not Track” (DNT) signal. Because there is no common standard, we do not respond to DNT at this time. We continue to review developments and may update this policy accordingly.',
                        ),
                        Section(
                          title: 'Updates to This Policy',
                          body:
                              'We may change this Cookie Policy from time to time. Any changes will be posted here with an updated “Last updated” date.',
                        ),
                        Section(
                          title: 'Contact Us',
                          bullets: [
                            'Email: ${AppMeta.email}',
                            'Phone: ${AppMeta.phone}',
                          ],
                          body:
                              'If you have questions about our use of cookies or your choices, get in touch.',
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
    );
  }
}

// ---- Shared section widgets (same as above) ----
class Section extends StatelessWidget {
  final String title;
  final String? body;
  final List<String>? bullets;
  final String? footer;

  const Section({
    super.key,
    required this.title,
    this.body,
    this.bullets,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      color: AppColors.gray900,
      fontWeight: FontWeight.w800,
    );
    const bodyStyle = TextStyle(
      fontSize: 15,
      height: 1.55,
      color: Color(0xFF374151),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          if (body != null) ...[
            const SizedBox(height: 8),
            Text(body!, style: bodyStyle),
          ],
          if (bullets != null && bullets!.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...bullets!.map((t) => _Bullet(text: t)).toList(),
          ],
          if (footer != null) ...[
            const SizedBox(height: 8),
            Text(footer!, style: bodyStyle),
          ],
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 15,
      height: 1.55,
      color: Color(0xFF374151),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 6, color: AppColors.blue600),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}
