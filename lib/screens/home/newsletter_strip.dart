// ===============================
// File: lib/screens/home/newsletter_strip.dart
// Blue gradient newsletter signup strip with Firebase integration
// ===============================
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/tokens.dart';

class NewsletterStrip extends StatefulWidget {
  const NewsletterStrip({super.key});

  @override
  State<NewsletterStrip> createState() => _NewsletterStripState();
}

class _NewsletterStripState extends State<NewsletterStrip> {
  final _email = TextEditingController();
  bool _isLoading = false;

  // Firebase Firestore instance
  final _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _subscribe() async {
    final text = _email.text.trim();
    final ok = RegExp(r'^\S+@\S+\.\S+$').hasMatch(text);

    if (!ok) {
      _showResultOverlay(false, 'Invalid email address');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Firebase mein email save karein
      await _firestore.collection('newsletter_subscribers').add({
        'email': text,
        'subscribedAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      _email.clear();
      _showResultOverlay(true, 'Successfully subscribed!');
    } catch (e) {
      debugPrint('Error saving email: $e');
      _showResultOverlay(false, 'Failed to subscribe. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showResultOverlay(bool success, String message) {
    // Screen par icon dikhana
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _ResultOverlay(success: success, message: message),
    );

    overlay.insert(overlayEntry);

    // 2 seconds baad remove kar dein
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Widget _emailField() {
    return TextField(
      controller: _email,
      enabled: !_isLoading,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _subscribe(),
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        hintText: 'Enter your email address',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final bottomInset = mq.viewInsets.bottom;

    final clampedMQ = mq.copyWith(
      textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
    );

    final titleSize = w > 900 ? 32.0 : (w > 600 ? 30.0 : 26.0);
    final copySize = w > 600 ? 16.0 : 15.0;

    return MediaQuery(
      data: clampedMQ,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 0),
        child: Container(
          decoration: const BoxDecoration(gradient: AppGradients.blue),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Stay Updated',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Subscribe to our newsletter for property management tips, market insights, and exclusive offers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFE0E7FF),
                        fontSize: copySize,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  LayoutBuilder(
                    builder: (context, c) {
                      final isRow = c.maxWidth >= 640;

                      final button = SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.blue600,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                          ),
                          onPressed: _isLoading ? null : _subscribe,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.blue600,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Subscribe Now',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                        ),
                      );

                      if (isRow) {
                        return Row(
                          children: [
                            Expanded(child: _emailField()),
                            const SizedBox(width: 12),
                            button,
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _emailField(),
                            const SizedBox(height: 12),
                            SizedBox(width: double.infinity, child: button),
                          ],
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    'Join 5,000+ property owners receiving our insights',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 12),
                  ),
                ],
              ),
            ),
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
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
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
