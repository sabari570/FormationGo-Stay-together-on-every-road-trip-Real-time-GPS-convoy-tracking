import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Welcome to FormationGo",
      "description":
          "The ultimate tool for tracking your motorcycle convoy in real-time without looking back.",
      "image": "assets/images/onboarding_1.png"
    },
    {
      "title": "Real-time Proximity",
      "description":
          "Always know who's keeping up. Set smart alerts for members falling behind.",
      "image": "assets/images/onboarding_2.png"
    },
    {
      "title": "Smart Checkpoints",
      "description":
          "Coordinate pit stops, fuel stations, and meetups with AI insights.",
      "image": "assets/images/onboarding_3.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) => _OnboardingContent(
                  image: _onboardingData[index]["image"]!,
                  title: _onboardingData[index]["title"]!,
                  description: _onboardingData[index]["description"]!,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(index: index),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage == _onboardingData.length - 1) {
                            context.push('/profile-setup');
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.convoyGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          _currentPage == _onboardingData.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5.w),
      height: 6.h,
      width: _currentPage == index ? 20.w : 6.w,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.convoyGreen : Colors.grey,
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        // Placeholder for image/lottie
        Container(
          height: 250.h,
          width: 250.w,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(Icons.motorcycle,
                size: 100.w, color: AppColors.convoyGreen),
          ),
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[400],
                ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
