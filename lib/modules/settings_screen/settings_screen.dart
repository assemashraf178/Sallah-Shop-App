import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/modules/login_screen/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cashed_helper.dart';
import 'package:shop_app/shop_cubit/app_cubit.dart';
import 'package:shop_app/shop_cubit/app_states.dart';

class SettingsScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ShopCubit.get(context).getUserData();
    return BlocConsumer<ShopCubit, ShopStates>(
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;
        if (model != null) {
          nameController.text = model.data.name!;
          emailController.text = model.data.email!;
          phoneController.text = model.data.phone!;
        }
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => state is! ShopGetUserDataLoadingState,
          widgetBuilder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Conditional.single(
              context: context,
              conditionBuilder: (context) => model != null,
              widgetBuilder: (context) => Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (state is ShopUpdateDataLoadingState)
                        LinearProgressIndicator(),
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
                      defaultButton(
                        function: () {
                          if (formKey.currentState!.validate()) {
                            ShopCubit.get(context).updateData(
                              email: emailController.text,
                              name: nameController.text,
                              phone: phoneController.text,
                              token: token.toString(),
                            );
                          }
                        },
                        text: 'Update Data',
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultButton(
                        function: () {
                          CashedHelper.removeData(key: 'token');
                          navigateToAndFinish(context, LoginScreen());
                        },
                        text: 'Logout',
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
          fallbackBuilder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      listener: (context, state) {
        if (state is ShopUpdateDataSuccessState) {
          token = state.model.data.token;
        }
      },
    );
  }
}
