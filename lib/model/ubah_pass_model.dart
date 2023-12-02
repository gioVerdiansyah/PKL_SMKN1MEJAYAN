import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pkl_smkn1mejayan/routes/api_route.dart';

class UbahPassModel {
  static Future sendPost(String oldPass, String newPass) async {
    try {
      var response = await http.put(ApiRoute.ubasPassPostRoute,
          headers: {"Content-Type": "application/json", 'x-api-key': ApiRoute.API_KEY},
          body: json.encode({'user_id':GetStorage().read('dataLogin')['user']['id'],'oldPass': oldPass, 'newPass':
          newPass}));
      var data = json.decode(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return {
        'ubahPass': {'success': false, 'message': "Ada kesalahan server!"}
      };
    }
  }
}
