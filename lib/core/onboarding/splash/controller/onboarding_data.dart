import '../../../constants/app_assert_image.dart';

class OnboardingData {
  final String image;
  final String title;
  final String subtitle;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}


final List<OnboardingData> onboardingPages = [
  OnboardingData(
    image: AppAssertImage.instance.onboardingImage1,
    title: 'Move • Relax • Dine',
    subtitle: 'Your all-in-one wellness destination.',
  ),
  OnboardingData(
    image: AppAssertImage.instance.onboardingImage2,
    title: 'Your Wellness,\nSimplified.',
    subtitle: 'Book classes, order food, manage your\npeace.',
  ),
  OnboardingData(
    image: AppAssertImage.instance.onboardingImage3,
    title: 'Nourish Your\nMovement',
    subtitle: 'Fuel your body. Focus your mind.',
  ),
];