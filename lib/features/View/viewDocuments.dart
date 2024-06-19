import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewDocuments extends StatefulWidget {
  const ViewDocuments({super.key});

  @override
  State<ViewDocuments> createState() => _ViewDocumentsState();
}

class _ViewDocumentsState extends State<ViewDocuments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Documents').snapshots(),
        builder: (context, snapshot) {
          // Debug prints to check the state of the snapshot
          print('Snapshot Connection State: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Loading data...');
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No Documents Found');
            return Center(
              child: Text('No Documents Found'),
            );
          }

          final documents = snapshot.data!.docs;

          return Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  final fileName = document['fileName'];
                  final downloadUrl = document['downloadurl'];
                  final uploadedAt =
                      (document['uploadedAt'] as Timestamp).toDate();
            
                  // Formatting uploadedAt using Dart's DateTime class
                  final uploadedAtFormatted =
                      '${uploadedAt.month}/${uploadedAt.day}/${uploadedAt.year}';
            
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        fileName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Uploaded on: $uploadedAtFormatted',
                      ),
                      leading: Icon(Icons.file_download),
                      trailing: IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () =>
                            _downloadFile(context, fileName, downloadUrl),
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }

  void _downloadFile(
      BuildContext context, String fileName, String downloadUrl) async {
    print('Downloading file: $fileName');
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Documents/$fileName');
    print('Storage reference: ${ref.fullPath}');

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filePath = '${appDocDir.path}/$fileName';
    print('Local file path: $filePath');

    File downloadToFile = File(filePath);

    try {
      await ref.writeToFile(downloadToFile);
      print('File downloaded successfully.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Downloaded $fileName to $filePath'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to download $fileName: $e'),
      ));
      print('Failed to download $fileName: $e');
    }
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
        'Documents',
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
