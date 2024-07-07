import 'package:climacast/weathermodels.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WeatherData extends StatefulWidget {
  WeatherData({super.key, required this.CitynamE});
  final String CitynamE;
  @override
  State<WeatherData> createState() => _WeatherDataState();
}

class _WeatherDataState extends State<WeatherData> {
  WeatherModel weathermodel = WeatherModel();
  int index = 0;
  int? temperature;
  dynamic weatherIcon;
  String? weatherMessage;
  String? cityName;
  int? humidity;
  int? windspeed;
  double? lat;
  double? long;
  String? Description;
  String? WeatherIconurl;
  var weatherData;

  //Updated the weather information based on the current location
  void updateUI(weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherMessage = 'Error to get online data.';
        weatherIcon = '';
        cityName = 'Check the entered location';
        humidity = 0;
        return;
      }

      weatherIcon = weatherData['weather'][0]['icon'];
      temperature = weatherData['main']['temp'].toInt();
      humidity = weatherData['main']['humidity'];
      weatherMessage = weathermodel.getMessage(temperature!);
      cityName = weatherData['name'];
      windspeed = (weatherData['wind']['speed'] * 3.6).toInt();
      lat = weatherData['coord']['lat'];
      long = weatherData['coord']['lon'];
      Description = weatherData['weather'][0]['description'];
      WeatherIconurl = "https://openweathermap.org/img/wn/$weatherIcon@2x.png";
    });
  }

  @override
  void initState() {
    gettingdata();
    super.initState();
  }

  //Updates the weather screen based on current location
  Future getcurrentlocation() async {
    weatherData = await weathermodel.getCurrentWeatherData();
    updateUI(weatherData);
  }

  //Updates the weather screen based on location given by user
  gettingdata() async {
    weatherData = await weathermodel.FetchWeatherByCityName(widget.CitynamE);
    updateUI(weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${temperature ?? ''}°',
            style: GoogleFonts.oswald(color: Colors.black, fontSize: 90),
          ),
          Text(
            cityName ?? '',
            style: GoogleFonts.bebasNeue(fontSize: 60, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Colors.black,
              ),
              Text('lat:$lat, ',
                  style:
                      GoogleFonts.bebasNeue(color: Colors.black, fontSize: 15)),
              Text(
                'long:$long',
                style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 15),
              )
            ],
          ),
          CachedNetworkImage(
            imageUrl: WeatherIconurl ?? '',
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Text(Description ?? '',
              style: GoogleFonts.oswald(color: Colors.black, fontSize: 30)),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Humidity : ${humidity ?? ''}%',
                    style:
                        GoogleFonts.oswald(color: Colors.black, fontSize: 25)),
                const VerticalDivider(
                  thickness: 1,
                  color: Colors.black,
                ),
                Text('Wind : ${windspeed ?? ''} km/h',
                    style:
                        GoogleFonts.oswald(color: Colors.black, fontSize: 25)),
              ],
            ),
          ),
          Text(
            "${weatherMessage ?? ''} in ${cityName ?? ''}!",
            style: GoogleFonts.oswald(color: Colors.black, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        elevation: 50,
        onTap: (int i) {
          setState(() {
            index = i;
            if (index == 0) {
              getcurrentlocation();
            } else if (index == 1) {
              Navigator.pushNamed(context, 'MainScreen');
            } else if (index == 2) {
              gettingdata();
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.near_me_sharp), label: 'Location'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined), label: 'search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.refresh_outlined), label: 'Refresh'),
        ],
      ),
    );
  }
}
