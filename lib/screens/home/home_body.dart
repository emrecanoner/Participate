import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:participate/screens/event/utils.dart';
import 'package:participate/screens/home/home_page.dart';
import 'package:participate/screens/home/sign_out/sign_out_page.dart';
import 'package:participate/screens/home/utils.dart';
import 'package:participate/screens/profile/profile_page.dart';
import 'package:participate/screens/sign_up/utils.dart';
import 'package:participate/screens/welcome/welcome_screen.dart';
import 'package:participate/utils/constant.dart';
import 'package:participate/utils/images.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void initState() {
    cityController = SingleValueDropDownController();
    super.initState();
    if (FirebaseAuth.instance.currentUser!.displayName == null ||
        FirebaseAuth.instance.currentUser!.displayName == null) {
      updater();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: gWidth / 40),
                    child: FutureBuilder(
                        future: customerAccountDetails(FirebaseAuth
                            .instance.currentUser!.phoneNumber
                            ?.substring(3)),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return buildTaskBar(context, snapshot);
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ),
                  SizedBox(height: gHeight / 100),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: gWidth / 40),
                    child: buildCityDropdown(),
                  ),
                  SizedBox(height: gHeight / 25),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder(
                          future: getEventsbyCity(cityEvent),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return buildEventList(context, snapshot);
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildDateBar() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        onDateChange: (selectedDate) {
          selectedDateAtBar = selectedDate;
        },
        controller: dateControl,
        height: gHeight / 9,
        width: gWidth / 8,
        initialSelectedDate: DateTime.now(),
        selectionColor: mainColor,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  DropDownTextField buildCityDropdown() {
    return DropDownTextField(
      initialValue: selectedCity,
      clearOption: true,
      enableSearch: true,
      dropDownIconProperty: IconProperty(color: mainColor),
      clearIconProperty: IconProperty(color: mainColor),
      searchShowCursor: true,
      searchDecoration: InputDecoration(
        prefixIcon: Icon(
          Icons.location_city_outlined,
          color: mainColor,
        ),
        labelText: 'City',
        labelStyle: TextStyle(color: mainColor),
        hintText: 'Search city',
        hintStyle: TextStyle(color: mainColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor),
            borderRadius: BorderRadius.circular(2)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor),
            borderRadius: BorderRadius.circular(2)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
      ),
      textFieldDecoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor),
            borderRadius: BorderRadius.circular(2)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor),
            borderRadius: BorderRadius.circular(2)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
        prefixIcon: Icon(
          Icons.location_city,
          color: mainColor,
        ),
        labelText: 'City',
        labelStyle: TextStyle(color: mainColor),
        hintText: 'Search city for events',
        hintStyle: TextStyle(color: mainColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (value == null) {
          return "Required field";
        } else {
          cityEvent = value.toString();
          return null;
        }
      },
      dropDownItemCount: 6,
      dropDownList: const [
        DropDownValueModel(name: 'Adana', value: "Adana"),
        DropDownValueModel(name: 'Ad??yaman', value: "Ad??yaman"),
        DropDownValueModel(name: 'Afyonkarahisar', value: "Afyonkarahisar"),
        DropDownValueModel(name: 'A??r??', value: "A??r??"),
        DropDownValueModel(name: 'Aksaray', value: "Aksaray"),
        DropDownValueModel(name: 'Amasya', value: "Amasya"),
        DropDownValueModel(name: 'Ankara', value: "Ankara"),
        DropDownValueModel(name: 'Antalya', value: "Antalya"),
        DropDownValueModel(name: 'Ardahan', value: "Ardahan"),
        DropDownValueModel(name: 'Artvin', value: "Artvin"),
        DropDownValueModel(name: 'Ayd??n', value: "Ayd??n"),
        DropDownValueModel(name: 'Bal??kesir', value: "Bal??kesir"),
        DropDownValueModel(name: 'Bart??n', value: "Bart??n"),
        DropDownValueModel(name: 'Batman', value: "Batman"),
        DropDownValueModel(name: 'Bayburt', value: "Bayburt"),
        DropDownValueModel(name: 'Bilecik', value: "Bilecik"),
        DropDownValueModel(name: 'Bing??l', value: "Bing??l"),
        DropDownValueModel(name: 'Bitlis', value: "Bitlis"),
        DropDownValueModel(name: 'Bolu', value: "Bolu"),
        DropDownValueModel(name: 'Burdur', value: "Burdur"),
        DropDownValueModel(name: 'Bursa', value: "Bursa"),
        DropDownValueModel(name: '??anakkale', value: "??anakkale"),
        DropDownValueModel(name: '??ank??r??', value: "??ank??r??"),
        DropDownValueModel(name: '??orum', value: "??orum"),
        DropDownValueModel(name: 'Denizli', value: "Denizli"),
        DropDownValueModel(name: 'Diyarbak??r', value: "Diyarbak??r"),
        DropDownValueModel(name: 'D??zce', value: "D??zce"),
        DropDownValueModel(name: 'Edirne', value: "Edirne"),
        DropDownValueModel(name: 'Elaz????', value: "Elaz????"),
        DropDownValueModel(name: 'Erzincan', value: "Erzincan"),
        DropDownValueModel(name: 'Erzurum', value: "Erzurum"),
        DropDownValueModel(name: 'Eski??ehir', value: "Eski??ehir"),
        DropDownValueModel(name: 'Gaziantep', value: "Gaziantep"),
        DropDownValueModel(name: 'Giresun', value: "Giresun"),
        DropDownValueModel(name: 'G??m????hane', value: "G??m????hane"),
        DropDownValueModel(name: 'Hakk??ri', value: "Hakk??ri"),
        DropDownValueModel(name: 'Hatay', value: "Hatay"),
        DropDownValueModel(name: 'I??d??r', value: "I??d??r"),
        DropDownValueModel(name: 'Isparta', value: "Isparta"),
        DropDownValueModel(name: '??stanbul', value: "??stanbul"),
        DropDownValueModel(name: '??zmir', value: "??zmir"),
        DropDownValueModel(name: 'Kahramanmara??', value: "Kahramanmara??"),
        DropDownValueModel(name: 'Karab??k', value: "Karab??k"),
        DropDownValueModel(name: 'Karaman', value: "Karaman"),
        DropDownValueModel(name: 'Kars', value: "Kars"),
        DropDownValueModel(name: 'Kastamonu', value: "Kastamonu"),
        DropDownValueModel(name: 'Kayseri', value: "Kayseri"),
        DropDownValueModel(name: 'Kilis', value: "Kilis"),
        DropDownValueModel(name: 'K??r??kkale', value: "K??r??kkale"),
        DropDownValueModel(name: 'K??rklareli', value: "K??rklareli"),
        DropDownValueModel(name: 'K??r??ehir', value: "K??r??ehir"),
        DropDownValueModel(name: 'Kocaeli', value: "Kocaeli"),
        DropDownValueModel(name: 'Konya', value: "Konya"),
        DropDownValueModel(name: 'K??tahya', value: "K??tahya"),
        DropDownValueModel(name: 'Malatya', value: "Malatya"),
        DropDownValueModel(name: 'Manisa', value: "Manisa"),
        DropDownValueModel(name: 'Mardin', value: "Mardin"),
        DropDownValueModel(name: 'Mersin', value: "Mersin"),
        DropDownValueModel(name: 'Mu??la', value: "Mu??la"),
        DropDownValueModel(name: 'Mu??', value: "Mu??"),
        DropDownValueModel(name: 'Nev??ehir', value: "Nev??ehir"),
        DropDownValueModel(name: 'Ni??de', value: "Ni??de"),
        DropDownValueModel(name: 'Ordu', value: "Ordu"),
        DropDownValueModel(name: 'Osmaniye', value: "Osmaniye"),
        DropDownValueModel(name: 'Rize', value: "Rize"),
        DropDownValueModel(name: 'Sakarya', value: "Sakarya"),
        DropDownValueModel(name: 'Samsun', value: "Samsun"),
        DropDownValueModel(name: '??anl??urfa', value: "??anl??urfa"),
        DropDownValueModel(name: 'Siirt', value: "Siirt"),
        DropDownValueModel(name: 'Sinop', value: "Sinop"),
        DropDownValueModel(name: 'Sivas', value: "Sivas"),
        DropDownValueModel(name: '????rnak', value: "????rnak"),
        DropDownValueModel(name: 'Tekirda??', value: "Tekirda??"),
        DropDownValueModel(name: 'Tokat', value: "Tokat"),
        DropDownValueModel(name: 'Trabzon', value: "Trabzon"),
        DropDownValueModel(name: 'Tunceli', value: "Tunceli"),
        DropDownValueModel(name: 'U??ak', value: "U??ak"),
        DropDownValueModel(name: 'Van', value: "Van"),
        DropDownValueModel(name: 'Yalova', value: "Yalova"),
        DropDownValueModel(name: 'Yozgat', value: "Yozgat"),
        DropDownValueModel(name: 'Zonguldak', value: "Zonguldak"),
      ],
      onChanged: (val) {
        setState(() {
          if (val == "") {
            cityEvent = "";
          } else {
            cityEvent = val.value;
          }
        });
      },
    );
  }

  Widget buildTaskBar(context, snapshot) {
    Map CurrUser = snapshot.data as Map;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gWidth / 40),
      child: Column(children: <Widget>[
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${CurrUser['name']}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: gHeight / 150),
                Text(
                  "Let's explore what's happening nearby",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                )
              ],
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: mainColor),
                borderRadius: BorderRadius.circular(50),
              ),
              child: GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    CurrUser['photoURL']!,
                    height: gHeight / 18,
                    width: gWidth / 9,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: gHeight / 150),
        buildDateBar(),
        SizedBox(height: gHeight / 50),
      ]),
    );
  }
}
