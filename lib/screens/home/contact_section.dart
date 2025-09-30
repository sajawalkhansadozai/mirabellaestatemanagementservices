// ===============================
// File: lib/screens/home/contact_section.dart
// Contact split: gradient info panel (left) + lead form (right)
// Fully responsive + overflow-proof + Firebase integration
// ===============================
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/tokens.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();
  String _propertyType = '';
  bool _isLoading = false;

  final _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);

    try {
      await _firestore.collection('contact_submissions').add({
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'phone': _phone.text.trim(),
        'propertyType': _propertyType.isEmpty ? null : _propertyType,
        'message': _message.text.trim(),
        'submittedAt': FieldValue.serverTimestamp(),
        'status': 'new',
      });

      _formKey.currentState?.reset();
      _name.clear();
      _email.clear();
      _phone.clear();
      _message.clear();
      setState(() => _propertyType = '');

      _showResultOverlay(true, "Thank you! We'll contact you within 24 hours.");
    } catch (e) {
      _showResultOverlay(false, 'Failed to submit. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showResultOverlay(bool success, String message) {
    final overlay = Overlay.of(context);
    if (overlay == null) {
      // Fallback if no Overlay in the tree
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    final entry = OverlayEntry(
      builder: (context) => _ResultOverlay(success: success, message: message),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // ---- Header chips & copy ----
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Get In Touch',
                  style: TextStyle(
                    color: AppColors.blue800,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Start Your Journey With Us',
                textScaler: scaler,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: w > 900 ? 34 : (w > 600 ? 30 : 26),
                  fontWeight: FontWeight.w800,
                  color: AppColors.gray900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Let's discuss how we can help you maximize your property investment. Fill out the form or reach us directly.",
                  textScaler: scaler,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.45,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ---- 3 contact tiles ----
              LayoutBuilder(
                builder: (context, c) {
                  int cross = 1;
                  if (c.maxWidth >= 900) {
                    cross = 3;
                  } else if (c.maxWidth >= 600) {
                    cross = 2;
                  }

                  const gap = 12.0;
                  final double tileHeight = switch (cross) {
                    3 => 196,
                    2 => 210,
                    _ => 184,
                  };

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cross,
                      mainAxisSpacing: gap,
                      crossAxisSpacing: gap,
                      mainAxisExtent: tileHeight,
                    ),
                    itemCount: 3,
                    itemBuilder: (context, i) {
                      const tiles = [
                        _InfoTile(
                          icon: Icons.phone_rounded,
                          title: 'Phone',
                          subtitle: 'Call us for immediate assistance',
                          linkText: AppMeta.phone,
                          linkAction: 'tel:+923300492037',
                        ),
                        _InfoTile(
                          icon: Icons.mail_outline_rounded,
                          title: 'Email',
                          subtitle: 'Send us your queries',
                          linkText: AppMeta.email,
                          linkAction:
                              'mailto:info@mirabellaestatemanagementservices.com',
                        ),
                        _InfoTile(
                          icon: Icons.location_on_rounded,
                          title: 'Office',
                          subtitle: 'Visit us at our office',
                          linkText: AppMeta.addressShort,
                          linkAction:
                              'https://www.google.com/maps/place/Mirabella+Restaurant+%26+Hotel/@33.6356712,72.8460588,17z/data=!3m1!4b1!4m6!3m5!1s0x38df99de5a1647f9:0x38e47923f53177ff!8m2!3d33.6356712!4d72.8486391!16s%2Fg%2F11n34fmv_d?entry=ttu&g_ep=EgoyMDI1MDkyNC4wIKXMDSoASAFQAw%3D%3D',
                        ),
                      ];
                      return tiles[i];
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // ---- Big card split ----
              Material(
                elevation: 16,
                borderRadius: BorderRadius.circular(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final twoCol = c.maxWidth >= 880;

                      if (twoCol) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(flex: 42, child: _LeftPanel()),
                            Expanded(
                              flex: 58,
                              child: _RightForm(
                                formKey: _formKey,
                                name: _name,
                                email: _email,
                                phone: _phone,
                                message: _message,
                                propertyType: _propertyType,
                                isLoading: _isLoading,
                                onPropertyTypeChanged: (v) =>
                                    setState(() => _propertyType = v),
                                onSubmit: _submit,
                              ),
                            ),
                          ],
                        );
                      }

                      // Mobile
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _LeftPanel(),
                          _RightForm(
                            formKey: _formKey,
                            name: _name,
                            email: _email,
                            phone: _phone,
                            message: _message,
                            propertyType: _propertyType,
                            isLoading: _isLoading,
                            onPropertyTypeChanged: (v) =>
                                setState(() => _propertyType = v),
                            onSubmit: _submit,
                          ),
                        ],
                      );
                    },
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String linkText;
  final String linkAction;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.linkText,
    required this.linkAction,
  });

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);

    return Material(
      color: Colors.white,
      elevation: 10,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () =>
            launchUrlString(linkAction, mode: LaunchMode.externalApplication),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, color: AppColors.blue600, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textScaler: scaler,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.gray900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textScaler: scaler,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => launchUrlString(
                  linkAction,
                  mode: LaunchMode.externalApplication,
                ),
                child: Text(
                  linkText,
                  textScaler: scaler,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.blue600,
                    fontWeight: FontWeight.w700,
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

class _LeftPanel extends StatelessWidget {
  const _LeftPanel();

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);

    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.blueBr),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready to Get Started?',
            textScaler: scaler,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            // NOTE: use double-quotes so the apostrophe in "We'll" doesn't break compilation.
            "Schedule a free consultation with our property management experts. We'll assess your property, discuss your goals, and create a customized plan.",
            textScaler: scaler,
            style: const TextStyle(
              color: Color(0xFFE0E7FF),
              height: 1.6,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 18),
          const _BulletRow(
            title: 'Free Property Assessment',
            subtitle: 'Comprehensive evaluation worth PKR 5,000',
          ),
          const SizedBox(height: 10),
          const _BulletRow(
            title: 'Market Analysis Report',
            subtitle: 'Detailed rental market insights',
          ),
          const SizedBox(height: 10),
          const _BulletRow(
            title: 'Custom Management Plan',
            subtitle: 'Tailored to your specific needs',
          ),
          const SizedBox(height: 18),
          const _HoursBlock(),
        ],
      ),
    );
  }
}

