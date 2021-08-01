import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/layouts/home_layout.dart';
import 'package:shop_app/modules/register_screen/cubit/register_cubit.dart';
import 'package:shop_app/modules/register_screen/cubit/register_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cashed_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:shop_app/shop_cubit/app_cubit.dart';
import 'package:shop_app/shop_cubit/app_states.dart';

class RegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    ShopCubit.get(context).changeThemeMode();
                  },
                  icon: Icon(Icons.brightness_4),
                ),
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      state is! ShopRegisterLoadingState,
                  widgetBuilder: (context) => Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REGISTER',
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: defaultColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Text(
                            'register now to brows hot our offers',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          defaultTextFromField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name must not be empty';
                              }
                              return null;
                            },
                            prefix: Icons.person,
                            label: 'Name',
                            type: TextInputType.name,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultTextFromField(
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email must not be empty';
                              }
                              return null;
                            },
                            prefix: Icons.email,
                            label: 'Email Address',
                            type: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultTextFromField(
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone must not be empty';
                              }
                              return null;
                            },
                            prefix: Icons.phone,
                            label: 'Phone',
                            type: TextInputType.phone,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultTextFromField(
                            controller: passwordController,
                            validator: (value) {
                              if (value.length < 6) {
                                return 'Password is too short';
                              }
                              return null;
                            },
                            prefix: Icons.lock_outline,
                            label: 'Password',
                            type: TextInputType.visiblePassword,
                            isPassword: RegisterCubit.get(context).isPassword,
                            suffixButton: IconButton(
                              onPressed: () {
                                RegisterCubit.get(context).changePasswordShow();
                              },
                              icon: Icon(
                                RegisterCubit.get(context).passwordIcon,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Conditional.single(
                            context: context,
                            conditionBuilder: (context) {
                              return state is! RegisterLoadingState;
                            },
                            widgetBuilder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  print(
                                      'Email : ${emailController.text.toString()}');
                                  print(
                                      'Password : ${passwordController.text.toString()}');
                                }
                                RegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  password: passwordController.text,
                                );
                              },
                              text: 'Register',
                              isUpperCase: true,
                            ),
                            fallbackBuilder: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  fallbackBuilder: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.loginModel.status) {
              print(state.loginModel.message);
              print(state.loginModel.data.token);
              CashedHelper.putData(
                key: 'token',
                value: state.loginModel.data.token,
              );
              token = state.loginModel.data.token.toString();
              navigateToAndFinish(
                context,
                HomeLayout(),
              );
            } else {
              showToast(
                msg: state.loginModel.message.toString(),
                state: ToastColor.ERROR,
              );
              print(state.loginModel.message);
            }
          }
        },
      ),
    );
  }
}
