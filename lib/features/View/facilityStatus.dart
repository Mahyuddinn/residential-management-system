import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/View/facilitiesPage.dart';
import 'package:residential_management_system/features/View/viewFacility.dart';

class ViewBookingStatusPage extends StatefulWidget {
  const ViewBookingStatusPage({super.key});

  @override
  State<ViewBookingStatusPage> createState() => _ViewBookingStatusPageState();
}

class _ViewBookingStatusPageState extends State<ViewBookingStatusPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBookingStatusList(),
    );
  }

  Widget _buildBookingStatusList() {
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

        if (residentSnapshot.data!.docs.isEmpty) {
          return Center(child: Text("Resident not found. Email: $userEmail"));
        }

        var residentDoc = residentSnapshot.data!.docs.first;
        var residentData = residentDoc.data() as Map<String, dynamic>?;

        if (residentData == null) {
          return Center(child: Text("Error: Resident data is null"));
        }

        String residentName = residentData['residentname'] ?? residentData['residentName'] ?? 'Unknown';
        print("Resident name: $residentName");

        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Bookings')
              .where('residentName', isEqualTo: residentName)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> bookingSnapshot) {
            if (!bookingSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var bookingDocs = bookingSnapshot.data!.docs;
             print("Number of bookings found: ${bookingDocs.length}");

            if (bookingDocs.isEmpty) {
              return Center(
                  child: Text("No bookings found for the current user."));
            }

            return ListView.builder(
              itemCount: bookingDocs.length,
              itemBuilder: (context, index) {
                var bookingData =
                    bookingDocs[index].data() as Map<String, dynamic>;
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(bookingData['facilityName'] ?? 'Unknown'),
                    subtitle: Text('Status: ${bookingData['status']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () =>
                          _confirmDelete(context, bookingDocs[index].id),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Booking'),
        content: Text('Are you sure you want to delete this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteBooking(docId);
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _deleteBooking(String docId) async {
    await FirebaseFirestore.instance.collection('Bookings').doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking deleted successfully')),
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FacilitiesPage()),
        );
      },
    ),
    title: Text(
      'Facility Application Status',
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
