import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/View/adminCheckFacilities.dart';
import 'package:residential_management_system/features/View/adminCheckVisitor.dart';
import 'package:residential_management_system/features/View/adminPostDocument.dart';
import 'package:residential_management_system/features/View/adminPostNotice.dart';
import 'package:residential_management_system/features/View/home_page.dart';
import 'package:residential_management_system/features/View/login_page.dart';
import 'package:residential_management_system/features/View/profile_page.dart';
import 'package:residential_management_system/features/drawer/drawer.dart';
import 'package:residential_management_system/global/common/toast.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
    final user = FirebaseAuth.instance.currentUser!;

  void _doNothing() {}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBodyView(context),
        bottomNavigationBar: _buildBottomNavigationBar(context),

      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Residential Management System',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              user.email!,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            SizedBox(height: 5,),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.redAccent[700],
        toolbarHeight: 100,
        flexibleSpace: Container(),
      );
  }

  Center _buildBodyView(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton(context, 'assets/images/visitors.png', 'Visitor'),
                  _buildButton(context, 'assets/images/facility.png', 'Facilities'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton(context, 'assets/images/notifications.png', 'Notices'),
                  _buildButton(context, 'assets/images/documentation.png', 'Documents'),
                ],
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildButton(BuildContext context, String imagePath, String label) {
    Color boxColor = Color.fromRGBO(255, 255, 255, 0.5);
    Color textColor = Colors.black87;
    if (label == 'Help!') {
      boxColor = Colors.white;
      textColor = Colors.black;
    }
    return GestureDetector(
      onTap: () {
        // navigate to the respective page based on the label
        switch (label) {
          case 'Help!':
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => Help()),
            // );
            break;

          case 'Facilities':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckFacility()),
            );
            break;

          case 'Visitor':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckVisitor()),
            );
            break;

          case 'Documents':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostDocument()),
            );
            break;

          case 'Notices':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostNotice()),
            );
            break;

          default:
            break;
        }
        // change the color of the button when clicked
        if (label != 'Help!') {
          boxColor = Colors.red; // modify the color based on the requirement
        }
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(75),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imagePath,
              height: 50,
              width: 50,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      backgroundColor: Colors.redAccent[700],
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          label: 'Home',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
          label: 'Profile',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminHomePage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            break;
        }
      },
    );
  }

}