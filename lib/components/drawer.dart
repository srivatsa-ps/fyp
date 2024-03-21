import 'package:flutter/material.dart';
import 'package:fyp/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  void Function()? onHomeTap;
  void Function()? onProfileTap;

  MyDrawer({super.key,
  required this.onHomeTap,
  this.onProfileTap,
 });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          //header
          DrawerHeader(child: Icon(Icons.person,
          color: Colors.white,
          size: 64,),),
          //home list tile
          MyListTile(icon: Icons.home, text: 'H O M E',onTap:onHomeTap,),
          //profile
          MyListTile(icon: Icons.person, text: 'P R O F I L E',onTap:onProfileTap,),
        ],
      ),
    );
  }
}
