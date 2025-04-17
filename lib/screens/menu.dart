import 'package:flutter/material.dart';
import 'about.dart';
import 'profile.dart';

List<String> menuList = ['About', 'Profile'];

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  Widget menuTile(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => switch (menuList[index]) {
                  'About' => AboutPage(),
                  'Profile' => ProfilePage(),
                  String() => throw UnimplementedError(),
                },
          ),
        );
      },
      title: Column(children: [Text(menuList[index])]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: menuList.length,
            itemBuilder: menuTile,
          ),
        ],
      ),
    );
  }
}
