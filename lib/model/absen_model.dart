import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pkl_smkn1mejayan/routes/api_route.dart';

class Absen {
  static GetStorage box = GetStorage();
  static double lat = box.read('position')['latitude'];
  static double lon = box.read('position')['longitude'];
  static Future sendAbsen(bool? isWFH, [dynamic absenPaksa]) async {
    try {
      final Uri url = ApiRoute.absenHadirRoute;
      var response = await http.post(url,
          headers: {"Content-Type": 'application/json', 'x-api-key': ApiRoute.API_KEY},
          body: json.encode({'user_id': box.read('dataLogin')['user']['id'], 'wfh': isWFH, 'absenPaksa': absenPaksa, 'la'
              't': lat,
            'lo'
              'n': lon}));

      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {'absen': {'success': false, 'message': "Ada kesalahan server!"}};
    }
  }  static Future sendAbsenPulang(bool? isWFH) async {
    try {
      final Uri url = ApiRoute.absenPulangRoute;
      var response = await http.post(url,
          headers: {"Content-Type": 'application/json', 'x-api-key': ApiRoute.API_KEY},
          body: json.encode({'user_id': box.read('dataLogin')['user']['id'], 'wfh': isWFH, 'lat': lat, 'lon': lon}));

      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {'absen': {'success':false, 'message': "Ada kesalahan server!"}};
    }
  }
  static Future sendPaksa()async{
    return Absen.sendAbsen(false, true);
  }
}
