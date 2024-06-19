import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/Controller/VisitorController.dart';
import 'package:residential_management_system/features/View/home_page.dart';
import 'package:residential_management_system/features/View/profile_page.dart';
import 'package:residential_management_system/features/incMaterial/textfield.dart';
import 'package:residential_management_system/features/model/Visitor.dart';

class OvernightVisitorForm extends StatefulWidget {
  @override
  State<OvernightVisitorForm> createState() => _OvernightVisitorFormState();
}

class _OvernightVisitorFormState extends State<OvernightVisitorForm> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _checkInDateController = TextEditingController();
  final TextEditingController _checkOutDateController = TextEditingController();
  String? choosenDate;
  //DateTime _checkInDate = DateTime.now();
  //DateTime _checkOutDate = DateTime.now();

  Future<void> _showDatePicker(bool isCheckInDate) async{
    DateTime? pickedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2030)
    );

    if (pickedDate != null) {
      setState(() {
        if (isCheckInDate) {
          _checkInDateController.text = pickedDate.toString().split(" ")[0];
        } else {
          _checkOutDateController.text = pickedDate.toString().split(" ")[0];
        }
        
      });
    }
  }

  void _submitForm() {
    //Get the form data
    String name = _nameController.text;
    String phoneNumber = _phoneNumberController.text;
    String plate = _plateController.text;
    String _checkInDate = _checkInDateController.text;
    String _checkOutDate = _checkOutDateController.text;

    //Create the visitor object
    Visitor visitor = Visitor(
      name: name, 
      phoneNumber: phoneNumber, 
      plate: plate,
      checkInDate: _checkInDate,
      checkOutDate: _checkOutDate,
      Status: 'pending',
    );

    //save the visitor data
    VisitorController.saveVisitor(visitor);

    //clear the form
    _nameController.clear();
    _phoneNumberController.clear();
    _plateController.clear();
    _checkInDateController.clear();
    _checkOutDateController.clear();

    //show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('visitor data saved successfully'),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  AppBar  _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
      title: Text(
        'Overnight Visitor Form',
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

  SingleChildScrollView _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20.0,),
            MyTextField(
              controller: _nameController,
              hintText: 'Name', 
              obscureText: false
            ),
            SizedBox(height: 10.0),
            MyTextField(
              controller: _phoneNumberController,
              hintText: 'Phone Number', 
              obscureText: false
            ),
            SizedBox(height: 10.0),
            MyTextField(
              controller: _plateController,
              hintText: 'Plate Number', 
              obscureText: false
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _checkInDateController,
              decoration: InputDecoration(
                labelText: 'Check In Date',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue,)
                ),
              ),
              readOnly: true,
              onTap: () => _showDatePicker(true),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _checkOutDateController,
              decoration: InputDecoration(
                labelText: 'Check Out Date',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue,)
                ),
              ),
              readOnly: true,
              onTap: () => _showDatePicker(false),
            ),
            SizedBox(height: 20,),
            _buttonSubmit(),
          ],
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
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightGreenAccent[700])),
      ),
    );
  }

    BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.redAccent[700],
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          label: 'Home',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
          label: 'Profile',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            break;
        }
      },
    );
  }
}