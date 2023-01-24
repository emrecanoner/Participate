import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:participate/screens/home/sign_out/sign_out_page.dart';
import 'package:participate/screens/home/utils.dart';
import 'package:participate/utils/constant.dart';

class BodyProfilePage extends StatefulWidget {
  const BodyProfilePage({super.key});

  State<BodyProfilePage> createState() => _BodyProfilePageState();
}

class _BodyProfilePageState extends State<BodyProfilePage> {
  String? authcurrent =
      FirebaseAuth.instance.currentUser?.phoneNumber?.substring(3);
  String photo1 = FirebaseAuth.instance.currentUser!.photoURL.toString();
  String photo2 =
      'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/utils%2Fpersonphone.png?alt=media&token=40d6fee7-7734-4a99-bcb0-2fe82df928cb';

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: customerAccountDetails(authcurrent!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return displayUserInformation(context, snapshot);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    Map signedInCustomer = snapshot.data as Map;
    final year = signedInCustomer['age'].toString().split('-')[0];
    int calcAge = int.parse(year);

    return Padding(
      padding: EdgeInsets.all(gHeight / 40),
      child: Expanded(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        (photo2),
                        height: gHeight / 6,
                        width: gWidth / 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: gHeight / 20),
            TextField(
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                  labelText: "Full Name",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:
                      Icon(Icons.person_outline_rounded, color: iconColor),
                  hintText: "${signedInCustomer['name']}",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none),
            ),
            SizedBox(height: gHeight * 0.0010),
            TextField(
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                  labelText: "Username",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.verified_user, color: iconColor),
                  hintText: "${signedInCustomer['username']}",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none),
            ),
            SizedBox(height: gHeight * 0.0010),
            TextField(
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                  labelText: "Age",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.calendar_today, color: iconColor),
                  hintText: "${2023 - calcAge}",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none),
            ),
            SizedBox(height: gHeight * 0.0010),
            TextField(
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                  labelText: "City",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:
                      Icon(Icons.location_city_outlined, color: iconColor),
                  hintText: "${signedInCustomer['city']}",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none),
            ),
            SizedBox(height: gHeight * 0.0010),
            TextField(
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                  labelText: "Phone Number",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.phone, color: iconColor),
                  hintText: "${signedInCustomer['phone_number']}",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none),
            ),
            SizedBox(height: gHeight * 0.009),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(iconColor)),
                onPressed: () {
                  AnimatedSignOut(context);
                  AuthService().signOut();
                },
                child: Text(
                  'SIGN OUT',
                  style: GoogleFonts.poppins(color: Colors.white),
                )),
          ],
        )),
      ),
    );
  }
}
