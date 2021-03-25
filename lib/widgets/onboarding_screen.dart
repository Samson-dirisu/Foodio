import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:foodio/helper/constant.dart';
import 'package:foodio/widgets/dot_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController(initialPage: 0);
  int _currentPage = 0;
  List<Widget> _pages = [
    Column(
      children: [
        Expanded(child: Image.asset("images/camera_lens.png")),
        Text(
          "Set Your Deliver Location",
          style: kPageViewTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    ),
    Column(
      children: [
        Expanded(child: Image.asset("images/phone_order.png")),
        Text(
          "Order Online from Your Favourite Store",
          style: kPageViewTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    ),
    Column(
      children: [
        Expanded(child: Image.asset("images/24.png")),
        Text(
          "Quick Delivery to your Doorstep",
          style: kPageViewTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: _pages,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          SizedBox(height: 20.0),
          // DotsIndicator(
          //   dotsCount: _pages.length,
          //   position: _currentPage.toDouble(),
          //   decorator: DotsDecorator(
          //       size: const Size.square(9.0),
          //       activeSize: const Size(18.0, 9.0),
          //       activeShape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(5.0),
          //       ),
          //       activeColor: Theme.of(context).primaryColor),
          // ),
          DotIndicator(count: _pages.length, currentPage: _currentPage),
          SizedBox(height: 20.0),
        ],
      );
  }
}
