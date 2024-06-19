import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class PostDocument extends StatefulWidget {
  const PostDocument({super.key});

  @override
  State<PostDocument> createState() => _PostDocumentState();
}

class _PostDocumentState extends State<PostDocument> {
  File? selectedPdfFile;

  Future<void> selectPdfFile() async {
    // open a file picker to select to PDF file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedPdfFile = File(result.files.single.path!);
        print('pdf selected: ' + selectedPdfFile.toString());
      });
    } else {
      print('No pdf selected');
    }
  }

  Future<void> uploadFileToFirebase() async {
    if (selectedPdfFile != null) {
      try {
        //create a reference to the Firebase Storage Location
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('Documents/${basename(selectedPdfFile!.path)}');

        //upload the PDF file to Firebase Storage
        final UploadTask = await storageRef.putFile(selectedPdfFile!);

        //Get the download URL of the uploaded PDF
        final downloadUrl = await UploadTask.ref.getDownloadURL();

        print('PDF uploaded successfully. Download URL: $downloadUrl');

        // Save additional data to the Realtime Database
        final documentData = {
          'downloadurl': downloadUrl,
          'fileName': basename(selectedPdfFile!.path),
          'uploadedAt': Timestamp.now(),
        };
        print('Saving document data to database: $documentData');

        await FirebaseFirestore.instance
            .collection('Documents')
            .add(documentData)
            .then((docRef) {
          print(
              'Document saved successfully to Firestore with ID: ${docRef.id}');
        }).catchError((error) {
          print('Error saving document to Firestore: $error');
        });

        //Reset the selected file after successful upload
        setState(() {
          selectedPdfFile = null;
        });
      } catch (e) {
        print('Error uploading PDF: $e');
      }
    } else {
      print('No PDF file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedPdfFile != null)
              Expanded(
                child: Container(
                  color: Colors.grey[350],
                  child: Center(
                    child: Text(selectedPdfFile!.path),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: selectPdfFile,
              child: Text('Select File'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: uploadFileToFirebase,
              child: Text('Upload File'),
            ),
          ],
        ),
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
