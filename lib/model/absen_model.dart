import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class Absen {
  static GetStorage box = GetStorage();
  static late double lat;
  static late double lon;
  static Future sendAbsen(bool? isWFH) async {
    try {
      await Absen.getPosition();
      final Uri url = Uri.parse('${dotenv.get('API_URL')}/absensi/hadir');
      var response = await http.post(url,
          headers: {"Content-Type": 'application/json', 'x-api-key': dotenv.get("API_KEY")},
          body: json.encode({'user_id': box.read('dataLogin')['user']['id'], 'wfh': isWFH, 'lat': lat, 'lon': lon}));

      return json.decode(response.body);
    } catch (e) {
      return 500;
    }
  }

  static Future<void> getPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      lat = position.latitude;
      lon = position.longitude;
      print('Latitude: $lat, Longitude: $lon');
    } catch (e) {
      print('Error: $e');
    }
  }
}
