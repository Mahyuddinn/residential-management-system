import 'package:flutter/material.dart';

class QRResultPage extends StatelessWidget {
  final String data;

  const QRResultPage({required this.data});

  @override
  Widget build(BuildContext context) {
    // Log the received data
    print('Received QR Code Data: $data');

    // Split the data string by commas to get individual values
    List<String> visitorData = data.split(',');

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildDataCard(visitorData),
      ),
    );
  }

  Widget _buildDataCard(List<String> visitorData) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow('Visitor Name', visitorData[0]),
            _buildDataRow('Visitor Phone Number', visitorData[1]),
            _buildDataRow('Visitor Plate Number', visitorData[2]),
            _buildDataRow('Check-In Date', visitorData[3]),
            _buildDataRow('Check-Out Date', visitorData[4]),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 8), // Adds space between label and value
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.start,
            ),
          ),
        ],
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
        'Visitor Details',
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
