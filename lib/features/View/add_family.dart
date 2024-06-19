import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/Controller/ResidentController.dart';
import 'package:residential_management_system/features/model/Resident.dart';

class AddFamilyMember extends StatefulWidget {
  const AddFamilyMember({super.key});

  @override
  State<AddFamilyMember> createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  Resident resident = Resident.defaultConstructor();
  final String Email = FirebaseAuth.instance.currentUser!.email.toString();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _residentController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _housenumberController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Resident')
          .where('email', isEqualTo: Email)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        userData = snapshot.docs.first.data();
        resident = Resident.fromMap(userData!);
        _blockController.text = resident.block;
        _floorController.text = resident.floor;
        _residentController.text = resident.residentname;
        _housenumberController.text = resident.houseno.toString();
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> initializeData() async {
    _blockController.text = resident.block;
    _floorController.text = resident.floor;
    _residentController.text = resident.residentname;
    _housenumberController.text = resident.houseno.toString();
  }

  Future signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarAddMember(context),
      body: _bodyAddMember(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  AppBar _appBarAddMember(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Add Family Member',
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

  SingleChildScrollView _bodyAddMember(BuildContext context){
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Add Family Member',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.grey[800],
                      size: 35.0,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    labelText: 'Member/Tenant Name',
                    labelStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter a Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Colors.grey[800],
                      size: 35.0,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                    labelText: 'Member/Tenant Email',
                    labelStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.home,
                      color: Colors.grey[800],
                      size: 35.0,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                    hintText: resident.residentname,
                    hintStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  enabled: false,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.location_city,
                      color: Colors.grey[800],
                      size: 35.0,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                    hintText: resident.block,
                    hintStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  enabled: false,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.stairs,
                      color: Colors.grey[800],
                      size: 35.0,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                    hintText: resident.floor,
                    hintStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  enabled: false,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.home,
                      color: Colors.grey[800],
                      size: 35.0,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                    labelText: resident.houseno.toString(),
                    labelStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  enabled: false,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.call,
                      color: Colors.grey[800],
                      size: 35.0,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  controller: _phoneController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Phone Number';
                    }
                    return null;
                  },
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
      child: FloatingActionButton.extended(
        onPressed: (){
          if (_formKey.currentState!.validate()) {
            // Form is valid, perform registration logic here
            initializeData();
            String houseNumberText = _housenumberController.text.trim();
            int houseNumber =
                houseNumberText.isNotEmpty ? int.parse(houseNumberText) : 0;

            _housenumberController.text = resident.houseno.toString();

            Resident residentObj = Resident(
              name: _nameController.text,
              email: _emailController.text,
              phoneno: _phoneController.text,
              residentname: _residentController.text.trim(),
              block: _blockController.text.trim(),
              floor: _floorController.text.trim(),
              houseno: houseNumber,
            );

            showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  content: Text(ResidentController.saveResidentToFirestore(residentObj)),
                );
              }
            );

            // Clear the form fields after registration
            _nameController.clear();
            _emailController.clear();
            _phoneController.clear();
            _passwordController.clear();
            _residentController.clear();
            _blockController.clear();
            _floorController.clear();
            _housenumberController.clear();
          }
        }, 
        label: Text(
          'Submit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightGreenAccent[700],
      ),
    );
  }

  Padding _buttonCancel() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          'Cancel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[800],
      ),
    );
  }
}