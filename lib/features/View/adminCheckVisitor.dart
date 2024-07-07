import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckVisitor extends StatefulWidget {
  const CheckVisitor({super.key});

  @override
  State<CheckVisitor> createState() => _CheckVisitorState();
}

class _CheckVisitorState extends State<CheckVisitor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Visitors').snapshots(),
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
                    document['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Status: ${document['Status']}\nCheck-in: ${document['checkInDate']} - Check-out: ${document['checkOutDate']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => VisitorDetailDialog(document),
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

class VisitorDetailDialog extends StatelessWidget {
  final DocumentSnapshot document;

  VisitorDetailDialog(this.document);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          document['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Status: ${document['Status']}'),
          SizedBox(height: 8.0),
          Text('Check-in Date: ${document['checkInDate']}'),
          SizedBox(height: 8.0),
          Text('Check-out Date: ${document['checkOutDate']}'),
          SizedBox(height: 8.0),
          Text('Phone Number: ${document['phoneNumber']}'),
          SizedBox(height: 8.0),
          Text('Plate: ${document['plate']}'),
        ],
      ),
      actions: [
        if (document['Status'] == 'pending')
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Visitors')
                  .doc(document.id)
                  .update({'Status': 'Approved'});
              Navigator.of(context).pop();
            },
            child: Text('Approve'),
          ),
        if (document['Status'] == 'pending') 
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Visitors')
                  .doc(document.id)
                  .update({'Status': 'Rejected'});
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
