import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/home_layout.dart';
import 'package:shop_app/modules/login_screen/login_screen.dart';
import 'package:shop_app/modules/onboardin_screen/onboarding_screen.dart';
import 'package:shop_app/shared/BlocObserver.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cashed_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';

import 'shop_cubit/app_cubit.dart';
import 'shop_cubit/app_states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CashedHelper.init();
  bool? isDark = CashedHelper.getData(key: 'isDark');
  bool? onBoarding = CashedHelper.getData(key: 'onBoarding');
  token = CashedHelper.getData(key: 'token');
  print('Token is : $token');

  Widget widget;

  if (onBoarding != null) {
    if (token != null)
      widget = HomeLayout();
    else
      widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget startWidget;

  const MyApp({
    Key? key,
    required this.isDark,
    required this.startWidget,
  }) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()
            ..changeThemeMode(fromShared: isDark)
            ..getHomeData()
            ..getCategoriesData()
            ..getFavoritesData()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, states) {},
          builder: (context, states) {
            return MaterialApp(
              theme: lightTheme(),
              darkTheme: darkTheme(),
              themeMode: ShopCubit.get(context).isDark == true
                  ? ThemeMode.dark
                  : ThemeMode.light,
              title: 'Shop App',
              home: startWidget,
              debugShowCheckedModeBanner: false,
            );
          }),
    );
  }
}
