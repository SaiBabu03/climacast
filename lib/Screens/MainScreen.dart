import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weatherdata.dart';

class MainScreen extends StatefulWidget {
  final dynamic locationData;

  MainScreen({super.key, this.locationData});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? cityname;
  TextEditingController citytext = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    citytext.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Form(
                      key: formkey,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: citytext,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Location',
                                hintText: 'Enter the location',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.purple, width: 2)),
                                hintStyle:
                                    GoogleFonts.oswald(color: Colors.black),
                                labelStyle: GoogleFonts.oswald(
                                    fontSize: 17, color: Colors.black),
                                prefixIcon:
                                    const Icon(Icons.location_city_outlined),
                                errorStyle: GoogleFonts.oswald(),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the location';
                                }
        
                                return null;
                              },
                              onChanged: (value) {
                                cityname = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search,
                                size: 30, color: Colors.black),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const SpinKitWaveSpinner(
                                      waveColor: Colors.cyan,
                                      size: 80,
                                      trackColor: Colors.lightBlue,
                                      color: Colors.white,
                                    );
                                  });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('city', citytext.text);
                              if (formkey.currentState!.validate()) {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WeatherData(CitynamE: cityname!)));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
