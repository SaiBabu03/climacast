import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  final dynamic url;
  NetworkHelper(this.url);
  Future<dynamic> getdata() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var body = response.body;
      return jsonDecode(body);
    } else {
      print('fail to load data');
    }
  }

}
