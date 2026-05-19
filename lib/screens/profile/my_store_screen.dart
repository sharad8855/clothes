import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';

class MyStoreScreen extends StatefulWidget {
  const MyStoreScreen({super.key});

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  late final PageController _pageController;
  Timer? _sliderTimer;
  int _currentSlideIndex = 0;

  // Premium list of high-fashion and styling related images for auto-slider
  final List<String> _bannerImages = [
    'https://images.unsplash.com/photo-1576016770956-debb63d900bb?q=80&w=800&auto=format&fit=crop', // Swimming pool deck pants (matching user mock)
    'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?q=80&w=800&auto=format&fit=crop', // Fashion designer fabrics
    'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?q=80&w=800&auto=format&fit=crop', // Stylish hanger clothing boutique
    'https://images.unsplash.com/photo-1507679799987-c73779587ccf?q=80&w=800&auto=format&fit=crop', // Premium tailoring craftsmanship
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlider();
  }

  void _startAutoSlider() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentSlideIndex + 1;
        if (nextPage >= _bannerImages.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessProvider>(
      builder: (context, provider, child) {
        final business = provider.selectedBusiness;
        
        // Dynamically get the business name or default to 'Pro active store'
        final String storeName = business?.name ?? 'Pro active store';
        
        // Dynamically build the location string or default to 'Akole, maharashtra, india'
        final String city = business?.contactInfo?.city ?? 'Akole';
        final String state = business?.contactInfo?.state ?? 'maharashtra';
        final String country = business?.contactInfo?.country ?? 'india';
        final String locationText = '${city.trim()}, ${state.trim()}, ${country.trim()}'.toLowerCase();

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Cover Banner Slider & Top Buttons
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Auto-sliding Carousel (PageView)
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentSlideIndex = index;
                          });
                        },
                        itemCount: _bannerImages.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            _bannerImages[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 220,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFF1F5F9),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported_rounded,
                                    color: Color(0xFF94A3B8),
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // Gradient overlay for readability
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.35),
                            Colors.transparent,
                            Colors.black.withOpacity(0.2),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Navigation overlay buttons
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 16,
                      child: GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          // Edit cover action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Edit cover photo option coming soon!')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // Premium indicator dots overlay (Bottom Right corner)
                    Positioned(
                      bottom: 12,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _bannerImages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 6,
                            width: _currentSlideIndex == index ? 18 : 6,
                            decoration: BoxDecoration(
                              color: _currentSlideIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 2. Circular Profile Logo overlapping the banner
                    Positioned(
                      bottom: -45,
                      left: 20,
                      child: Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?q=80&w=300&auto=format&fit=crop',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 52), // Space for overlapping avatar

                // 3. Category/Role Pill Badge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A389), // Greenish/Teal pill badge
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'wholesaler',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 4. Store Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    storeName,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1E293B),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // 5. Location Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          locationText,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 6. Action Bar: Edit Profile, Share, Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Edit Profile Link
                      GestureDetector(
                        onTap: () {
                          // Edit Profile Action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Edit profile option coming soon!')),
                          );
                        },
                        child: Text(
                          'Edit Profile',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFF59E0B), // Golden / Yellow Edit Profile link
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Share button
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Store shared successfully!')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F8F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.reply_rounded, // Curved right sharing arrow representation
                            color: Color(0xFF22C55E),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Chat/Message button
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Messages coming soon!')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Color(0xFF3B82F6),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 7. Large Contact and Connections buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Connections Button
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7), // Light peach background
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '3 ',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFD97706), // Dark orange/gold color for number
                                  ),
                                ),
                                TextSpan(
                                  text: 'Connections',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Contact Us Button
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7), // Light peach background
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Contact Us',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
