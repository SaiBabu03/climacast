import 'package:climacast/Screens/MainScreen.dart';
import 'Screens/weatherdata.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? inputcity;
  //Method to implement data persistance using sharedpreferences
  persistance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      inputcity = prefs.getString('city');
    });
  }

  @override
  void initState() {
    persistance();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: inputcity==null?MainScreen():WeatherData(CitynamE: inputcity??''), //check for data persistance
      theme:
          ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFFEDECEA)),
      initialRoute: '/',
      routes: {
        'MainScreen': (context) => MainScreen(),
      },
    );
  }
}
