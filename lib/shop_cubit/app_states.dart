import 'package:shop_app/models/login_model.dart';

abstract class ShopStates {}

class ShopInitialStates extends ShopStates {}

class ShopChangeThemeMode extends ShopStates {}

class ShopChangeNavBarScreens extends ShopStates {}

class ShopGetHomeDataLoadingState extends ShopStates {}

class ShopGetHomeDataSuccessState extends ShopStates {}

class ShopGetHomeDataErrorState extends ShopStates {}

class ShopGetCategoriesDataLoadingState extends ShopStates {}

class ShopGetCategoriesDataSuccessState extends ShopStates {}

class ShopGetCategoriesDataErrorState extends ShopStates {}

class ShopChangeFavoriteSuccessState extends ShopStates {}

class ShopChangeFavoriteErrorState extends ShopStates {}

class ShopGetFavoriteDataLoadingState extends ShopStates {}

class ShopGetFavoriteDataSuccessState extends ShopStates {}

class ShopGetFavoriteDataErrorState extends ShopStates {}

class ShopGetUserDataLoadingState extends ShopStates {}

class ShopGetUserDataSuccessState extends ShopStates {}

class ShopGetUserDataErrorState extends ShopStates {}

class ShopChangeProfileDataEnabledState extends ShopStates {}

class ShopUpdateDataLoadingState extends ShopStates {}

class ShopUpdateDataSuccessState extends ShopStates {
  final LoginModel model;

  ShopUpdateDataSuccessState(this.model);
}

class ShopUpdateDataErrorState extends ShopStates {}

class ShopRegisterLoadingState extends ShopStates {}

class ShopRegisterSuccessState extends ShopStates {}

class ShopRegisterErrorState extends ShopStates {}
