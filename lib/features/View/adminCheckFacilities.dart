import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckFacility extends StatefulWidget {
  const CheckFacility({super.key});

  @override
  State<CheckFacility> createState() => _CheckFacilityState();
}

class _CheckFacilityState extends State<CheckFacility> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Bookings').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No visitors found.'));
          }

          return SingleChildScrollView(
            child: Column(
              children: snapshot.data!.docs.map((document) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      document['residentName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Facility: ${document['facilityName']}\nTimeslot: ${document['timeSlot']}\nStatus: ${document['status']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder: (context) => FacilityDetailDialog(document),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Normal Visitor',
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

class FacilityDetailDialog extends StatelessWidget{
  final DocumentSnapshot document;

  FacilityDetailDialog(this.document);

  @override
  Widget build (BuildContext context) {
    DateTime bookedTime = (document['timestamp'] as Timestamp).toDate();
    String formattedTime = DateFormat('dd/MM/yyyy').format(bookedTime);
    return AlertDialog(
      title: Center(
        child: Text(
          document['residentName'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Facility: ${document['facilityName']}'),
          SizedBox(height: 8.0),
          Text('Phone Number: ${document['residentPhoneNumber']}'),
          SizedBox(height: 8.0),
          Text('Date: ${document['date']}'),
          SizedBox(height: 8.0),
          Text('Timeslot: ${document['timeSlot']}'),
          SizedBox(height: 8.0),
          Text('Time booked: $formattedTime'),
        ],
      ),
      actions: [
        if (document['status'] == 'pending')
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Bookings')
                  .doc(document.id)
                  .update({'status': 'Approved'});
              Navigator.of(context).pop();
            },
            child: Text('Approve'),
          ),
        if (document['status'] == 'pending')
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Bookings')
                  .doc(document.id)
                  .update({'status': 'Rejected'});
              Navigator.of(context).pop();
            },
            child: Text('Rejected'),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
