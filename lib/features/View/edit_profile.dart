import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/Controller/ResidentController.dart';
import 'package:residential_management_system/features/View/profile_page.dart';
import 'package:residential_management_system/features/model/Resident.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final _formKey = GlobalKey<FormState>();

  //declare the current user
  final user = FirebaseAuth.instance.currentUser!;

  //declare firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //declare data that will be used for fetching data from auth email
  Map<String, dynamic>? userData;
  Resident resident = Resident.defaultConstructor();
  final String Email = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  //Declare the update data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _residentController = TextEditingController();
  final TextEditingController _blockController= TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _housenumberController= TextEditingController();

  Future<void> fetchUserData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('Resident')
        .where('email', isEqualTo: Email)
        .limit(1)
        .get();
      if(snapshot.docs.isNotEmpty) {
        userData = snapshot.docs.first.data();
        resident = Resident.fromMap(userData!);

        //set the initial value for the controller
        _nameController.text = resident.name;
        _phoneController.text = resident.phoneno;
        _residentController.text = resident.name;
        _blockController.text = resident.block;
        _floorController.text = resident.floor;
        _housenumberController.text = resident.houseno.toString();

        print("Name" +
            resident.name +
            "Phone" +
            resident.phoneno +
            "House Number" +
            resident.houseno.toString() +
            "Floor" +
            resident.floor +
            "Block" +
            resident.block +
            "Resident Name" +
            resident.residentname +
            "is holding in constructor"
        );
        setState(() {});
      }
    }catch (e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Form(key: _formKey, child: FormUpdate()),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Profile',
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

  BottomNavigationBar BottomNavBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
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
      backgroundColor: Colors.redAccent[700],
    );
  }

  Column FormUpdate() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(40),
          child: CircleAvatar(
            radius: 60.0,
          ),
        ),
        Text(
          user.email! + '\n',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Name',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'name',
            hintText: 'enter your name',
          ),
        ),
        Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: resident.phoneno,
            hintText: 'phone number',
          ),
        ),
        Text(
          'House Number',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: _housenumberController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: resident.houseno.toString(),
            hintText: 'house number',
          ),
        ),
        Text(
          'Floor',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: _floorController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: resident.floor,
            hintText: 'floor',
          ),
        ),
        Text(
          'Block',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: _blockController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: resident.block,
            hintText: 'block',
          ),
        ),
        Text(
          'Resident Name',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: _residentController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: resident.residentname,
            hintText: 'resident name',
          ),
        ),

        //button for update and cancel
        Padding(
          padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UpdateButton(),
              DiscardButton(),
            ],
          ),
        ),
      ],
    );
  }

  Container DiscardButton() {
    return Container(
              width: 100.0,
              height: 55.0,
              child: FloatingActionButton.extended(
                onPressed: () {},
                label: const Text(
                  'cancel',
                  style: TextStyle(
                    fontSize: 15.0, color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.redAccent[700],
              ),
            );
  }

  Container UpdateButton() {
    return Container(
              width: 100.0,
              height: 55.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(
                  'update',
                  style: TextStyle(
                    fontSize: 15.0, color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //form is valid, perform the update
              
                    Resident residentObj = Resident(
                      name: _nameController.text,
                      email: user.email.toString(),
                      phoneno: _phoneController.text,
                      residentname: _residentController.text,
                      block: _blockController.text,
                      floor: _floorController.text,
                      houseno: int.parse(_housenumberController.text)
                    );
                    print(residentObj.getname +
                        ' Has been save to constructor');
              
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                            ResidentController.saveResidentToFirestore(residentObj)
                          ),
                        );
                      }
                      );
              
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                  }
                }, 
              ),
            );
  }

}