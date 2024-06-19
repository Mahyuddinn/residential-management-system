import 'package:flutter/material.dart';
import 'package:residential_management_system/features/View/home_page.dart';
import 'package:residential_management_system/features/View/normalVisitorForm.dart';
import 'package:residential_management_system/features/View/overnightVisitorForm.dart';
import 'package:residential_management_system/features/View/profile_page.dart';

class VisitorHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: VisitorHomePage(),
    );
  }
}

class VisitorHomePage extends StatefulWidget {
  @override
  State<VisitorHomePage> createState() => _VisitorHomePageState();
}

class _VisitorHomePageState extends State<VisitorHomePage> {

  void _doNothing() {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
      title: Text(
        'Purpose of Visit',
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.redAccent[700],
      elevation: 0.0,
    );
  }

  Center _buildBody(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50,),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => NormalVisitorForm())
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/car.png',
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 10,),
                Text(
                  'Visitor',
                  style: TextStyle(color: Colors.white, fontSize: 38),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent[700],
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 125),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle add new user
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OvernightVisitorForm()),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/day-and-night.png',
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 10),
                Text(
                  'Overnight',
                  style: TextStyle(color: Colors.white, fontSize: 38),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent[700],
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
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
              MaterialPageRoute(builder: (context) => HomePage()),
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