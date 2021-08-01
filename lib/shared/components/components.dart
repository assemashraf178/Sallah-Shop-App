import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shared/styles/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = defaultColor,
  bool isUpperCase = true,
  double radius = 5,
  double height = 50.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
        elevation: 50.0,
      ),
    );

Widget defaultTextButton({
  required Function function,
  required String text,
}) =>
    TextButton(
        onPressed: () {
          function();
        },
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));

Widget defaultTextFromField({
  required TextEditingController controller,
  Function? onSubmitted,
  Function? onChanged,
  required FormFieldValidator? validator,
  bool isPassword = false,
  required IconData prefix,
  Icon? suffix,
  IconButton? suffixButton,
  required String label,
  required TextInputType type,
}) =>
    TextFormField(
      controller: controller,
      onFieldSubmitted: (s) {
        onSubmitted!(s);
      },
      onChanged: (s) {
        onChanged!(s);
      },
      validator: validator,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null ? suffix : suffixButton,
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );

Widget articleItem(article, context) {
  return InkWell(
    onTap: () {},
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  '${article['urlToImage']}',
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Container(
              height: 120.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${article['title']}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Text(
                    '${article['publishedAt']}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget articleBuilder(article, context, {bool isSearch = false}) {
  if (article.length > 0) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) => articleItem(article[index], context),
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsetsDirectional.only(start: 20.0),
        child: Container(
          height: 1,
          color: Colors.grey[300],
        ),
      ),
      itemCount: article.length,
    );
  } else {
    return isSearch ? Container() : Center(child: CircularProgressIndicator());
  }
}

void navigateTo(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ));
}

void navigateToAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => widget),
      (route) => false);
}

void showToast({
  required String msg,
  required ToastColor state,
}) {
  Fluttertoast.showToast(
    msg: msg,
    fontSize: 16.0,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: changeToastColor(state),
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 5,
  );
}

enum ToastColor { SUCCESS, ERROR, WARNING }

Color changeToastColor(ToastColor state) {
  switch (state) {
    case ToastColor.SUCCESS:
      return Colors.green;
    case ToastColor.ERROR:
      return Colors.red;
    case ToastColor.WARNING:
      return Colors.amber;
    default:
      return Colors.blue;
  }
}
