import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/Controller/ResidentController.dart';
import 'package:residential_management_system/features/View/add_family.dart';
import 'package:residential_management_system/features/model/Resident.dart';

class ViewHouseholdMember extends StatefulWidget {
  @override
  State<ViewHouseholdMember> createState() => _ViewHouseholdMemberState();
}

class _ViewHouseholdMemberState extends State<ViewHouseholdMember> {

  String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Resident> residents = [];
  Resident currResident = Resident.defaultConstructor();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  
  Future<void> fetchUserData() async{
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('Resident')
        .where('email', isEqualTo: currentUserEmail)
        .limit(1)
        .get();
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData = snapshot.docs.first.data();
        currResident = Resident.fromMap(userData);
        fetchResidents();
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchResidents() async{
    residents = await ResidentController.getResidentsWithSameDetails(currResident);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Household Members',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent[700],
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: residents.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(residents[index].getname),
            subtitle: Text(residents[index].getemail),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    ResidentController.updateResident(residents[index]);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    ResidentController.deleteResident(residents[index]);
                    residents.removeAt(index);
                    setState(() {});
                  },
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Handle add new user
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFamilyMember(),
            ),
          );
        },
      ),
    );
  }

}