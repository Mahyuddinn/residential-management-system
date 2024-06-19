import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:residential_management_system/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:residential_management_system/features/View/login_page.dart';
import 'package:residential_management_system/features/presentation/widgets/form_container_widget.dart';
import 'package:residential_management_system/global/common/toast.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool _isSigningUp = false;
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign Up", style: TextStyle(
                fontSize: 27, 
                fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 30,),

              FormContainerWidget(
                controller: _usernameController,
                hintText: "Name",
                isPasswordField: false,
              ),

              SizedBox(height: 30,),

              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),

              SizedBox(height: 10,),

              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),

              SizedBox(height: 30,),

              GestureDetector(
                onTap: _signUp,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigningUp ? CircularProgressIndicator(color: Colors.white,) : Text(
                      "Sign Up", 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                        ),
                      ),
                ),
              ),

              SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have account"),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                    },
                    child: Text("Log In", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {

    setState(() {
      _isSigningUp = true; 
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      _isSigningUp = false;
    });

    if (user != null){
      showToast(message: "User is successfully created");
      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }else {
      showToast(message: "User is not successfully created");
    }
  }
}