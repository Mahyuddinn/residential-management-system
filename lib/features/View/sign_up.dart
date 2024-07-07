import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/Controller/ResidentController.dart';
import 'package:residential_management_system/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:residential_management_system/features/View/login_page.dart';
import 'package:residential_management_system/features/model/Resident.dart';
import 'package:residential_management_system/global/common/toast.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _residentController = TextEditingController();

  final TextEditingController _blockController = TextEditingController();

  final TextEditingController _floorController = TextEditingController();

  final TextEditingController _housenumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signUp(residentObj) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save resident to Firestore
      await ResidentController.saveResidentToFirestore(residentObj);

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Text('Your account has been created successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'The email address is already in use by another account.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = 'An unknown error occurred.';
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Error'),
            content: Text('An error occurred. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RESIPRO',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.redAccent[700],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AccountHeadline(),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ResidentHeadline(),
                    TextFormField(
                      controller: _residentController,
                      decoration: InputDecoration(labelText: 'Resident Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter resident name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _blockController,
                      decoration: InputDecoration(labelText: 'Block'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your block';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _floorController,
                      decoration: InputDecoration(labelText: 'Floor'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your floor';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _housenumberController,
                      decoration: InputDecoration(labelText: 'House Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter house number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    RegisterButton(context),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  ElevatedButton RegisterButton(BuildContext context) {
    return ElevatedButton(
      child: Text('Register'),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Form is valid, perform registration logic here

          Resident residentObj = Resident(
              name: _nameController.text,
              email: _emailController.text,
              phoneno: _phoneController.text,
              residentname: _residentController.text,
              block: _blockController.text,
              floor: _floorController.text,
              houseno: int.parse(_housenumberController.text));

          signUp(residentObj);

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
    );
  }
}

class AccountHeadline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'ACCOUNT DETAIL',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontFamily: 'Calibri',
      ),
    );
  }
}

class ResidentHeadline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'RESIDENT DETAIL',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontFamily: 'Calibri',
      ),
    );
  }
}
