import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentHistoryPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Resident')
            .doc(user.email)
            .collection('bills')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching payment history'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final payments = snapshot.data?.docs ?? [];

          if (payments.isEmpty) {
            return Center(child: Text('No payment history available'));
          }

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              final amount = payment['amount'];
              final status = payment['payment_status'];
              final timestamp = (payment['timestamp'] as Timestamp).toDate();

              return ListTile(
                title: Text('Amount: RM${amount.toStringAsFixed(2)}'),
                subtitle: Text(
                    'Status: $status\nDate: ${timestamp.toLocal().toString()}'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Payment Details'),
                      content: Text(
                          'Amount: RM${amount.toStringAsFixed(2)}\nStatus: $status\nDate: ${timestamp.toLocal().toString()}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
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
          SizedBox(
            height: 5,
          ),
        ],
      ),
      centerTitle: false,
      backgroundColor: Colors.redAccent[700],
      toolbarHeight: 100,
      flexibleSpace: Container(),
    );
  }
}