class _HoursBlock extends StatelessWidget {
  const _HoursBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.schedule_rounded, color: Colors.white),
          SizedBox(width: 10),
          Expanded(child: _HoursText()),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String title;
  final String subtitle;
  const _BulletRow({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);
    return Row(
      children: [
        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textScaler: scaler,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textScaler: scaler,
                style: const TextStyle(color: Color(0xFFE0E7FF), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HoursText extends StatelessWidget {
  const _HoursText();

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Office Hours',
          textScaler: scaler,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Monday - Saturday: 9:00 AM - 6:00 PM',
          textScaler: scaler,
          style: const TextStyle(color: Color(0xFFE0E7FF), fontSize: 12),
        ),
        Text(
          'Sunday: Closed',
          textScaler: scaler,
          style: const TextStyle(color: Color(0xFFE0E7FF), fontSize: 12),
        ),
      ],
    );
  }
}

class _RightForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController message;
  final String propertyType;
  final bool isLoading;
  final ValueChanged<String> onPropertyTypeChanged;
  final VoidCallback onSubmit;

  const _RightForm({
    required this.formKey,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.propertyType,
    required this.isLoading,
    required this.onPropertyTypeChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.15);

    InputDecoration deco(String label, {String? hint}) => InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.blue600, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 0),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(28),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 560;

              return SingleChildScrollView(
                primary: false,
                physics: const ClampingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Us a Message',
                      textScaler: scaler,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    TextFormField(
                      controller: name,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      scrollPadding: const EdgeInsets.only(bottom: 120),
                      decoration: deco(
                        'Full Name *',
                        hint: 'Enter your full name',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    const SizedBox(height: 12),

                    // Email + Phone
                    if (wide)
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: email,
                              enabled: !isLoading,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              scrollPadding: const EdgeInsets.only(bottom: 120),
                              decoration: deco(
                                'Email *',
                                hint: 'your@email.com',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Required';
                                }
                                final ok = RegExp(
                                  r'^\S+@\S+\.\S+$',
                                ).hasMatch(v.trim());
                                return ok ? null : 'Invalid email';
                              },
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: phone,
                              enabled: !isLoading,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.telephoneNumber,
                              ],
                              scrollPadding: const EdgeInsets.only(bottom: 120),
                              decoration: deco(
                                'Phone *',
                                hint: '+92 300 1234567',
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          TextFormField(
                            controller: email,
                            enabled: !isLoading,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                            decoration: deco('Email *', hint: 'your@email.com'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty)
                                return 'Required';
                              final ok = RegExp(
                                r'^\S+@\S+\.\S+$',
                              ).hasMatch(v.trim());
                              return ok ? null : 'Invalid email';
                            },
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: phone,
                            enabled: !isLoading,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.telephoneNumber,
                            ],
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                            decoration: deco(
                              'Phone *',
                              hint: '+92 300 1234567',
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),

                    // Property type
                    DropdownButtonFormField<String>(
                      value: propertyType.isEmpty ? null : propertyType,
                      decoration: deco('Property Type'),
                      items: const [
                        DropdownMenuItem(
                          value: 'residential',
                          child: Text('Residential'),
                        ),
                        DropdownMenuItem(
                          value: 'commercial',
                          child: Text('Commercial'),
                        ),
                        DropdownMenuItem(
                          value: 'mixed',
                          child: Text('Mixed Use'),
                        ),
                      ],
                      onChanged: isLoading
                          ? null
                          : (v) => onPropertyTypeChanged(v ?? ''),
                    ),
                    const SizedBox(height: 12),

                    // Message
                    TextFormField(
                      controller: message,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.done,
                      scrollPadding: const EdgeInsets.only(bottom: 160),
                      decoration: deco(
                        'Your Message *',
                        hint: 'Tell us about your property management needs...',
                      ),
                      minLines: 4,
                      maxLines: 6,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                      onFieldSubmitted: (_) => onSubmit(),
                    ),
                    const SizedBox(height: 14),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: isLoading
                            ? const SizedBox.shrink()
                            : const Icon(Icons.arrow_forward_rounded),
                        label: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Send Message'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 10,
                        ),
                        onPressed: isLoading ? null : onSubmit,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'By submitting this form, you agree to our privacy policy and terms of service.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Success/Error overlay widget
class _ResultOverlay extends StatefulWidget {
  final bool success;
  final String message;

  const _ResultOverlay({required this.success, required this.message});

  @override
  State<_ResultOverlay> createState() => _ResultOverlayState();
}

class _ResultOverlayState extends State<_ResultOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  )..forward();

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black26,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: widget.success
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.success ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
