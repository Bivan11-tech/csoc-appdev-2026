import 'package:flutter/material.dart';
import 'package:food_delivery_ui/loginpage.dart';
import 'package:food_delivery_ui/mainscreen.dart';
import 'package:food_delivery_ui/services/auth_service.dart';
import 'package:food_delivery_ui/widgets/ui_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Register UI',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final AuthService authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 64),
              Text("REGISTER",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              Text("Add your details to register",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 25),
              RoundTextField(
                hintText: "Your Name",
                controller: txtName,
              ),
              SizedBox(height: 25),
              RoundTextField(
                hintText: "Your Email",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 25),
              RoundTextField(
                hintText: "Password",
                controller: txtPassword,
                obscureText: true,
              ),
              SizedBox(height: 25),
              RoundButton(
                title: "Register",
                  onPressed: () async {
                    try {
                      final result = await authService.register(
                        name: txtName.text.trim(),
                        email: txtEmail.text.trim(),
                        password: txtPassword.text.trim(),
                      );
                      if(result["message"] == "registered"){
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Registration Successful"),),
                          );

                          Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        }
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result["error"] ?? "Registration Failed",),),
                        );
                      }
                    } catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString()),),
                      );
                    }
                  }
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  // Handle navigation to Login here
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Already have an Account? ",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text("Login",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}