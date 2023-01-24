import 'dart:collection';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:participate/screens/event/create_Event.dart';
import 'package:participate/screens/event/event_account.dart';
import 'package:participate/screens/home/home_body.dart';
import 'package:participate/screens/home/home_page.dart';
import 'package:participate/screens/profile/profile_page.dart';
import 'package:participate/screens/sign_up/sign_up_page.dart';
import 'package:participate/screens/sign_up/utils.dart';
import 'package:participate/screens/welcome/welcome_screen.dart';
import 'package:participate/utils/constant.dart';

Future<String> get_Curname(String? phN) async {
  List<Customer> it = await customerListMaker();
  String cur = "";

  try {
    for (var p in it) {
      if (p.phone == phN.toString()) {
        cur = p.name;
        break;
      } else {
        continue;
      }
    }
    return cur;
  } on TypeError catch (e) {
    print('getcurname: ${e.toString()}');
    return '';
  } catch (e) {
    print('getcurname: ${e.toString()}');
    return '';
  }
}

void updater() async {
  try {
    Map CurrUser = await customerAccountDetails(
        FirebaseAuth.instance.currentUser!.phoneNumber!.substring(3));
    String curname = CurrUser['name'];
    String curphoto = CurrUser['photoURL'];
    FirebaseAuth.instance.currentUser?.updateDisplayName(curname);
    FirebaseAuth.instance.currentUser?.updatePhotoURL(curphoto);
    DatabaseReference AuthRef = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child('${CurrUser['uid']}');
    AuthRef.update({'auth_uid': FirebaseAuth.instance.currentUser!.uid});
  } on TypeError catch (e) {
    print('updater: ${e.toString()}');
  } catch (e) {
    print('updater: ${e.toString()}');
  }
}

Future<Map<dynamic, dynamic>> customerAccountDetails(String? phoneNum) async {
  List<Customer> customers = await customerListMaker();
  Map<dynamic, dynamic> signedCustomer = new HashMap();

  try {
    for (var element in customers) {
      if (element.phone == phoneNum) {
        signedCustomer = {
          'name': element.name,
          'phone_number': element.phone,
          'city': element.city,
          'age': element.age,
          'username': element.username,
          'photoURL': element.photoURL,
          'uid': element.uid,
          'auth_uid': element.auth_uid,
        };
        break;
      } else {
        continue;
      }
    }
    return signedCustomer;
  } on TypeError catch (e) {
    print('customerlist: ${e.toString()}');
    return {};
  } catch (e) {
    print('customerlist: ${e.toString()}');
    return {};
  }
}

int pageIndex = 1;

List<Widget> pageList = [
  CreateEvent(),
  HomeBody(),
  ProfilePage(),
];

class LNAevent {
  final String event_title;
  final String event_creator;
  final String event_photo;
  final String event_city;
  final String event_type;
  final String event_date;
  final String event_starttime;
  final String event_endtime;
  final String event_location;

  LNAevent(
      this.event_title,
      this.event_creator,
      this.event_photo,
      this.event_city,
      this.event_type,
      this.event_date,
      this.event_starttime,
      this.event_endtime,
      this.event_location);
}

Future<List<LNAevent>> getEventsbyCity(String userCity) async {
  List<LNAevent> events = [];
  List<LNAevent> eventsInCity = [];
  final snapshot = await DBref.child('Events').get();

  try {
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      data.forEach((key, value) {
        events.add(LNAevent(
            value['event_title'],
            value['event_creator'],
            value['event_photo'],
            value['event_city'],
            value['event_type'],
            value['event_date'],
            value['start_time'],
            value['end_time'],
            value['event_location']));
      });
      for (var element in events) {
        if (element.event_city == userCity) {
          eventsInCity.add(LNAevent(
              element.event_title,
              element.event_creator,
              element.event_photo,
              element.event_city,
              element.event_type,
              element.event_date,
              element.event_starttime,
              element.event_endtime,
              element.event_location));
        }
      }
      return eventsInCity;
    } else {
      return [];
    }
  } on TypeError catch (e) {
    print('Events: ${e.toString()}');
    return [];
  } catch (e) {
    print('Events: ${e.toString()}');
    return [];
  }
}

Future<Map> getEventDetails(String Ename) async {
  List<LNAevent> eventsInfo = [];
  Map specificEvent = {};
  final snapshot = await DBref.child('Events').get();

  try {
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      data.forEach((key, value) {
        eventsInfo.add(LNAevent(
            value['event_title'],
            value['event_creator'],
            value['event_photo'],
            value['event_city'],
            value['event_type'],
            value['event_date'],
            value['start_time'],
            value['end_time'],
            value['event_location']));
      });
      for (var element in eventsInfo) {
        if (element.event_title == Ename) {
          specificEvent = {
            'event_title': element.event_title,
            'event_creator': element.event_creator,
            'event_photo': element.event_photo,
            'event_city': element.event_city,
            'event_type': element.event_type,
            'event_date': element.event_date,
            'event_starttime': element.event_starttime,
            'event_endtime': element.event_endtime,
            'event_location': element.event_location
          };
          break;
        } else {
          continue;
        }
      }
      return specificEvent;
    } else {
      return {};
    }
  } on TypeError catch (e) {
    print('Events: ${e.toString()}');
    return {};
  } catch (e) {
    print('Events: ${e.toString()}');
    return {};
  }
}

Future<List<LNAevent>> getallEvents() async {
  List<LNAevent> ev = [];
  final snapshot = await DBref.child('Events').get();

  try {
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      data.forEach((key, value) {
        ev.add(LNAevent(
            value['event_title'],
            value['event_creator'],
            value['event_photo'],
            value['event_city'],
            value['event_type'],
            value['event_date'],
            value['start_time'],
            value['end_time'],
            value['event_location']));
      });
      return ev;
    } else {
      return [];
    }
  } on TypeError catch (e) {
    print('Events: ${e.toString()}');
    return [];
  } catch (e) {
    print('Events: ${e.toString()}');
    return [];
  }
}

String cityEvent = '';
late SingleValueDropDownController cityController;

Widget buildEventList(context, snapshot) {
  List<LNAevent> eventmap = snapshot.data as List<LNAevent>;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: gWidth / 30),
    child: ListView.builder(
      padding: EdgeInsets.only(top: 0),
      itemCount: eventmap.length,
      itemBuilder: (BuildContext context, int index) {
        LNAevent event = eventmap[index];
        return Container(
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1.5,
              color: mainColor,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.only(top: 2, left: 5),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                event.event_photo,
                height: gHeight / 18,
                width: gWidth / 9,
              ),
            ),
            title: Text(event.event_title),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => eventAccount(eventName: event.event_title),
                  ));
            },
          ),
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    ),
  );
}
