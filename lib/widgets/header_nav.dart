// ===============================
// File: lib/widgets/header_nav.dart
// Responsive header/navigation bar (with secret admin access)
// Secret: Tap the BRAND NAME 5 times within 2 seconds to open Admin panel
// ===============================
import 'package:flutter/material.dart';
import 'package:mirabellaestatemanagementservices/screens/admin_login_screen.dart';
import '../constants/tokens.dart';

// 🔐 Adjust this path if your file lives elsewhere.

class HeaderNav extends StatefulWidget {
  final void Function(String id) onTapItem;
  final VoidCallback onToggleMenu;
  final bool isMobile;
  final bool mobileOpen;

  const HeaderNav({
    super.key,
    required this.onTapItem,
    required this.onToggleMenu,
    required this.isMobile,
    required this.mobileOpen,
  });

  @override
  State<HeaderNav> createState() => _HeaderNavState();
}

class _HeaderNavState extends State<HeaderNav> {
  int _nameTapCount = 0;
  DateTime? _lastNameTapAt;

  void _handleBrandNameTap() {
    final now = DateTime.now();

    // Reset if taps are spaced out > 2s
    if (_lastNameTapAt != null &&
        now.difference(_lastNameTapAt!).inSeconds > 2) {
      _nameTapCount = 0;
    }

    _lastNameTapAt = now;
    _nameTapCount++;

    // Feedback from 3rd to 4th taps
    if (_nameTapCount >= 3 && _nameTapCount < 5) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${5 - _nameTapCount} more taps...'),
          duration: const Duration(milliseconds: 800),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.blue600,
        ),
      );
    }

    if (_nameTapCount == 5) {
      _nameTapCount = 0;
      _lastNameTapAt = null;

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('🔐 Opening Admin Panel...'),
          duration: Duration(milliseconds: 1000),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );

      // Small delay so the snackbar shows before navigating
      Future.delayed(const Duration(milliseconds: 450), () {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AdminLoginScreen(),
            settings: const RouteSettings(name: 'AdminLogin'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(label: 'Home', id: 'home'),
      _NavItem(label: 'Services', id: 'services'),
      _NavItem(label: 'Process', id: 'process'),
      _NavItem(label: 'Pricing', id: 'pricing'),
    ];

    // Clamp oversized text scales that can break toolbars
    final mq = MediaQuery.of(context);
    final clamped = mq.copyWith(
      textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
    );

    return MediaQuery(
      data: clamped,
      child: Material(
        elevation: 8,
        color: Colors.white,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(
              builder: (context, c) {
                final compact = !widget.isMobile && c.maxWidth < 1040;
                final veryCompact = !widget.isMobile && c.maxWidth < 940;

                return Container(
                  height: widget.isMobile ? 64 : 80,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // ---- Brand ----
                      if (widget.isMobile)
                        Expanded(
                          child: _Logo(
                            isMobile: true,
                            onIconTap: () => widget.onTapItem('home'),
                            onNameTap: _handleBrandNameTap, // 🔐 secret trigger
                          ),
                        )
                      else
                        _Logo(
                          isMobile: false,
                          onIconTap: () => widget.onTapItem('home'),
                          onNameTap: _handleBrandNameTap, // 🔐 secret trigger
                        ),

                      const SizedBox(width: 8),

                      // ---- Desktop links (auto-compact) ----
                      if (!widget.isMobile) ...[
                        const Spacer(),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                children: [
                                  for (final it in items)
                                    _HeaderTextBtn(
                                      label: it.label,
                                      onPressed: () => widget.onTapItem(it.id),
                                      compact: compact,
                                      veryCompact: veryCompact,
                                    ),
                                  SizedBox(width: compact ? 6 : 10),
                                  _PrimaryCTA(
                                    label: 'Get Started',
                                    onPressed: () =>
                                        widget.onTapItem('contact'),
                                    compact: veryCompact,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],

                      // ---- Mobile hamburger ----
                      if (widget.isMobile)
                        IconButton(
                          icon: Icon(
                            widget.mobileOpen
                                ? Icons.close_rounded
                                : Icons.menu_rounded,
                            color: AppColors.gray900,
                          ),
                          onPressed: widget.onToggleMenu,
                          tooltip: 'Menu',
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onIconTap; // normal: scroll home
  final VoidCallback onNameTap; // secret: 5x tap opens admin
  final bool isMobile;

  const _Logo({
    required this.onIconTap,
    required this.onNameTap,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    // Base logo image
    final img = Image.asset('assets/logo.png', height: 36, fit: BoxFit.contain);

    // Blue tint (works best with mono PNG + transparency)
    final tinted = ColorFiltered(
      colorFilter: const ColorFilter.mode(AppColors.blue600, BlendMode.srcIn),
      child: img,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon part ─ normal tap to Home
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onIconTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 40, maxWidth: 160),
              child: tinted,
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Brand name part ─ secret 5-tap trigger
        if (isMobile)
          // Single-line brand on mobile
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onNameTap,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Mirabella Estate Management Services',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.gray900,
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          // Two-line brand on desktop
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onNameTap,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mirabella',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: AppColors.gray900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Estate Management Services',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeaderTextBtn extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool compact;
  final bool veryCompact;

  const _HeaderTextBtn({
    required this.label,
    required this.onPressed,
    required this.compact,
    required this.veryCompact,
  });

  @override
  Widget build(BuildContext context) {
    final horizPad = veryCompact ? 8.0 : (compact ? 10.0 : 14.0);
    final fontSize = veryCompact ? 13.0 : (compact ? 14.0 : 15.0);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.gray900,
        padding: EdgeInsets.symmetric(horizontal: horizPad),
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class _PrimaryCTA extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool compact;
  const _PrimaryCTA({
    required this.label,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final padH = compact ? 14.0 : 18.0;
    final padV = compact ? 10.0 : 12.0;
    final fontSize = compact ? 13.5 : 14.5;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppGradients.blueBr,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: AppShadows.medium,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String id;
  const _NavItem({required this.label, required this.id});
}
