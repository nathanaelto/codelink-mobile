import 'package:codelink_mobile/authentication/sign_up_view.dart';
import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:codelink_mobile/core/models/onboarding_data.dart';
import 'package:codelink_mobile/shared/styles/size_configs.dart';
import 'package:codelink_mobile/shared/widgets/buttons/my_text_button.dart';
import 'package:codelink_mobile/onboarding/widgets/onboard_nav_btn.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentPage = 0;

  final PageController _pageController = PageController(initialPage: 0);

  AnimatedContainer dotIndicator(index) {
    return AnimatedContainer(
        margin: const EdgeInsets.only(right: 5),
        duration: const Duration(milliseconds: 400),
        height: 12,
        width: 12,
        decoration: BoxDecoration(
          color: currentPage == index ? kPrimaryColor : kSecondaryColor,
          shape: BoxShape.circle,
        ));
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.blockSizeH!;
    double sizeV = SizeConfig.blockSizeV!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              flex: 9,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: onboardingContents.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    SizedBox(
                      height: sizeH * 10,
                    ),
                    Text(onboardingContents[index].title,
                        style: kTitle, textAlign: TextAlign.center),
                    SizedBox(
                      height: sizeH * 5,
                    ),
                    Container(
                        height: sizeV * 50,
                        child: Image.asset(onboardingContents[index].image,
                            fit: BoxFit.contain)),
                    SizedBox(
                      height: sizeH * 5,
                    ),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: kBodyText1,
                          children: [
                            const TextSpan(text: 'The best app to practice'),
                            TextSpan(
                                text: ' code !',
                                style: TextStyle(color: kPrimaryColor)),
                            const TextSpan(
                                text:
                                    ' \n Lorem ipsum dolor sit amet, consectetur adipiscing elit'),
                            const TextSpan(
                                text:
                                    'Sed non risus. Suspendisse lectus tortor.'),
                          ],
                        )),
                    SizedBox(
                      height: sizeH * 3,
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  currentPage == onboardingContents.length - 1
                      ? Expanded(
                        child: MyTextButton(
                            buttonName: 'Get Started',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpView()
                                  ));
                            },
                            bgColor: kPrimaryColor,
                          ),
                      )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OnBoardNavBtn(
                              name: 'Skip',
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpView(),
                                ));
                              },
                            ),
                            Row(
                              children: List.generate(
                                onboardingContents.length,
                                (index) => dotIndicator(index),
                              ),
                            ),
                            OnBoardNavBtn(
                                name: 'Next',
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                })
                          ],
                        ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}




