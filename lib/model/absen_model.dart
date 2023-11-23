import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Absen {
  static GetStorage box = GetStorage();
  static double lat = box.read('position')['latitude'];
  static double lon = box.read('position')['longitude'];
  static Future sendAbsen(bool? isWFH) async {
    try {
      final Uri url = Uri.parse('${dotenv.get('API_URL')}/absensi/hadir');
      var response = await http.post(url,
          headers: {"Content-Type": 'application/json', 'x-api-key': dotenv.get("API_KEY")},
          body: json.encode({'user_id': box.read('dataLogin')['user']['id'], 'wfh': isWFH, 'lat': lat, 'lon': lon}));

      return json.decode(response.body);
    } catch (e) {
      return 500;
    }
  }  static Future sendAbsenPulang(bool? isWFH) async {
    try {
      final Uri url = Uri.parse('${dotenv.get('API_URL')}/absensi/pulang');
      var response = await http.post(url,
          headers: {"Content-Type": 'application/json', 'x-api-key': dotenv.get("API_KEY")},
          body: json.encode({'user_id': box.read('dataLogin')['user']['id'], 'wfh': isWFH, 'lat': lat, 'lon': lon}));

      return json.decode(response.body);
    } catch (e) {
      print(e);
      return 500;
    }
  }
}
