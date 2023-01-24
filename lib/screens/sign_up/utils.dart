import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:participate/screens/login/otp/utils.dart';

FocusNode signUpPhoneFocus = FocusNode();
FocusNode fullNameFocus = FocusNode();
FocusNode usernameFocus = FocusNode();

TextEditingController phoneSignUp = TextEditingController();
TextEditingController age = TextEditingController();
TextEditingController username = TextEditingController();
late SingleValueDropDownController city = SingleValueDropDownController();
TextEditingController fullName = TextEditingController();

String selectedCity = "";

String userName = "";

final DBref = FirebaseDatabase.instance.ref();

class Customer {
  final String uid;
  final String name;
  final String phone;
  final String city;
  final String age;
  final String username;
  final String photoURL;
  final String auth_uid;

  Customer(this.uid, this.name, this.phone, this.city, this.age, this.username,
      this.photoURL, this.auth_uid);
}

Future<List<Customer>> customerListMaker() async {
  List<Customer> customerList = [];
  final snapshot = await DBref.child('Users').get();

  try {
    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map;
      data.forEach((key, value) {
        customerList.add(Customer(
            key,
            value['name'],
            value['phone_number'],
            value['city'],
            value['age'],
            value['username'],
            value['photoURL'],
            value['auth_uid']));
      });
      return customerList;
    } else {
      return [];
    }
  } on TypeError catch (e) {
    print('customerlist: ${e.toString()}');
    return [];
  } catch (e) {
    print('customerlist: ${e.toString()}');
    return [];
  }
}

bool registerVisibility = true;
