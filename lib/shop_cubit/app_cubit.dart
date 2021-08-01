import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorite_model.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories_screen/categories_screen.dart';
import 'package:shop_app/modules/favorite_screen/favorite_screen.dart';
import 'package:shop_app/modules/home_screen/home_screen.dart';
import 'package:shop_app/modules/settings_screen/settings_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cashed_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import 'app_states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialStates());

  static ShopCubit get(context) => BlocProvider.of(context);

  bool isDark = true;
  bool isEnabled = true;

  void changeThemeMode({bool? fromShared}) {
    if (fromShared != null)
      isDark = fromShared;
    else {
      isDark = !isDark;
      CashedHelper.putData(key: 'isDark', value: isDark).then((value) {
        emit(ShopChangeThemeMode());
      }).catchError((error) {
        print('Shared Pref Error : $error');
      });
    }
  }

  List<BottomNavigationBarItem> itemsNAV = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.apps),
      label: 'Categories',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorite',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  List<Widget> screens = [
    HomeScreen(),
    CategoriesScreen(),
    FavoriteScreen(),
    SettingsScreen(),
  ];

  int currentIndex = 0;

  void changeNaveScreen(int index) {
    currentIndex = index;
    emit(ShopChangeNavBarScreens());
  }

  HomeModel? homeModel;
  CategoriesModel? categoriesModel;

  Map<int?, bool?>? favorites = {};

  void getHomeData() {
    emit(ShopGetHomeDataLoadingState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      print('Token : $token');
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favorites!.addAll({element.id: element.in_favorites});
      });
      print(favorites.toString());
      print(homeModel!.status);
      emit(ShopGetHomeDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopGetHomeDataErrorState());
    });
  }

  void getCategoriesData() {
    emit(ShopGetCategoriesDataLoadingState());
    DioHelper.getData(
      url: CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopGetCategoriesDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopGetCategoriesDataErrorState());
    });
  }

  ChangeFavoriteModel? changeFavoriteModel;

  void changeFavorite(int productId) {
    favorites![productId] = favorites![productId] == true ? false : true;
    emit(ShopGetFavoriteDataLoadingState());
    DioHelper.postData(
      url: FAVORITE,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data);
      print(changeFavoriteModel.toString());
      if (changeFavoriteModel!.status == false) {
        favorites![productId] = favorites![productId] == true ? false : true;
        showToast(
          msg: changeFavoriteModel!.message.toString(),
          state: ToastColor.ERROR,
        );
      }
      getFavoritesData();
      emit(ShopChangeFavoriteSuccessState());
    }).catchError((error) {
      favorites![productId] = favorites![productId] == true ? false : true;
      showToast(
        msg: changeFavoriteModel!.message.toString(),
        state: ToastColor.ERROR,
      );
      emit(ShopChangeFavoriteErrorState());
    });
  }

  FavoriteModel? favoriteModel;

  void getFavoritesData() {
    emit(ShopGetFavoriteDataLoadingState());
    DioHelper.getData(
      url: FAVORITE,
      token: token,
    ).then((value) {
      favoriteModel = FavoriteModel.fromJson(value.data);
      print(favoriteModel!.data!.data[0].product!.name.toString());
      emit(ShopGetFavoriteDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopGetFavoriteDataErrorState());
    });
  }

  LoginModel? userModel;

  void getUserData() {
    emit(ShopGetUserDataLoadingState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(json: value.data);
      print(userModel!.data.name.toString());
      emit(ShopGetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopGetUserDataErrorState());
    });
  }

  void updateData({
    required String email,
    required String name,
    required String phone,
    String image =
        'https://student.valuxapps.com/storage/assets/defaults/user.jpg',
    String token = '',
  }) {
    emit(ShopUpdateDataLoadingState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      data: {
        "name": name,
        "phone": phone,
        "email": email,
        "image": image,
      },
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(json: value.data);
      print(userModel!.message.toString());
      print(userModel!.data.name);
      showToast(
        msg: userModel!.message.toString(),
        state: ToastColor.SUCCESS,
      );
      emit(ShopUpdateDataSuccessState(userModel!));
    }).catchError((error) {
      print(error.toString());
      showToast(
        msg: userModel!.message.toString(),
        state: ToastColor.ERROR,
      );
      emit(ShopUpdateDataErrorState());
    });
  }
}
