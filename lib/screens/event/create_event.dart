import 'dart:ui';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:participate/screens/event/input_field.dart';
import 'package:participate/screens/event/splash/splash_screen_event.dart';
import 'package:participate/screens/event/utils.dart';
import 'package:participate/screens/home/home_page.dart';
import 'package:participate/screens/home/utils.dart';
import 'package:participate/screens/splash/splash_screen.dart';
import 'package:participate/utils/constant.dart';

enum SampleItem {
  Coffee,
  Basketball,
  Football,
  Dance_party,
  Ice_skate,
  Normal_party,
  Surfing,
  Swimming,
  Tennis,
  Touring,
  Other
}

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String endTime = "21:30";
  String startTime = DateFormat("HH:mm").format(DateTime.now()).toString();
  String? location;
  int lan = 10;
  int long = 10;
  String? _currentAddress;
  Position? _currentPosition;
  String selectedevent = '';

  SampleItem? selectedMenu;

  DateTime? pickerDate;

  final titleController = TextEditingController();
  late SingleValueDropDownController eventTypeController;

  late DatabaseReference eventdref;

  void initState() {
    eventdref = FirebaseDatabase.instance.ref().child('Events');
    selectedevent = "";
    eventTypeController = SingleValueDropDownController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentPosition();
    });
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Events');
  }

  void dispose() {
    eventTypeController.dispose();
    selectedevent;
    super.dispose();
  }

  getDateFromUser(BuildContext context) async {
    pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickerDate != null) {
      setState(() {
        selectedDateAtBar = pickerDate!;
      });
    }
  }

  getTimeFromUser({required bool isStarted}) async {
    if (selectedDateAtBar != null) {
      var pickedTime = await buildShowTimePicker();
      if (pickedTime == null) {
        DateTime selectedTime = DateTime(
          selectedDateAtBar.year,
          selectedDateAtBar.month,
          selectedDateAtBar.day,
          DateTime.now().hour,
          DateTime.now().minute,
        );
        if (selectedTime.isBefore(DateTime.now())) {
          messenger(context, "You can't select a time before now");
        } else {
          String formattedTime =
              DateFormat('HH:mm').format(DateTime.now()).toString();
          if (isStarted == true) {
            setState(() {
              startTime = formattedTime;
            });
          } else if (isStarted == false) {
            setState(() {
              endTime = formattedTime;
            });
          }
        }
      } else {
        DateTime selectedTime = DateTime(
          selectedDateAtBar.year,
          selectedDateAtBar.month,
          selectedDateAtBar.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        if (selectedTime.isBefore(DateTime.now())) {
          messenger(context, "You can't select a time before now");
        } else {
          String formattedTime = pickedTime?.format(context);
          if (isStarted == true) {
            setState(() {
              startTime = formattedTime;
            });
          } else if (isStarted == false) {
            setState(() {
              endTime = formattedTime;
            });
          }
        }
      }
    } else {
      messenger(context, "You have to pick date first");
    }
  }

  buildShowTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(startTime.split(":")[0]),
        minute: int.parse(startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void showModel(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: gHeight / 2,
            child: Center(
              child: OpenStreetMapSearchAndPick(
                center: LatLong(_currentPosition?.latitude ?? 10,
                    _currentPosition?.longitude ?? 10),
                buttonColor: mainColor,
                buttonText: "Set Current Location",
                onPicked: (pickedData) {
                  Navigator.pop(context);
                  setState(() {
                    location = pickedData.address;
                  });
                },
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: gWidth / 50, right: gWidth / 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Event",
              style: GoogleFonts.lato(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            InputField(
              title: "Title",
              hint: "Enter your title",
              Controller: titleController,
            ),
            InputField(
              title: "Date",
              hint: DateFormat.yMd().format(selectedDateAtBar),
              widget: IconButton(
                onPressed: () {
                  getDateFromUser(context);
                },
                icon: Icon(Icons.calendar_today_outlined),
                color: mainColor,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    title: "Start Time",
                    hint: startTime,
                    widget: IconButton(
                      onPressed: () {
                        getTimeFromUser(isStarted: true);
                      },
                      icon: Icon(Icons.access_time_rounded),
                      color: mainColor,
                    ),
                  ),
                ),
                Expanded(
                  child: InputField(
                    title: "End Time",
                    hint: endTime,
                    widget: IconButton(
                      onPressed: () {
                        getTimeFromUser(isStarted: false);
                      },
                      icon: Icon(Icons.access_time_rounded),
                      color: mainColor,
                    ),
                  ),
                ),
              ],
            ),
            InputField(
              title: "Event Type",
              hint: selectedevent.split(".").last,
              widget: popUp(),
            ),
            InputField(
              title: "Location",
              hint: location ?? "Enter your location",
              widget: IconButton(
                onPressed: () {
                  _getCurrentPosition().then((value) => showModel(context));
                },
                icon: Icon(Icons.location_city_outlined),
                color: mainColor,
              ),
            ),
            SizedBox(height: gHeight / 25),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(mainColor)),
                child: Text("CREATE"),
                onPressed: () async {
                  bool nameExists = false;
                  List<LNAevent> eventK = await getallEvents();
                  for (var element in eventK) {
                    if (element.event_title == titleController.text) {
                      nameExists = true;
                      break;
                    } else {
                      continue;
                    }
                  }
                  if (titleController.text.length == 0) {
                    messenger(context, 'Type event title');
                  } else if (nameExists) {
                    messenger(
                        context, 'Type a unique event title. This one exists');
                  } else if (selectedevent == "") {
                    messenger(context, 'Select event type');
                  } else if (location == null) {
                    messenger(context, 'Select event location');
                  } else {
                    String date =
                        DateFormat('dd-MM-yyyy').format(selectedDateAtBar);
                    Map Curruser = await customerAccountDetails(FirebaseAuth
                        .instance.currentUser!.phoneNumber
                        ?.substring(3));
                    String event_photo = '';
                    if (selectedevent.split('.').last == 'Basketball') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Fbasketball.png?alt=media&token=8b318678-5516-4933-aba1-1b1f7a419917';
                    } else if (selectedevent.split('.').last == 'Coffee') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Fcoffee.png?alt=media&token=c986c8e7-fca5-4141-9c26-42f8d3b6af5a';
                    } else if (selectedevent.split('.').last == 'Dance_party') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Fdance%20party.png?alt=media&token=307c443c-9701-4cf7-aedc-26053be25519';
                    } else if (selectedevent.split('.').last == 'Football') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Ffootball.png?alt=media&token=9a9f91bd-eab4-4cc4-9829-136d3ebc4ba0';
                    } else if (selectedevent.split('.').last == 'Ice_skate') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Fice-skate.png?alt=media&token=d3a748c5-0901-4159-8e77-350c0745d8ca';
                    } else if (selectedevent.split('.').last ==
                        'Normal_party') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Fnormal%20party.png?alt=media&token=4572418d-ae85-4cd0-90dd-f7d59e14231b';
                    } else if (selectedevent.split('.').last == 'Surfing') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Fsurfing.png?alt=media&token=4c4ffaa1-d52c-464c-afe3-747a0aa0d2b6';
                    } else if (selectedevent.split('.').last == 'Swimming') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Fswimming.png?alt=media&token=e75e368d-fa1d-45af-bf10-99dca6419752';
                    } else if (selectedevent.split('.').last == 'Tennis') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Ftennis.png?alt=media&token=86e96e41-e6e8-429e-9ef0-b88f65a8be10';
                    } else if (selectedevent.split('.').last == 'Touring') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Ftouring.png?alt=media&token=6bcd4c86-5d80-4f25-b620-7bd6a30adba9';
                    } else if (selectedevent.split('.').last == 'Other') {
                      event_photo =
                          'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/event%20icons%2Fevent.png?alt=media&token=d9e4cfc6-1a95-495f-8e43-8a67abf9040c';
                    }
                    Map event = {
                      'event_title': titleController.text,
                      'event_creator': FirebaseAuth.instance.currentUser!.uid,
                      'event_photo': event_photo,
                      'event_city': Curruser['city'],
                      'event_type': selectedevent,
                      'event_date': date,
                      'start_time': startTime,
                      'end_time': endTime,
                      'event_location': location
                    };
                    dbRef.push().set(event);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SplashScreenEvent(),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: gHeight / 25),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<SampleItem> popUp() {
    return PopupMenuButton(
      initialValue: selectedMenu,
      position: PopupMenuPosition.under,
      onSelected: (SampleItem item) {
        setState(() {
          selectedevent = item.toString();
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Coffee,
          child: Text('Coffee'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Dance_party,
          child: Text('Dance Party'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Ice_skate,
          child: Text('Ice Skate'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Basketball,
          child: Text('Basketball'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Football,
          child: Text('Football'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Normal_party,
          child: Text('Normal Party'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Swimming,
          child: Text('Swimming'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Surfing,
          child: Text('Surfing'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Tennis,
          child: Text('Tennis'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Touring,
          child: Text('Touring'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.Other,
          child: Text('Other'),
        ),
      ],
    );
  }

  DropDownTextField buildEventTypeDropdown() {
    return DropDownTextField(
      controller: eventTypeController,
      clearOption: true,
      enableSearch: true,
      dropDownIconProperty: IconProperty(color: mainColor),
      clearIconProperty: IconProperty(color: mainColor),
      searchShowCursor: true,
      searchDecoration: InputDecoration(
        labelText: "Choose the event type",
        labelStyle: TextStyle(color: iconColor, fontSize: 13),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      textFieldDecoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
        ),
        labelText: "Event Type",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Select your event",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (value == null) {
          return "Required field";
        } else {
          selectedevent = value.toString();
          return null;
        }
      },
      dropDownItemCount: 6,
      dropDownList: const [
        DropDownValueModel(name: 'Basketball', value: "Basketball"),
        DropDownValueModel(name: 'Coffee', value: "Coffee"),
        DropDownValueModel(name: 'Dance party', value: "Dance party"),
        DropDownValueModel(name: 'Football', value: "Football"),
        DropDownValueModel(name: 'Ice Skate', value: "Ice Skate"),
        DropDownValueModel(name: 'Normal party', value: "Normal party"),
        DropDownValueModel(name: 'Surfing', value: "Surfing"),
        DropDownValueModel(name: 'Swimming', value: "Swimming"),
        DropDownValueModel(name: 'Tennis', value: "Tennis"),
        DropDownValueModel(name: 'Touring', value: "Touring"),
        DropDownValueModel(name: 'Other', value: "Other"),
      ],
      onChanged: (val) {
        if (val == "") {
          selectedevent = "";
        } else {
          selectedevent = val.value;
        }
      },
    );
  }
}
