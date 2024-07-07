import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residential_management_system/features/View/adminCheckVisitor.dart';
import 'package:residential_management_system/features/View/login_page.dart';
import 'package:residential_management_system/features/View/profile_page.dart';
import 'package:residential_management_system/features/View/securityScanQrCode.dart';
import 'package:residential_management_system/global/common/toast.dart';

class SecurityHomePage extends StatefulWidget {
  const SecurityHomePage({super.key});

  @override
  State<SecurityHomePage> createState() => _SecurityHomePageState();
}

class _SecurityHomePageState extends State<SecurityHomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('alerts')
        .where('status', isEqualTo: 'SOS')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var alert = snapshot.docs.first.data();
        _showAlertDialog(alert, snapshot.docs.first.id);
      }
    });
  }

  Future<void> _showAlertDialog(
      Map<String, dynamic> alert, String docId) async {
    DateTime clickTime = (alert['timestamp'] as Timestamp).toDate();
    String formattedTime = DateFormat('dd/MM/yyy HH:mm:ss').format(clickTime);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the alert
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SOS Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Resident: ${alert['name']}'),
                Text('Email: ${alert['email']}'),
                Text('Phone Number: ${alert['phonenumber']}'),
                Text('Block: ${alert['block']}'),
                Text('House Number: ${alert['housenumber']}'),
                Text('Floor: ${alert['floor']}'),
                Text('Timestamp: $formattedTime'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Dismiss'),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('alerts')
                      .doc(docId)
                      .update({'status': 'Done'});
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error updating status: $e');
                  // Optionally show an error message to the user
                }
              },
            ),
          ],
        );
      },
    );
  }

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
      title: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Residential Management System',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              user.email!,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
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
            SizedBox(height: 20),
            _buildCard(context, 'assets/images/visitors.png', 'Visitor'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String imagePath, String label) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // Navigate to the scan qr code page
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SecurityScanQr()));
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                imagePath,
                height: 80,
                width: 80,
              ),
              SizedBox(height: 20),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
            Icons.logout,
            color: Colors.white,
          ),
          label: 'Logout',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecurityHomePage()),
            );
            break;
          case 1:
            FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
            showToast(message: "Successfully signed out");
            break;
        }
      },
    );
  }
}
