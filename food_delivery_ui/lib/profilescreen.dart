import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_ui/loginpage.dart';
import 'package:food_delivery_ui/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile UI',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PROFILE", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImage.isNotEmpty && File(profileImage).existsSync()
                      ? FileImage(File(profileImage))
                      : AssetImage('assets/images/boy.jpg') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: pickProfileImage,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.camera_alt_rounded, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(name,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(email,
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  profileTab(icon: Icons.edit_outlined, title: "Edit Profile", onTap: editProfile),
                  profileTab(icon: Icons.favorite_border, title: "Favorites", onTap: () {},),
                  profileTab(icon: Icons.shopping_bag_outlined, title: "Past Orders", onTap: () {},),
                  profileTab(icon: Icons.phone_android_outlined, title: "Contact Us", onTap: () {},),
                  profileTab(icon: Icons.star_border_rounded, title: "Rate Us", onTap: () {},),
                  profileTab(icon: Icons.info_outline_rounded, title: "About Us", onTap: () {},),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 2,
                      ),
                        onPressed: () async {

                          await AuthService().logout();

                          if(context.mounted){
                            Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                                  (route) => false,
                            );
                          }
                        },
                      child: Text("LOGOUT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileTab({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        //color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange, size: 24),
        title: Text(title, style: TextStyle(fontSize: 15)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('userName') ?? "";
      email = prefs.getString('userEmail') ?? "";
      profileImage = prefs.getString('profileImage') ?? "";
    });
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profileImage", image.path);
    setState(() {
      profileImage = image.path;
    });
  }

  Future<void> editProfile() async {
    final controller = TextEditingController(text: name);

    await showDialog(context: context, builder: (_) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
              labelText: "Name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red),),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isEmpty) return;
                try {
                  await AuthService().updateProfile(newName);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString("userName", newName,);
                  if(!mounted) return;
                  setState(() {
                    name = newName;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile Updated"))
                  );
                }
                catch (e) {
                  if(!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Update failed"))
                  );
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}