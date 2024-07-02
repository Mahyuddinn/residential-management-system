import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/View/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _amountController = TextEditingController();
  final String _apiKey = 'ac3bde40-da73-4895-ba1e-8498bd71b47b';
  final String _collectionId = 'rraupvz0';
  bool _isLoading = false;
  String? _userName;
  double _totalMaintenanceFees = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchTotalMaintenanceFees();
  }

  Future<void> _fetchUserName() async {
    try {
      print('USER EMAIL: $user.email');
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Resident')
          .doc(user.email)
          .get();

      if (doc.exists) {
        setState(() {
          _userName = doc['name'];
        });
        print('User name fetched successfully: $_userName');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  Future<void> _fetchTotalMaintenanceFees() async {
    FirebaseFirestore.instance
        .collection('Resident')
        .doc(user.email)
        .snapshots()
        .listen((docSnapshot) {
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('totalMaintenanceFees')) {
          setState(() {
            _totalMaintenanceFees = data['totalMaintenanceFees'] ?? 0.0;
          });
          print('Fetched total maintenance fees: $_totalMaintenanceFees');
        } else {
          print('totalMaintenanceFees field does not exist, initializing...');
          _initializeTotalMaintenanceFees();
        }
      } else {
        print('Document does not exist, initializing...');
        _initializeTotalMaintenanceFees();
      }
    }, onError: (error) {
      print('Error fetching total maintenance fees: $error');
    });
  }

  Future<void> _initializeTotalMaintenanceFees() async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('Resident').doc(user.email);

      // First, get the current document data
      DocumentSnapshot docSnap = await docRef.get();
      Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>? ?? {};

      // If totalMaintenanceFees doesn't exist, calculate it from maintenanceFees
      if (!data.containsKey('totalMaintenanceFees')) {
        List<dynamic> maintenanceFees = data['maintenanceFees'] ?? [];
        double total = maintenanceFees.fold(
            0.0, (sum, fee) => sum + (fee['amount'] ?? 0.0));

        // Update the document with the calculated totalMaintenanceFees
        await docRef.set({
          'totalMaintenanceFees': total,
        }, SetOptions(merge: true));

        setState(() {
          _totalMaintenanceFees = total;
        });
      } else {
        // If totalMaintenanceFees already exists, just use its value
        setState(() {
          _totalMaintenanceFees = data['totalMaintenanceFees'] ?? 0.0;
        });
      }

      print(
          'Initialized total maintenance fees successfully: $_totalMaintenanceFees');
    } catch (e) {
      print('Error initializing total maintenance fees: $e');
    }
  }

  Future<void> _createBill() async {
    if (_userName == null) {
      print('User name is not available');
      return;
    }

    double paidAmount = double.tryParse(_amountController.text) ?? 0.0;
    if (paidAmount <= 0 || paidAmount > _totalMaintenanceFees) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid payment amount')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String url = 'https://www.billplz-sandbox.com/api/v3/bills';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode("$_apiKey:"))}',
        },
        body: jsonEncode({
          'collection_id': _collectionId,
          'email': user.email,
          'name': _userName,
          'amount': (paidAmount * 100).toInt(),
          'callback_url': 'https://callback-nnvacxxqwa-uc.a.run.app',
          'description': 'Maintenance Fee',
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> bill = jsonDecode(response.body);
        final String paymentUrl = bill['url'];
        final String billId = bill['id'];
        print('Payment URL: $paymentUrl');

        _openPaymentUrl(paymentUrl);
        _pollPaymentStatus(billId, paidAmount);

        // Clear the text field after successful bill creation
        _amountController.clear();
      } else {
        print('Error creating bill: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create bill. Please try again.')),
        );
      }
    } catch (e) {
      print('Error in _createBill: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateTotalMaintenanceFees() async {
    try {
      await FirebaseFirestore.instance
          .collection('Resident')
          .doc(user.email)
          .update({
        'totalMaintenanceFees': _totalMaintenanceFees,
      });
      print(
          'Total maintenance fees updated successfully: $_totalMaintenanceFees');
    } catch (e) {
      print('Error updating total maintenance fees: $e');
    }
  }

  void _pollPaymentStatus(String billId, double paidAmount) {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      final String url = 'https://www.billplz-sandbox.com/api/v3/bills/$billId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode("$_apiKey:"))}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> bill = jsonDecode(response.body);
        final bool isPaid = bill['paid'];
        if (isPaid) {
          timer.cancel();
          // Update the UI or Firestore
          await _updatePaymentStatus(billId, isPaid, paidAmount);
          print('Payment Succesful');

          // Refresh the total maintenance fees
          await _fetchTotalMaintenanceFees();
        }
      } else {
        print('Error fethching bill status: ${response.body}');
      }
    });
  }

  Future<void> _updatePaymentStatus(
      String billId, bool isPaid, double paidAmount) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference docRef =
            FirebaseFirestore.instance.collection('Resident').doc(user.email);
        DocumentSnapshot docSnapshot = await transaction.get(docRef);

        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          List<dynamic> feesList = data['maintenanceFees'] ?? [];
          double currentTotal = data['totalMaintenanceFees'] ?? 0.0;
          double newTotal = currentTotal - paidAmount;

          // Update payment status in feesList
          for (var fee in feesList) {
            if (!fee.containsKey('paid') || fee['paid'] == false) {
              fee['paid'] = isPaid;
              break;
            }
          }

          transaction.update(docRef, {
            'maintenanceFees': feesList,
            'totalMaintenanceFees': newTotal,
          });

          transaction.set(docRef.collection('bills').doc(billId), {
            'payment_status': isPaid ? 'paid' : 'unpaid',
            'bill_id': billId,
            'amount': paidAmount,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      });

      print('Payment status and total maintenance fees updated successfully');
    } catch (e) {
      print('Error updating payment status and total maintenance fees: $e');
    }
  }

  void _openPaymentUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Maintenance Fees',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'RM ${_totalMaintenanceFees.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Make Payment',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount (RM)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _createBill,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Pay Maintenance Fee',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
