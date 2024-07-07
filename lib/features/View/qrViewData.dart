import 'package:flutter/material.dart';

class QRResultPage extends StatelessWidget {
  final String data;

  const QRResultPage({required this.data});

  @override
  Widget build(BuildContext context) {
    // Split the data string by commas to get individual values
    List<String> visitorData = data.split(',');

    return Scaffold(
      appBar: AppBar(title: Text('QR Code Result')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Visitor Name: ${visitorData[0]}',
                style: TextStyle(fontSize: 18)),
            Text('Visitor Phone Number: ${visitorData[1]}',
                style: TextStyle(fontSize: 18)),
            Text('Visitor Plate Number: ${visitorData[2]}',
                style: TextStyle(fontSize: 18)),
            Text('Check-In Date: ${visitorData[3]}',
                style: TextStyle(fontSize: 18)),
            Text('Check-Out Date: ${visitorData[4]}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
