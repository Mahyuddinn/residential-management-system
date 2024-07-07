import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:residential_management_system/features/Controller/VisitorController.dart';
import 'package:residential_management_system/features/View/qrImage.dart';
import 'package:residential_management_system/features/model/Visitor.dart';

class NormalVisitorForm extends StatefulWidget {
  const NormalVisitorForm({super.key});

  @override
  State<NormalVisitorForm> createState() => _NormalVisitorFormState();
}

class _NormalVisitorFormState extends State<NormalVisitorForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _checkInDateController = TextEditingController();
  final TextEditingController _checkOutDateController = TextEditingController();
  DateTime todayDate = DateTime.now();
  String residentName = '';
  String qrCodeData = '';

  @override
  void initState() {
    super.initState();
    _getResidentName();
  }

  Future<void> _getResidentName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch the resident document based on the user's email
      var residentDoc = await FirebaseFirestore.instance
          .collection('Resident')
          .where('email', isEqualTo: user.email)
          .get();

      if (residentDoc.docs.isNotEmpty) {
        setState(() {
          residentName = residentDoc.docs.first['residentname'];
        });
      }
    }
  }

  void _submitForm() async {
    //get form data
    String name = _nameController.text;
    String phoneNumber = _phoneNumberController.text;
    String plate = _plateController.text;
    String checkInDate = _checkInDateController.text;
    String checkOutDate = _checkOutDateController.text;
    String applicantName = residentName;

    //create visitor object
    Visitor visitor = Visitor(
      name: name,
      phoneNumber: phoneNumber,
      plate: plate,
      checkInDate: todayDate.toString().split(" ")[0],
      checkOutDate: todayDate.toString().split(" ")[0],
      Status: 'Approved',
      applicantName: applicantName,
    );

    //save visitor data and get the visitore ID
    String visitorId = await VisitorController.saveVisitor(visitor);

    if (visitorId.isNotEmpty) {
      //clear form
      _nameController.clear();
      _phoneNumberController.clear();
      _plateController.clear();

      //show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Visitor has successfully registered')),
      );

      generateQrCode(visitor, visitorId);
    } else {
      // Handle the error appropriately
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register visitor')),
      );
    }
  }

  void _cancelForm() {
    //clear form
    _nameController.clear();
    _phoneNumberController.clear();
    _plateController.clear();

    //show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration cancelled')),
    );
  }

  void generateQrCode(Visitor visitor, String visitorId) {
    // Construct the QR code data
    String qrCodeData = VisitorController.generateQrString(visitor);

    print('QR CODE DATA: $qrCodeData AND $visitorId');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrImagePage(qrCodeData, visitorId, 200),
      ),
    );

    //show a dialog with the QR Code
    /*showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('QR Code'),
            content: Container(
              child: QrImageView(
                data: qrCodeData,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: Text('close'),
              ),
            ],
          );
        },
      );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarNormalVisitorForm(context),
      body: _bodyNormalVisitorForm(context),
    );
  }

  AppBar _appBarNormalVisitorForm(BuildContext context) {
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

  SingleChildScrollView _bodyNormalVisitorForm(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 50.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Register Normal Visitor',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.grey[800],
                      size: 35.0,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                    labelText: 'Visitor Name',
                    labelStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  controller: _nameController,
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.grey[800],
                      size: 35.0,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                    labelText: 'Visitor Phone Number',
                    labelStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  controller: _phoneNumberController,
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.grey[800],
                      size: 35.0,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                    labelText: 'Visitor Plate Number',
                    labelStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  controller: _plateController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buttonSubmit(),
                    _buttonCancel(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buttonSubmit() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: ElevatedButton(
        onPressed: () {
          _submitForm();
        },
        child: Text(
          'Submit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.lightGreenAccent[700])),
      ),
    );
  }

  Padding _buttonCancel() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: FloatingActionButton.extended(
        onPressed: _cancelForm,
        label: Text(
          'Cancel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[800],
      ),
    );
  }
}
