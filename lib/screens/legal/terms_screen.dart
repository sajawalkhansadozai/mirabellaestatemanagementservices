// ===============================
// File: lib/screens/legal/terms_of_service.dart
// Terms of Service (SEO-friendly, responsive)
// ===============================
import 'package:flutter/material.dart';
import '../../constants/tokens.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

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
                          'Terms of Service',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: titleSize,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Please read these terms carefully before using Mirabella Estate Management Services.',
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
                          title: 'Agreement to Terms',
                          body:
                              'By accessing or using our website and services, you agree to be bound by these Terms of Service and all applicable laws. If you do not agree, please discontinue using the site and services.',
                        ),
                        Section(
                          title: 'Who We Are',
                          body:
                              '“Mirabella”, “we”, “us”, and “our” refer to Mirabella Estate Management Services, a property management company serving Islamabad and nearby areas.',
                        ),
                        Section(
                          title: 'Eligibility',
                          body:
                              'You must be at least 18 years old and capable of entering into a legally binding contract to use our services.',
                        ),
                        Section(
                          title: 'Accounts & Your Responsibilities',
                          bullets: [
                            'Provide accurate, current, and complete information.',
                            'Maintain the security of your account credentials.',
                            'Notify us promptly of any unauthorized access.',
                            'Accept responsibility for all activities under your account.',
                          ],
                        ),
                        Section(
                          title: 'Acceptable Use',
                          bullets: [
                            'Do not misuse the website, interfere with its operation, or attempt to access non-public areas.',
                            'Do not upload or transmit harmful code, spam, or content that infringes third-party rights.',
                            'Do not use the services for unlawful, fraudulent, or misleading purposes.',
                            'Respect other users, our team, and applicable local laws and regulations.',
                          ],
                        ),
                        Section(
                          title: 'Fees & Payments',
                          body:
                              'Where applicable, fees for property management or related services will be specified in your proposal or service agreement. Taxes may apply. Late payments may incur additional charges as stated in your agreement.',
                        ),
                        Section(
                          title: 'Property Listings & Content',
                          body:
                              'By submitting property details, photos, or other materials, you grant Mirabella a non-exclusive, worldwide licence to use, reproduce, and display such content solely to provide and promote our services. You warrant that you have the rights to share the content and that it does not infringe third-party rights.',
                        ),
                        Section(
                          title: 'Intellectual Property',
                          body:
                              'All site content, trademarks, logos, and software are the property of Mirabella or its licensors and are protected by applicable laws. You may not copy, modify, or distribute any portion of the site without prior written consent.',
                        ),
                        Section(
                          title: 'Disclaimer of Warranties',
                          body:
                              'The website and services are provided “as is” and “as available”. We disclaim all warranties of any kind, whether express or implied, including merchantability, fitness for a particular purpose, and non-infringement.',
                        ),
                        Section(
                          title: 'Limitation of Liability',
                          body:
                              'To the fullest extent permitted by law, Mirabella will not be liable for indirect, incidental, special, consequential, or punitive damages, or any loss of profits or data, arising from your use of the site or services.',
                        ),
                        Section(
                          title: 'Indemnification',
                          body:
                              'You agree to defend, indemnify, and hold harmless Mirabella and its officers, employees, and agents from any claims, liabilities, damages, losses, and expenses (including legal fees) arising out of your use of the site, your content, or your violation of these terms.',
                        ),
                        Section(
                          title: 'Termination',
                          body:
                              'We may suspend or terminate access to the website or services at any time, with or without notice, for conduct that we believe violates these terms or is harmful to other users, us, or third parties.',
                        ),
                        Section(
                          title: 'Governing Law & Disputes',
                          body:
                              'These terms are governed by the laws of Pakistan. Any disputes will be subject to the exclusive jurisdiction of the courts located in Islamabad, Pakistan.',
                        ),
                        Section(
                          title: 'Changes to These Terms',
                          body:
                              'We may revise these terms from time to time. Continued use of the website or services after changes become effective constitutes acceptance of the revised terms.',
                        ),
                        Section(
                          title: 'Contact Us',
                          bullets: [
                            'Email: ${AppMeta.email}',
                            'Phone: ${AppMeta.phone}',
                            'Office: ${AppMeta.addressShort}',
                          ],
                          body:
                              'If you have questions about these Terms of Service, please reach out.',
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

// ---- Shared section widgets (same as in Privacy page) ----
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
