import 'package:flutter/material.dart';
import 'package:residential_management_system/features/drawer/my_list_title.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white38,
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.black,
              size: 64,
            ),
          ),

          MyListTitle(
            icon: Icons.home, 
            text: 'H O M E', 
            onTap: () => Navigator.pop(context),
          ),

          MyListTitle(
            icon: Icons.person, 
            text: 'P R O F I L E', 
            onTap: onProfileTap,
          ),

          MyListTitle(
            icon: Icons.logout, 
            text: 'L O G O U T', 
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}