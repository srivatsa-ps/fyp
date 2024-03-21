import 'package:flutter/material.dart';
import 'package:fyp/components/my_list_tile.dart';

class MyGameDrawer extends StatelessWidget {
  void Function()? onHomeTap;
  void Function()? onGameTap;

  MyGameDrawer({super.key,
    required this.onHomeTap,
    this.onGameTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          //header
          DrawerHeader(child: Icon(Icons.gamepad,
            color: Colors.white,
            size: 64,),),
          //home list tile
          MyListTile(icon: Icons.home, text: 'H O M E',onTap:onHomeTap,),
          //profile
          MyListTile(icon: Icons.abc, text: 'G A M E S',onTap:onGameTap,),
        ],
      ),
    );
  }
}
