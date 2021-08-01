import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search_screen/cubit/cubit.dart';
import 'package:shop_app/modules/search_screen/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:shop_app/shop_cubit/app_cubit.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
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
            body: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  defaultTextFromField(
                    controller: searchController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter search keyword';
                    },
                    prefix: Icons.search,
                    label: 'Search',
                    type: TextInputType.text,
                    onSubmitted: (text) {
                      SearchCubit.get(context).getSearchData(text: text);
                      print(
                        SearchCubit.get(context)
                            .searchModel!
                            .data!
                            .data[0]
                            .name,
                      );
                    },
                    onChanged: (text) {
                      SearchCubit.get(context).getSearchData(text: text);
                      print(
                        SearchCubit.get(context)
                            .searchModel!
                            .data!
                            .data[0]
                            .name,
                      );
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  if (state is SearchLoadingState) LinearProgressIndicator(),
                  if (state is SearchSuccessState)
                    Expanded(
                        child: ListView.separated(
                      itemBuilder: (context, index) => buildSearchList(
                          context,
                          SearchCubit.get(context)
                              .searchModel!
                              .data!
                              .data[index]),
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsetsDirectional.only(start: 20.0),
                        child: Container(
                          color: Colors.grey[300],
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                      itemCount: SearchCubit.get(context)
                          .searchModel!
                          .data!
                          .data
                          .length,
                    )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchList(context, SearchData model) => Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(
                model.image.toString(),
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
                    model.name.toString(),
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
                        '${model.price.toInt()}',
                        style: TextStyle(
                          color: defaultColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorite(model.id!);
                        },
                        icon: CircleAvatar(
                          child: Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          radius: 15.0,
                          backgroundColor:
                              ShopCubit.get(context).favorites![model.id] ==
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
