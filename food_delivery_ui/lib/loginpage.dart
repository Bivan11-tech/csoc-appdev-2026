import 'package:flutter/material.dart';
import 'package:food_delivery_ui/mainscreen.dart';
import 'package:food_delivery_ui/registerpage.dart';
import 'package:food_delivery_ui/widgets/ui_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_delivery_ui/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login UI',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              Text("LOGIN",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              Text("Add your details to login",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
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
                title: "LOGIN",
                onPressed: () async {
                  try {
                    final result = await authService.login(
                      email: txtEmail.text.trim(),
                      password: txtPassword.text.trim(),
                    );
                    if(result["token"] != null){
                      await authService.saveUserSession(
                        result["token"],
                        result["user"],
                      );
                      if(context.mounted){Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                        );
                      }
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result["error"] ?? "Login failed",)),
                      );
                    }

                  }
                  catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Don't have an Account? ",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text("Sign Up",
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