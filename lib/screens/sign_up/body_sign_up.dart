import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masked_text/masked_text.dart';
import 'package:participate/screens/login/login_screen.dart';
import 'package:participate/screens/login/otp/utils.dart';
import 'package:participate/screens/sign_up/splash/splash_screen_sign_up.dart';
import 'package:participate/screens/sign_up/utils.dart';
import 'package:participate/utils/constant.dart';
import 'package:participate/utils/images.dart';
import 'package:participate/utils/texts.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  late DatabaseReference dbRef;
  @override
  void initState() {
    setState(() {
      age.text = "";
      city = SingleValueDropDownController();
    });
    if (mounted) {
      setState(() {
        city.clearDropDown();
        age.clear();
        username.clear();
        fullName.clear();
        phoneSignUp.clear();
      });
    }
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Users');
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(SignUpImage),
                  height: gHeight * 0.3,
                ),
                SizedBox(height: gHeight * 0.02),
                Text('PARTICIPATE',
                    style: GoogleFonts.poppins(
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: <Color>[
                              mainColor,
                              mainColor,
                              mainColor,
                              mainColor,
                              iconColor,
                            ],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                Text(
                  SignUpTitle,
                  style: styleOnBoardTitle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  SignUpSubTitle,
                  style: styleOnBoardSubTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: gHeight * 0.015),
                Form(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          onTap: _requestFullNameFocus,
                          focusNode: fullNameFocus,
                          maxLength: 20,
                          keyboardType: TextInputType.name,
                          controller: fullName,
                          showCursor: true,
                          decoration: InputDecoration(
                            counter: Offstage(),
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: fullNameFocus.hasFocus
                                  ? mainColor
                                  : iconColor,
                            ),
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                                color: fullNameFocus.hasFocus
                                    ? mainColor
                                    : iconColor),
                            hintText: 'Write your full name',
                            hintStyle: TextStyle(
                                color: fullNameFocus.hasFocus
                                    ? mainColor
                                    : iconColor),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: iconColor),
                                borderRadius: BorderRadius.circular(2)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: mainColor),
                                borderRadius: BorderRadius.circular(2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2)),
                          ),
                        ),
                        SizedBox(height: gHeight * 0.0050),
                        TextFormField(
                          onTap: _requestUsernameFocus,
                          focusNode: usernameFocus,
                          keyboardType: TextInputType.name,
                          controller: username,
                          showCursor: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.verified_user,
                              color: usernameFocus.hasFocus
                                  ? mainColor
                                  : iconColor,
                            ),
                            labelText: 'Username',
                            labelStyle: TextStyle(
                                color: usernameFocus.hasFocus
                                    ? mainColor
                                    : iconColor),
                            hintText: 'Write your username',
                            hintStyle: TextStyle(
                                color: usernameFocus.hasFocus
                                    ? mainColor
                                    : iconColor),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: iconColor),
                                borderRadius: BorderRadius.circular(2)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: mainColor),
                                borderRadius: BorderRadius.circular(2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2)),
                          ),
                        ),
                        SizedBox(height: gHeight * 0.015),
                        TextFormField(
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2024));

                            if (pickedDate != null) {
                              print(pickedDate);
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate);
                              setState(() {
                                age.text = formattedDate;
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                          keyboardType: TextInputType.datetime,
                          controller: age,
                          showCursor: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: iconColor,
                            ),
                            labelText: 'Age',
                            labelStyle: TextStyle(color: iconColor),
                            hintText: 'Select your age',
                            hintStyle: TextStyle(color: iconColor),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: iconColor),
                                borderRadius: BorderRadius.circular(2)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: iconColor),
                                borderRadius: BorderRadius.circular(2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2)),
                          ),
                        ),
                        SizedBox(height: gHeight * 0.015),
                        DropDownTextField(
                          controller: city,
                          clearOption: true,
                          enableSearch: true,
                          dropDownIconProperty: IconProperty(color: iconColor),
                          clearIconProperty: IconProperty(color: iconColor),
                          searchShowCursor: true,
                          searchDecoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.location_city_outlined,
                              color: iconColor,
                            ),
                            labelText: 'City',
                            labelStyle: TextStyle(color: iconColor),
                            hintText: 'Search city',
                            hintStyle: TextStyle(color: iconColor),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: iconColor),
                                borderRadius: BorderRadius.circular(2)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: iconColor),
                                borderRadius: BorderRadius.circular(2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2)),
                          ),
                          textFieldDecoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: iconColor),
                                borderRadius: BorderRadius.circular(2)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: iconColor),
                                borderRadius: BorderRadius.circular(2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2)),
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: iconColor,
                            ),
                            labelText: 'City',
                            labelStyle: TextStyle(color: iconColor),
                            hintText: 'Select your city',
                            hintStyle: TextStyle(color: iconColor),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Required field";
                            } else {
                              selectedCity = value.toString();
                              return null;
                            }
                          },
                          dropDownItemCount: 6,
                          dropDownList: const [
                            DropDownValueModel(name: 'Adana', value: "Adana"),
                            DropDownValueModel(
                                name: 'Adıyaman', value: "Adıyaman"),
                            DropDownValueModel(
                                name: 'Afyonkarahisar',
                                value: "Afyonkarahisar"),
                            DropDownValueModel(name: 'Ağrı', value: "Ağrı"),
                            DropDownValueModel(
                                name: 'Aksaray', value: "Aksaray"),
                            DropDownValueModel(name: 'Amasya', value: "Amasya"),
                            DropDownValueModel(name: 'Ankara', value: "Ankara"),
                            DropDownValueModel(
                                name: 'Antalya', value: "Antalya"),
                            DropDownValueModel(
                                name: 'Ardahan', value: "Ardahan"),
                            DropDownValueModel(name: 'Artvin', value: "Artvin"),
                            DropDownValueModel(name: 'Aydın', value: "Aydın"),
                            DropDownValueModel(
                                name: 'Balıkesir', value: "Balıkesir"),
                            DropDownValueModel(name: 'Bartın', value: "Bartın"),
                            DropDownValueModel(name: 'Batman', value: "Batman"),
                            DropDownValueModel(
                                name: 'Bayburt', value: "Bayburt"),
                            DropDownValueModel(
                                name: 'Bilecik', value: "Bilecik"),
                            DropDownValueModel(name: 'Bingöl', value: "Bingöl"),
                            DropDownValueModel(name: 'Bitlis', value: "Bitlis"),
                            DropDownValueModel(name: 'Bolu', value: "Bolu"),
                            DropDownValueModel(name: 'Burdur', value: "Burdur"),
                            DropDownValueModel(name: 'Bursa', value: "Bursa"),
                            DropDownValueModel(
                                name: 'Çanakkale', value: "Çanakkale"),
                            DropDownValueModel(
                                name: 'Çankırı', value: "Çankırı"),
                            DropDownValueModel(name: 'Çorum', value: "Çorum"),
                            DropDownValueModel(
                                name: 'Denizli', value: "Denizli"),
                            DropDownValueModel(
                                name: 'Diyarbakır', value: "Diyarbakır"),
                            DropDownValueModel(name: 'Düzce', value: "Düzce"),
                            DropDownValueModel(name: 'Edirne', value: "Edirne"),
                            DropDownValueModel(name: 'Elazığ', value: "Elazığ"),
                            DropDownValueModel(
                                name: 'Erzincan', value: "Erzincan"),
                            DropDownValueModel(
                                name: 'Erzurum', value: "Erzurum"),
                            DropDownValueModel(
                                name: 'Eskişehir', value: "Eskişehir"),
                            DropDownValueModel(
                                name: 'Gaziantep', value: "Gaziantep"),
                            DropDownValueModel(
                                name: 'Giresun', value: "Giresun"),
                            DropDownValueModel(
                                name: 'Gümüşhane', value: "Gümüşhane"),
                            DropDownValueModel(
                                name: 'Hakkâri', value: "Hakkâri"),
                            DropDownValueModel(name: 'Hatay', value: "Hatay"),
                            DropDownValueModel(name: 'Iğdır', value: "Iğdır"),
                            DropDownValueModel(
                                name: 'Isparta', value: "Isparta"),
                            DropDownValueModel(
                                name: 'İstanbul', value: "İstanbul"),
                            DropDownValueModel(name: 'İzmir', value: "İzmir"),
                            DropDownValueModel(
                                name: 'Kahramanmaraş', value: "Kahramanmaraş"),
                            DropDownValueModel(
                                name: 'Karabük', value: "Karabük"),
                            DropDownValueModel(
                                name: 'Karaman', value: "Karaman"),
                            DropDownValueModel(name: 'Kars', value: "Kars"),
                            DropDownValueModel(
                                name: 'Kastamonu', value: "Kastamonu"),
                            DropDownValueModel(
                                name: 'Kayseri', value: "Kayseri"),
                            DropDownValueModel(name: 'Kilis', value: "Kilis"),
                            DropDownValueModel(
                                name: 'Kırıkkale', value: "Kırıkkale"),
                            DropDownValueModel(
                                name: 'Kırklareli', value: "Kırklareli"),
                            DropDownValueModel(
                                name: 'Kırşehir', value: "Kırşehir"),
                            DropDownValueModel(
                                name: 'Kocaeli', value: "Kocaeli"),
                            DropDownValueModel(name: 'Konya', value: "Konya"),
                            DropDownValueModel(
                                name: 'Kütahya', value: "Kütahya"),
                            DropDownValueModel(
                                name: 'Malatya', value: "Malatya"),
                            DropDownValueModel(name: 'Manisa', value: "Manisa"),
                            DropDownValueModel(name: 'Mardin', value: "Mardin"),
                            DropDownValueModel(name: 'Mersin', value: "Mersin"),
                            DropDownValueModel(name: 'Muğla', value: "Muğla"),
                            DropDownValueModel(name: 'Muş', value: "Muş"),
                            DropDownValueModel(
                                name: 'Nevşehir', value: "Nevşehir"),
                            DropDownValueModel(name: 'Niğde', value: "Niğde"),
                            DropDownValueModel(name: 'Ordu', value: "Ordu"),
                            DropDownValueModel(
                                name: 'Osmaniye', value: "Osmaniye"),
                            DropDownValueModel(name: 'Rize', value: "Rize"),
                            DropDownValueModel(
                                name: 'Sakarya', value: "Sakarya"),
                            DropDownValueModel(name: 'Samsun', value: "Samsun"),
                            DropDownValueModel(
                                name: 'Şanlıurfa', value: "Şanlıurfa"),
                            DropDownValueModel(name: 'Siirt', value: "Siirt"),
                            DropDownValueModel(name: 'Sinop', value: "Sinop"),
                            DropDownValueModel(name: 'Sivas', value: "Sivas"),
                            DropDownValueModel(name: 'Şırnak', value: "Şırnak"),
                            DropDownValueModel(
                                name: 'Tekirdağ', value: "Tekirdağ"),
                            DropDownValueModel(name: 'Tokat', value: "Tokat"),
                            DropDownValueModel(
                                name: 'Trabzon', value: "Trabzon"),
                            DropDownValueModel(
                                name: 'Tunceli', value: "Tunceli"),
                            DropDownValueModel(name: 'Uşak', value: "Uşak"),
                            DropDownValueModel(name: 'Van', value: "Van"),
                            DropDownValueModel(name: 'Yalova', value: "Yalova"),
                            DropDownValueModel(name: 'Yozgat', value: "Yozgat"),
                            DropDownValueModel(
                                name: 'Zonguldak', value: "Zonguldak"),
                          ],
                          onChanged: (val) {
                            if (val == "") {
                              selectedCity = "";
                            } else {
                              selectedCity = val.value;
                            }
                          },
                        ),
                        SizedBox(height: gHeight * 0.015),
                        MaskedTextField(
                          onTap: _requestPhoneFocus,
                          focusNode: signUpPhoneFocus,
                          mask: "### ### ## ##",
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 13,
                          controller: phoneSignUp,
                          showCursor: false,
                          decoration: InputDecoration(
                            counter: Offstage(),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: signUpPhoneFocus.hasFocus
                                  ? mainColor
                                  : iconColor,
                            ),
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                                color: signUpPhoneFocus.hasFocus
                                    ? mainColor
                                    : iconColor),
                            hintText: 'Write your phone number',
                            hintStyle: TextStyle(
                                color: signUpPhoneFocus.hasFocus
                                    ? mainColor
                                    : iconColor),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: iconColor),
                                borderRadius: BorderRadius.circular(2)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: mainColor),
                                borderRadius: BorderRadius.circular(2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: gHeight * 0.0050),
                SizedBox(
                  height: gHeight * 0.06,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(mainColor)),
                      onPressed: () async {
                        if (fullName.text.length == 0) {
                          messenger(context,
                              "You didn't enter your name, write it immediately.");
                        } else if (username.text.length == 0) {
                          messenger(context,
                              "You didn't enter your username, write it immediately");
                        } else if (age.text.length == 0) {
                          messenger(context,
                              "You didn't select your age, write it immediately");
                        } else if (selectedCity.length == 0) {
                          messenger(context,
                              "You didn't select your city, select it immediately");
                        } else if (phoneSignUp.text.length == 0) {
                          messenger(context,
                              "You didn't enter a number, write it immediately.");
                        } else if (phoneSignUp.text.length < 10 &&
                            phoneSignUp.text.length > 0) {
                          messenger(context,
                              'You entered a missing number, correct it immediately.');
                        } else {
                          userName = fullName.text;
                          List<String> phones = [];
                          List<Customer> items = await customerListMaker();

                          for (var element in items) {
                            phones.add(element.phone);
                          }
                          if (phones
                              .contains(phoneSignUp.text.replaceAll(' ', ''))) {
                            messenger(context,
                                "The number already exists, try another number");
                          } else {
                            Map<String, String> users = {
                              'name': fullName.text,
                              'phone_number':
                                  phoneSignUp.text.replaceAll(' ', ''),
                              'username': username.text,
                              'city': selectedCity,
                              'age': age.text,
                              'auth_uid': '',
                              'photoURL':
                                  'https://firebasestorage.googleapis.com/v0/b/participate-9a810.appspot.com/o/utils%2Fpersonphone.png?alt=media&token=40d6fee7-7734-4a99-bcb0-2fe82df928cb'
                            };

                            dbRef.push().set(users);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SplashScreenSignUp(),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'SIGN UP',
                        style: GoogleFonts.poppins(color: Colors.white),
                      )),
                ),
                SizedBox(height: gHeight * 0.030),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(SignUpAlreadyHaveAnAccount),
                    GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: mainColor),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _requestPhoneFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(signUpPhoneFocus);
    });
  }

  void _requestFullNameFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(fullNameFocus);
    });
  }

  void _requestUsernameFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(usernameFocus);
    });
  }

  void phoneNExists() async {
    List<Customer> items = await customerListMaker();
    var i = 1;

    for (var element in items) {
      if (element.phone == phoneSignUp.text.replaceAll(' ', '')) {
        loginWithPhone(context);
        break;
      } else {
        if (i == items.length) {
          messenger(context, "Number doesn't exist. Try to register");
        } else {
          i++;
          continue;
        }
      }
    }
  }
}
