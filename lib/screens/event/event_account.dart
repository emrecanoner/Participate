import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:participate/screens/event/splash/splash_screen_event.dart';
import 'package:participate/screens/event/utils.dart';
import 'package:participate/screens/home/home_page.dart';
import 'package:participate/screens/home/utils.dart';
import 'package:participate/utils/constant.dart';

class eventAccount extends StatefulWidget {
  const eventAccount({Key? key, required this.eventName}) : super(key: key);

  final String eventName;

  State<eventAccount> createState() => _eventAccountState();
}

class _eventAccountState extends State<eventAccount> {
  late String photo;
  bool eventJoined = true;

  late DatabaseReference eventdbref;
  late DatabaseReference chatDf;

  @override
  void initState() {
    super.initState();
    eventdbref = FirebaseDatabase.instance.ref().child('Events');
    getEvent();
  }

  void getEvent() async {
    List<Chat> events =
        await getUserChats(FirebaseAuth.instance.currentUser!.uid);
    for (var element in events) {
      if (element.chat_name == widget.eventName) {
        eventJoined = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            },
            icon: Icon(Icons.arrow_left)),
      ),
      body: FutureBuilder(
        future: getEventDetails(widget.eventName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return displayEventInformation(context, snapshot);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget displayEventInformation(context, snapshot) {
    Map EventSearched = snapshot.data as Map;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(children: [
        Center(
          child: Stack(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    (EventSearched['event_photo']),
                    height: gHeight / 6,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
        SizedBox(height: 50),
        TextField(
          readOnly: true,
          enabled: false,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3, left: 10),
              labelText: "Event Name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "${EventSearched['event_title']}",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(height: 15),
        TextField(
          enabled: false,
          readOnly: true,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3, left: 10),
              labelText: "Date",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "${EventSearched['event_date']}",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(height: 15),
        TextField(
          enabled: false,
          readOnly: true,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3, left: 10),
              labelText: "Start time",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "${EventSearched['event_starttime']}",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(height: 15),
        TextField(
          readOnly: true,
          enabled: false,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3, left: 10),
              labelText: "End Time",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "${EventSearched['event_endtime']}",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(height: 15),
        TextField(
          minLines: 1,
          maxLines: 20,
          enabled: false,
          readOnly: true,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3, left: 10),
              labelText: "Location",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "${EventSearched['event_location']}",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(height: 80),
      ]),
    );
  }
}
