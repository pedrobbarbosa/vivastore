import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            // color: hexToColor('#EB690A'),
            child: Image(
              image: AssetImage('assets/images/logo.png'),
              width: 125,
              height: 180,
            )
            // child: Text(
            //   title,
            //   style: Theme.of(context)
            //       .textTheme
            //       .headline2!
            //       .copyWith(color: Colors.white),
            // ),
            ),
        iconTheme: IconThemeData(color: Colors.redAccent),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/wishlist',
              );
            },
          ),
        ],
      ),
    );
  }

  Size get preferredSize => Size.fromHeight(50.0);
}
