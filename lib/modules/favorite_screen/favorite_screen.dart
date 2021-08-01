import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:shop_app/shop_cubit/app_cubit.dart';
import 'package:shop_app/shop_cubit/app_states.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShopCubit.get(context).getFavoritesData();
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              ShopCubit.get(context).favoriteModel!.data!.data.length > 0 &&
              state is! ShopGetFavoriteDataLoadingState &&
              ShopCubit.get(context).favoriteModel!.data!.data != null,
          widgetBuilder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildFavoriteList(context,
                ShopCubit.get(context).favoriteModel!.data!.data[index]),
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsetsDirectional.only(start: 20.0),
              child: Container(
                color: Colors.grey[300],
                height: 1.0,
                width: double.infinity,
              ),
            ),
            itemCount: ShopCubit.get(context).favoriteModel!.data!.data.length,
          ),
          fallbackBuilder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildFavoriteList(context, FavoriteData? model) => Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(
                model!.product!.image.toString(),
              ),
              width: 120.0,
              height: 120.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    model.product!.name.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.product!.price.toInt()}',
                        style: TextStyle(
                          color: defaultColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${model.product!.oldPrice.toInt()}',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context)
                              .changeFavorite(model.product!.id!);
                        },
                        icon: CircleAvatar(
                          child: Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          radius: 15.0,
                          backgroundColor: ShopCubit.get(context)
                                      .favorites![model.product!.id] ==
                                  true
                              ? defaultColor
                              : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
