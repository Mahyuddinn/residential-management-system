import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:residential_management_system/features/View/visitorHome.dart';

class VisitorStatusPage extends StatefulWidget {
  const VisitorStatusPage({super.key});

  @override
  State<VisitorStatusPage> createState() => _VisitorStatusPageState();
}

class _VisitorStatusPageState extends State<VisitorStatusPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildVisitorStatusList(),
    );
  }

  Widget _buildVisitorStatusList() {
    User? user = _auth.currentUser;
    if (user == null) {
      return Center(child: Text("No user is currently signed in."));
    }

    String userEmail = user.email ?? '';
    print("Current user email: $userEmail");

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Resident')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> residentSnapshot) {
          if (!residentSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          print("Found ${residentSnapshot.data!.docs.length} residents");

          if (residentSnapshot.data!.docs.isEmpty) {
            return Center(child: Text("Resident not found. Email: $userEmail"));
          }

          var residentDoc = residentSnapshot.data!.docs.first;
          var residentData = residentDoc.data() as Map<String, dynamic>?;

          if (residentData == null) {
            return Center(child: Text("Error: Resident data is null"));
          }

          String? residentName;
          if (residentData.containsKey('residentname')) {
            residentName = residentData['residentname'];
          } else if (residentData.containsKey('residentName')) {
            residentName = residentData['residentName'];
          }

          if (residentName == null || residentName.isEmpty) {
            return Center(
                child: Text("Error: Resident name not found in database"));
          }

          print("Resident name: $residentName");

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Visitors')
                .where('applicantName', isEqualTo: residentName)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> visitorSnapshot) {
              if (!visitorSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var visitorDocs = visitorSnapshot.data!.docs;

              if (visitorDocs.isEmpty) {
                return Center(
                    child: Text("No visitors found for the current user."));
              }

              return ListView.builder(
                itemCount: visitorDocs.length,
                itemBuilder: (context, index) {
                  var visitorData =
                      visitorDocs[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(visitorData['name'] ?? 'Unknown'),
                      subtitle: Text('Status: ${visitorData['Status']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed:() => _confirmDelete(context, visitorDocs[index].id),
                      ),
                    ),
                  );
                },
              );
            },
          );
        });
  }

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Application'),
        content: Text('Are you sure you want to delete this application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteApplication(docId);
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _deleteApplication(String docId) async {
    await FirebaseFirestore.instance.collection('Visitors').doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Application deleted successfully')),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VisitorHomePage()),
          );
        },
      ),
      title: Text(
        'Visitor Application Status',
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
}
