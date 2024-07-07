import 'networking.dart';
import 'package:geolocator/geolocator.dart';

const Apikey = '36a4519d73529e3bb1330db7c33f6c16';
const OpenWeatherurl = 'https://api.openweathermap.org/data/2.5/weather?';

class WeatherModel {
  double? latitude;
  double? longitude;

  // fetch data from the OpenWeatherMap API
  FetchWeatherByCityName(String cityname) async {
    Uri url =
        Uri.parse('${OpenWeatherurl}q=$cityname&appid=$Apikey&units=metric');
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getdata();
    return weatherData;
  }

  //requesting location permission and gets the position
  Future<void> getCurrentLocation() async {
    try {
LocationPermission permission;
       permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  //fetch weather condition based on current location of the user
  Future<dynamic> getCurrentWeatherData() async {
    await getCurrentLocation();
    Uri currentlocationurl=Uri.parse('${OpenWeatherurl}lat=$latitude&lon=$longitude&appid=$Apikey&units=metric');
    NetworkHelper networkHelper = NetworkHelper(currentlocationurl);
    var weatherData = await networkHelper.getdata();
    return weatherData;
  }

//statements to show the weather condition
  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
