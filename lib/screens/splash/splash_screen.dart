import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../core/session_manager.dart';
import '../login/login_screen.dart';
import '../shell/main_shell.dart';
import '../home/hello_screen.dart';
import '../business/business_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool startLoggedIn;
  const SplashScreen({super.key, required this.startLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..forward();

    // Redirection logic
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Wait for the branding animation to complete
    await Future.delayed(const Duration(milliseconds: 3500));
    
    if (!mounted) return;

    if (!widget.startLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    // If starting logged in, we need to ensure the profile is fetched to check roles
    try {
      final profile = context.read<ProfileProvider>();
      await profile.fetchProfile();
      
      final savedBusinessId = await SessionManager.instance.getSelectedBusinessId();
      
      if (!mounted) return;

      Widget destination;
      if (savedBusinessId == null) {
        destination = const BusinessSelectionScreen();
      } else {
        destination = profile.userProfile?.isBusinessStaff == true
            ? const HelloScreen()
            : MainShell();
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => destination),
      );
    } catch (e) {
      // Fallback to login if profile fetch fails
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Architectural background lines
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundArchitecturalPainter(),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Container
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(60, 60),
                      painter: _RoyalStitchLogoPainter(),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                
                // Brand Name
                Text(
                  'ROYAL STITCH',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6.0,
                    color: const Color(0xFF1A1D2E), // Deep Navy
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Subtitle
                Text(
                  'The Digital Curator for Bespoke Artistry',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280), // Muted Gray
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom section with loader and version
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progressController.value,
                        backgroundColor: const Color(0xFFE5E7EB),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5B4FCF)),
                        minHeight: 2,
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'HANDCRAFTED EXPERIENCE',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9CA3AF),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.circle, size: 4, color: Color(0xFFC4B5FD)),
                    const SizedBox(width: 8),
                    Text(
                      'V 2.4.0',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundArchitecturalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1.0;

    const double spacing = 40;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoyalStitchLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final navyPaint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    final purplePaint = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..style = PaintingStyle.fill;

    // Draw "RS" text proxy with lines/curves to make it look premium
    // Just a placeholder for high-end look
    final rPath = Path();
    rPath.moveTo(size.width * 0.2, size.height * 0.7);
    rPath.lineTo(size.width * 0.2, size.height * 0.3);
    rPath.quadraticBezierTo(size.width * 0.45, size.height * 0.25, size.width * 0.45, size.height * 0.45);
    rPath.quadraticBezierTo(size.width * 0.45, size.height * 0.55, size.width * 0.2, size.height * 0.55);
    rPath.moveTo(size.width * 0.3, size.height * 0.55);
    rPath.lineTo(size.width * 0.45, size.height * 0.75);

    final sPath = Path();
    sPath.moveTo(size.width * 0.75, size.height * 0.3);
    sPath.quadraticBezierTo(size.width * 0.55, size.height * 0.3, size.width * 0.65, size.height * 0.5);
    sPath.quadraticBezierTo(size.width * 0.8, size.height * 0.7, size.width * 0.55, size.height * 0.7);

    // Draw Divider/Compass arms
    final compassPath = Path();
    compassPath.moveTo(size.width * 0.5, size.height * 0.15); // Top pivot
    compassPath.lineTo(size.width * 0.25, size.height * 0.85); // Left leg
    compassPath.moveTo(size.width * 0.5, size.height * 0.15);
    compassPath.lineTo(size.width * 0.75, size.height * 0.85); // Right leg
    
    // Draw Pivot point
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.15), 4, navyPaint..style = PaintingStyle.fill);

    canvas.drawPath(compassPath, navyPaint..style = PaintingStyle.stroke..strokeWidth = 4);
    canvas.drawPath(rPath, navyPaint..strokeWidth = 2..color = const Color(0xFF94A3B8));
    canvas.drawPath(sPath, navyPaint..strokeWidth = 2..color = const Color(0xFF94A3B8));

    // Draw Diamond at the top right
    final diamondPath = Path();
    diamondPath.moveTo(size.width * 0.75, size.height * 0.15);
    diamondPath.lineTo(size.width * 0.85, size.height * 0.25);
    diamondPath.lineTo(size.width * 0.75, size.height * 0.35);
    diamondPath.lineTo(size.width * 0.65, size.height * 0.25);
    diamondPath.close();
    
    canvas.drawPath(diamondPath, purplePaint);
    
    // Tiny stars at the very top right of the whole design
    // (Handled in the main screen as the image shows them global)
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
