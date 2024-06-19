import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:residential_management_system/features/View/adminHomePage.dart';
import 'package:residential_management_system/features/View/securityHomepage.dart';
import 'package:residential_management_system/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:residential_management_system/features/View/home_page.dart';
import 'package:residential_management_system/features/View/sign_up.dart';
import 'package:residential_management_system/features/presentation/widgets/form_container_widget.dart';
import 'package:residential_management_system/global/common/toast.dart';
import 'package:residential_management_system/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _signIn,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigningIn
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont have account"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigningIn = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    //User? user = await _auth.signInWithEmailAndPassword(email, password);

    User? user;

    if (email == 'admin@gmail.com' && password == 'admin123') {
      //navigate to admin home page
      user = await _auth.signInWithEmailAndPassword(email, password);
      setState(() {
        _isSigningIn = false;
      });
      if (user != null) {
        showToast(message: 'Admin is successfully signed in');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminHomePage()));
      } else {
        showToast(message: 'admin is not signed in');
      }
    } else if (email == 'security@gmail.com' && password == 'security123'){
      //navigate to security home page
      user = await _auth.signInWithEmailAndPassword(email, password);
      setState(() {
        _isSigningIn = false;
      });
      if (user != null) {
        showToast(message: 'Security is successfully signed in');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SecurityHomePage()));
      } else {
        showToast(message: 'Security is not signed in');
      }
    } else {
      //navigate to resident home page
      user = await _auth.signInWithEmailAndPassword(email, password);
      setState(() {
        _isSigningIn = false;
      });

      if (user != null) {
        showToast(message: 'User is successfully signed in');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        showToast(message: "User is not successfully signed in");
      }
    }

    /*setState(() {
      _isSigningIn = false;
    });

    if (user != null){
      showToast(message: "User is successfully singed in");
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }else {
      showToast(message: "User is not successfully signed in");
    }*/
  }
}
