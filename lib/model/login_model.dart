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

      if (decodedResponse['success']) {
        box.write('dataLogin', decodedResponse['data']);
        print(box.read('dataLogin'));
      }

      return decodedResponse;
    } catch (e) {
      print('Error: $e');
      return {
        'success': false, 'message': "Ada Kesalahan Server!"
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
        'success': false, 'message': "Ada kesalahan server!"
      };
    }
  }

  static Future logout() async{
    GetStorage box = GetStorage();
    try {
      final Uri url = ApiRoute.logoutRoute;
      print(box.read('dataLogin'));
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiRoute.API_KEY,
          'Authorization': "Bearer ${box.read('dataLogin')['token']}"
        },
      );

      var data = json.decode(response.body);
      if(data['success']){
        box.erase();
      }
      return data;
    }catch(e){
      return {
        'success': false, 'message': 'Ada kesalahan Server', "data": e
      };
    }
  }
}
