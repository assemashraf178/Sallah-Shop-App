import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/register_screen/cubit/register_states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;
  bool isPassword = true;
  IconData passwordIcon = Icons.visibility_outlined;

  void changePasswordShow() {
    isPassword = !isPassword;
    passwordIcon = isPassword == true
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(RegisterShowPasswordState());
  }

  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String name,
    String image =
        'https://student.valuxapps.com/storage/assets/defaults/user.jpg',
    String token = '',
  }) {
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
        "image": image,
      },
    ).then((value) {
      print(value.data);
      loginModel = LoginModel.fromJson(json: value.data);
      print('Token in Login is : ${loginModel!.data.token}');
      emit(RegisterSuccessState(loginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }
}
