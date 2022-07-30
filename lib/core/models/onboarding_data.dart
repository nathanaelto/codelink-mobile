class OnBoarding{
  final String title;
  final String image;

  OnBoarding({
      required this.title,
      required this.image
  });
}

List<OnBoarding> onboardingContents = [
  OnBoarding(
      title: 'Welcome to CodeLink !',
      image: 'assets/images/onboarding_image_1.png'),
  OnBoarding(
    title: 'Discover fascinating articles',
    image: 'assets/images/onboarding_image_2.png',
  ),
  OnBoarding(
    title: 'Learn more about code',
    image: 'assets/images/onboarding_image_3.png',
  )
];
