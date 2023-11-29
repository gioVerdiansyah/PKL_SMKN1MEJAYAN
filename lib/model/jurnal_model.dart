import 'dart:convert';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pkl_smkn1mejayan/routes/api_route.dart';

class JurnalModel {
  static GetStorage box = GetStorage();
  static Future sendPost(String kegiatan, List<PlatformFile> bukti) async {
    try {
      final Uri url = ApiRoute.jurnalPostRoute;
      var request = http.MultipartRequest('POST', url);
      request.headers['x-api-key'] = ApiRoute.API_KEY;

      request.fields['user_id'] = box.read('dataLogin')['user']['id'].toString();
      request.fields['kegiatan'] = kegiatan;

      if (bukti.isNotEmpty) {
        var file = bukti[0];
        var fileStream = http.ByteStream.fromBytes(file.bytes!);
        var length = file.size;

        var multipartFile = http.MultipartFile(
          'bukti',
          fileStream,
          length,
          filename: file.name,
        );

        // Tambahkan file ke dalam request
        request.files.add(multipartFile);
      }

      var response = await http.Response.fromStream(await request.send());
      print(json.decode(response.body));
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'jurnal': {'success': false, 'message': 'Ada kesalahan server!'}
      };
    }
  }
}
