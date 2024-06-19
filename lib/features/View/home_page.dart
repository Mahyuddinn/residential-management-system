import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/View/contact.dart';
import 'package:residential_management_system/features/View/facilitiesPage.dart';
import 'package:residential_management_system/features/View/payMaintananceFee.dart';
import 'package:residential_management_system/features/View/viewDocuments.dart';
import 'package:residential_management_system/features/View/viewNotices.dart';
import 'package:residential_management_system/features/View/visitorHome.dart';
import 'package:residential_management_system/features/drawer/drawer.dart';
import 'package:residential_management_system/features/View/profile_page.dart';
import 'package:residential_management_system/features/View/login_page.dart';
import 'package:residential_management_system/global/common/toast.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  void _doNothing() {}

  Future<void> _sendSOSAlert() async {
    final confirmation = await _showConfirmationDialog(context);
    if (confirmation) {
      final residentDoc = FirebaseFirestore.instance.collection('Resident').doc(user.email!);
      final residentData = await residentDoc.get();
      if (residentData.exists) {
        final data = residentData.data();
        await FirebaseFirestore.instance.collection('alerts').add({
          'status': 'SOS',
          'email': user.email,
          'name': data!['name'],
          'phonenumber': data['phoneno'],
          'block': data['block'],
          'housenumber': data['housenumber'],
          'floor': data['floor'],
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm SOS Alert'),
          content: Text('Are you sure you want to send an SOS alert to the security guard?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Send'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: _buildAppBar(context),
        drawer: _buildMyDrawer(context),
        body: _buildBodyView(context),
        bottomNavigationBar: _buildBottomNavigationBar(context),

      ),
    );
  }

  MyDrawer _buildMyDrawer(BuildContext context) {
    return MyDrawer(
        onProfileTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),),);
        },
        onSignOut: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
          showToast(message: "Successfully signed out");
        },
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
            GestureDetector(
              onTap: _sendSOSAlert,
              child: Image.asset('assets/images/sos.png',
                height: 120,),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.redAccent[700],
        toolbarHeight: 200,
        flexibleSpace: Container(),
      );
  }

  Center _buildBodyView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildButton(context, 'assets/images/contacts.png', 'Contacts'),
                _buildButton(context, 'assets/images/facility.png', 'Facilities'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildButton(context, 'assets/images/visitors.png', 'Visitor'),
                _buildButton(context, 'assets/images/documentation.png', 'Documents'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildButton(context, 'assets/images/notifications.png', 'Notices'),
                _buildButton(context, 'assets/images/bill.png', 'Billing'),
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

          case 'Contacts':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactsListPage()),
            );
            break;

          case 'Facilities':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FacilitiesPage()),
            );
            break;

          case 'Visitor':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VisitorHome()),
            );
            break;

          case 'Documents':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewDocuments()),
            );
            break;

          case 'Notices':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewNotices()),
            );
            break;

          case 'Billing':
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => BillingPage()),
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