import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/modules/search_screen/search_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shop_cubit/app_cubit.dart';
import 'package:shop_app/shop_cubit/app_states.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShopCubit.get(context).getHomeData();
    return BlocConsumer<ShopCubit, ShopStates>(
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Sallah'),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(
                    context,
                    SearchScreen(),
                  );
                },
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  ShopCubit.get(context).changeThemeMode();
                },
                icon: Icon(Icons.brightness_4),
              ),
            ],
          ),
          body: Conditional.single(
            context: context,
            conditionBuilder: (context) =>
                state is! ShopGetHomeDataLoadingState,
            widgetBuilder: (context) => cubit.screens[cubit.currentIndex],
            fallbackBuilder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: cubit.itemsNAV,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeNaveScreen(index);
            },
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
