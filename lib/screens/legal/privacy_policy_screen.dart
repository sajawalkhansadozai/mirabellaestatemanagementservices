// ===============================
// File: lib/screens/legal/privacy_policy.dart
// Privacy Policy (SEO-friendly, responsive)
// ===============================
import 'package:flutter/material.dart';
import '../../constants/tokens.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                          'Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: titleSize,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'How Mirabella Estate Management Services collects, uses, and protects your information.',
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
                          title: 'Introduction',
                          body:
                              'This Privacy Policy explains how Mirabella Estate Management Services ("Mirabella", "we", "us", or "our") handles personal information when you visit our website, contact us, or use our property management services in Islamabad and surrounding areas.',
                        ),
                        Section(
                          title: 'Information We Collect',
                          bullets: [
                            'Contact details such as name, email, and phone number.',
                            'Property and preference details you share with our team.',
                            'Usage data (pages viewed, actions taken) to improve the website.',
                            'Device and technical data such as browser type and IP address.',
                            'Cookie identifiers and similar tracking technologies (see Cookie Policy).',
                          ],
                          footer:
                              'We collect information directly from you, automatically when you use the site, and from trusted service providers (e.g., analytics).',
                        ),
                        Section(
                          title: 'How We Use Your Information',
                          bullets: [
                            'Provide, personalize, and improve our services.',
                            'Respond to enquiries and provide customer support.',
                            'Process applications, viewings, and tenancy administration.',
                            'Send service updates and relevant marketing (you can opt out anytime).',
                            'Conduct analytics, security monitoring, and fraud prevention.',
                            'Comply with legal, regulatory, and tax obligations.',
                          ],
                        ),
                        Section(
                          title: 'Legal Bases for Processing',
                          body:
                              'Where required by law, we rely on one or more of the following legal bases: consent, performance of a contract, compliance with legal obligations, and our legitimate interests in operating and improving our services.',
                        ),
                        Section(
                          title: 'Your Privacy Choices & Rights',
                          bullets: [
                            'Access, update, or correct your information.',
                            'Request deletion where applicable.',
                            'Object to or restrict certain processing activities.',
                            'Opt out of marketing at any time (unsubscribe link or contact us).',
                            'Manage cookies and analytics preferences (see Cookie Policy).',
                          ],
                          footer:
                              'To exercise your rights, please contact us using the details below. We may request verification to protect your account.',
                        ),
                        Section(
                          title: 'Cookies & Similar Technologies',
                          body:
                              'We use cookies to keep the site secure, remember your preferences, and understand performance. Your browser provides controls to manage cookies. For more details, see our Cookie Policy.',
                        ),
                        Section(
                          title: 'Data Retention',
                          body:
                              'We keep personal information only as long as necessary to provide services, meet legal requirements, resolve disputes, and enforce our agreements.',
                        ),
                        Section(
                          title: 'Security',
                          body:
                              'We use administrative, technical, and physical safeguards to help protect personal information. No method of transmission or storage is completely secure; please use the site responsibly.',
                        ),
                        Section(
                          title: 'International Transfers',
                          body:
                              'Your information may be processed and stored outside your country. Where required, we implement appropriate safeguards to protect your data.',
                        ),
                        Section(
                          title: 'Third-Party Links',
                          body:
                              'Our website may contain links to third-party sites. Their privacy practices are not covered by this policy. Please review their policies before providing personal information.',
                        ),
                        Section(
                          title: "Children's Privacy",
                          body:
                              'Our services are not directed to children and we do not knowingly collect data from individuals under 18. If you believe a minor has provided data, please contact us for removal.',
                        ),
                        Section(
                          title: 'Changes to This Policy',
                          body:
                              'We may update this policy periodically to reflect changes in practices, technology, or legal requirements. The “Last updated” date indicates the most recent revision.',
                        ),
                        Section(
                          title: 'Contact Us',
                          body:
                              'Questions or requests about this policy? We’re here to help.',
                          bullets: [
                            'Email: ${AppMeta.email}',
                            'Phone: ${AppMeta.phone}',
                            'Office: ${AppMeta.addressShort}',
                          ],
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

/// Generic section widget used throughout the legal pages.
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
    ); // gray-700

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
