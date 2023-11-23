import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class PostLoginModel {
  static final box = GetStorage();
  static String apiUrl = dotenv.get("API_URL");

  static Future sendRequest(String username, String password) async {
    try {
      const String loginEndpoint = "/login";
      String apiUrl = PostLoginModel.apiUrl;
      final Uri url = Uri.parse('$apiUrl$loginEndpoint');

      var response = await http.post(url,
          headers: {"Content-Type": "application/json", 'x-api-key': dotenv.get("API_KEY")},
          body: json.encode({
            'email': username,
            'password': password
          }));

      if (json.decode(response.body)['success']) {
        var dataLogin = json.decode(response.body);
        box.write('dataLogin', dataLogin);
      }
      return json.decode(response.body)['success'];
    } catch (e) {
      print('Error: ${e}');
      return 500;
    }
  }

  static Future<bool> checkLogin() async {
    String apiUrl = dotenv.get("API_URL");
    const String checkLoginEndpoint = '/check-login';
    Uri url = Uri.parse('$apiUrl$checkLoginEndpoint');

    Map<String, String> params = {
      'remember_token': PostLoginModel.box.read("dataLogin")["user"]["remember_token"],
    };

    url = url.replace(queryParameters: params);

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    return json.decode(response.body)['success'];
  }
}
