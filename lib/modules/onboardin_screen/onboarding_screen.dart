import 'package:flutter/material.dart';
import 'package:shop_app/modules/login_screen/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cashed_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:shop_app/shop_cubit/app_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingModel {
  final String title;
  final String body;
  final String image;

  OnBoardingModel({
    required this.title,
    required this.body,
    required this.image,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  // ignore: override_on_non_overriding_member
  var pageController = PageController();
  bool isLast = false;
  List<OnBoardingModel> boardingList = [
    OnBoardingModel(
      title: 'Explore many products',
      body: 'lorem ipsum dolor sit amet,\n consectetur adipiscing elit',
      image: 'assets/images/onBoarding1.png',
    ),
    OnBoardingModel(
      title: 'Choose and checkout',
      body: 'lorem ipsum dolor sit amet,\n consectetur adipiscing elit',
      image: 'assets/images/onBoarding2.png',
    ),
    OnBoardingModel(
      title: 'Get it delivered',
      body: 'lorem ipsum dolor sit amet,\n consectetur adipiscing elit',
      image: 'assets/images/onBoarding3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            function: () {
              submit(context);
            },
            text: 'Skip',
          ),
          IconButton(
            onPressed: () {
              ShopCubit.get(context).changeThemeMode();
            },
            icon: Icon(Icons.brightness_4),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                onPageChanged: (index) {
                  if (index == boardingList.length - 1) {
                    print('last');
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    print('not last');
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                controller: pageController,
                itemBuilder: (context, index) =>
                    buildOnBoard(onBoard: boardingList[index]),
                itemCount: boardingList.length,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: boardingList.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 10.0,
                    dotColor: Colors.grey,
                    expansionFactor: 3,
                    activeDotColor: defaultColor,
                  ),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast == true) {
                      submit(context);
                    } else {
                      pageController.nextPage(
                          duration: Duration(
                            milliseconds: 750,
                          ),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnBoard({required OnBoardingModel onBoard}) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image(
              image: AssetImage('${onBoard.image}'),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            '${onBoard.title}',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w900,
                color: defaultColor),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            '${onBoard.body}',
            style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      );
}

void submit(BuildContext context) {
  navigateToAndFinish(context, LoginScreen());
  CashedHelper.putData(key: 'onBoarding', value: true);
}
