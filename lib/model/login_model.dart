import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/routes/api_route.dart';

class PostLoginModel {
  static final box = GetStorage();

  static Future sendRequest(String username, String password) async {
    try {
      final Uri url = ApiRoute.loginRoute;

      var response = await http.post(url,
          headers: {"Content-Type": "application/json", 'x-api-key': ApiRoute.API_KEY},
          body: json.encode({'email': username, 'password': password}));

      var decodedResponse = json.decode(response.body);

      if (decodedResponse['login']['success']) {
        var dataLogin = decodedResponse;
        box.write('dataLogin', dataLogin['login']);
        print(box.read('dataLogin'));
      }

      return decodedResponse;
    } catch (e) {
      print('Error: $e');
      return {
        'login': {'success': false, 'message': "Ada Kesalahan Server!"}
      };
    }
  }

  static Future checkLogin() async {
    try {
      Uri url = ApiRoute.checkLoginRoute;

      Map<String, String> params = {
        'remember_token': PostLoginModel.box.read("dataLogin")["user"]["remember_token"],
      };

      url = url.replace(queryParameters: params);

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'login': {'success': false, 'message': "Ada kesalahan server!"}
      };
    }
  }
}
