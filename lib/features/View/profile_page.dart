import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/View/edit_profile.dart';
import 'package:residential_management_system/features/View/login_page.dart';
import 'package:residential_management_system/features/View/view_family_members.dart';
import 'package:residential_management_system/features/model/Resident.dart';
import 'package:residential_management_system/features/View/home_page.dart';
import 'package:residential_management_system/global/common/toast.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage();

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  Resident currResident = Resident.defaultConstructor();
  final String Email = FirebaseAuth.instance.currentUser!.email.toString();
  
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async{
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('Resident')
        .where('email', isEqualTo: Email)
        .limit(1)
        .get();
      if (snapshot.docs.isNotEmpty){
        userData = snapshot.docs.first.data();
        currResident = Resident.fromMap(userData!);
        setState(() {});
      }
    }catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent[700],
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
          showToast(message: "Successfully signed out");
        },
        label: const Text(
          'Log Out',
          style: TextStyle(
              fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent[700],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ProfileContainer(context),
      bottomNavigationBar: _BottomNavigationBar(context),
    );
  }

  Container ProfileContainer(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: CircleAvatar(
                  radius: 40.0,
                ),
              ),
              Column(
                children: [
                  Text(
                    currResident.name,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currResident.residentname,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                  icon: Icon(Icons.edit_square),
                  color: Colors.black87,
                  iconSize: 25.0,
                ),
              ),
            ],
          ),
          Divider(
            height: 10.0,
            color: Colors.grey[800],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.home,
                  color: Colors.black87,
                  size: 35.0,
                ),
                /* Text(
                  'Setup of Family Members/Tenants',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ), */
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewHouseholdMember()));
                  },
                  child: Text(
                    'Setup of Family Members/Tenants',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.question_answer,
                  color: Colors.black87,
                  size: 35.0,
                ),
                Text(
                  'FAQ & Tutorial',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

    BottomNavigationBar _BottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      items: <BottomNavigationBarItem>[
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
      backgroundColor: Colors.redAccent[700],
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