import 'dart:convert';

import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pkl_smkn1mejayan/routes/api_route.dart';

class EditProfileModel {
  static Future sendPost(String oldPass, String confirmPass, String newPass, List<PlatformFile>? bukti, String newPhone)
  async {
    try {
      var request = http.MultipartRequest('POST',
        Uri.parse("${ApiRoute.editProfileRoute}/${GetStorage().read('dataLogin')['user']['id']}")
      );
      request.headers['x-api-key'] = ApiRoute.API_KEY;

      request.fields['oldPass'] = oldPass;
      request.fields['confirmPass'] = confirmPass;
      request.fields['newPass'] = newPass;
      request.fields['no_hp'] = newPhone;

      if (bukti != null) {
        var file = bukti[0];
        var fileStream = http.ByteStream.fromBytes(file.bytes!);
        var length = file.size;

        var multipartFile = http.MultipartFile(
          'photo_profile',
          fileStream,
          length,
          filename: file.name,
        );

        request.files.add(multipartFile);
      }

      var response = await http.Response.fromStream(await request.send());
      var data = json.decode(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return {
        'success': false, 'message': "Ada kesalahan aplikasi!"
      };
    }
  }
}
