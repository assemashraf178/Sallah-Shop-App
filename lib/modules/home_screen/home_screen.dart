import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:shop_app/shop_cubit/app_cubit.dart';
import 'package:shop_app/shop_cubit/app_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      builder: (context, state) {
        return Conditional.single(
            context: context,
            conditionBuilder: (context) =>
                ShopCubit.get(context).homeModel != null &&
                ShopCubit.get(context).categoriesModel != null,
            widgetBuilder: (context) =>
                homeBuilder(context, ShopCubit.get(context).homeModel),
            fallbackBuilder: (context) => Center(
                  child: CircularProgressIndicator(),
                ));
      },
      listener: (context, state) {},
    );
  }

  Widget homeBuilder(context, HomeModel? model) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: ShopCubit.get(context)
                .homeModel!
                .data!
                .banners
                .map((e) => Image(
                      image: NetworkImage(
                        '${e.image}',
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ))
                .toList(),
            options: CarouselOptions(
              height: 170.0,
              autoPlay: true,
              initialPage: 0,
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayInterval: Duration(seconds: 3),
              enableInfiniteScroll: true,
              reverse: false,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 100.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => buildCategories(
                        ShopCubit.get(context)
                            .categoriesModel!
                            .data!
                            .data[index]),
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10.0,
                    ),
                    itemCount: ShopCubit.get(context)
                        .categoriesModel!
                        .data!
                        .data
                        .length,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'New Products',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.69,
              children: List.generate(
                ShopCubit.get(context).homeModel!.data!.products.length,
                (index) => homeBuilderItem(
                  ShopCubit.get(context).homeModel!.data!.products[index],
                  context,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategories(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(model.image.toString()),
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
          Container(
            width: 100.0,
            color: Colors.black.withOpacity(0.8),
            child: Text(
              '${model.name}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  Widget homeBuilderItem(HomeProductModel model, context) => Container(
        padding: EdgeInsets.all(8.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(
                    model.image.toString(),
                  ),
                  width: double.infinity,
                  height: 200.0,
                ),
                if (model.discount > 0)
                  Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              '${model.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                height: 1.2,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
            Row(
              children: [
                Text(
                  '${model.price.round()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: defaultColor,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                if (model.discount > 0)
                  Text(
                    '${model.old_price.round()}',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12.0,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    print('ID : ${model.id}');
                    print('TOKEN : ${token}');
                    ShopCubit.get(context).changeFavorite(model.id!.toInt());
                  },
                  icon: CircleAvatar(
                    child: Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    radius: 15.0,
                    backgroundColor:
                        ShopCubit.get(context).favorites![model.id] == true
                            ? defaultColor
                            : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
