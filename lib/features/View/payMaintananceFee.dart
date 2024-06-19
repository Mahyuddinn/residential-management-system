import 'dart:convert';
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

  Future<void> _createBill() async {
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
        'name': user.displayName,
        'amount': int.parse(_amountController.text) * 100,
        'callback_url': '',
        'description': 'Maintenance Fee',
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> bill = jsonDecode(response.body);
      final String paymentUrl = bill['url'];
      // Open the payent URL in a web view or browser
      _openPaymentUrl(paymentUrl);
    }else {
      // Handle the error
      print('Error creating bill: ${response.body}');
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
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount (RM)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createBill,
              child: Text('Pay Maintenance Fee'),
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Image.asset(
              'assets/images/sos.png',
              height: 120,
            ),
          ),
        ],
      ),
      centerTitle: false,
      backgroundColor: Colors.redAccent[700],
      toolbarHeight: 200,
      flexibleSpace: Container(),
    );
  }
}
