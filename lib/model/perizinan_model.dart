import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PerizinanModel {
  static GetStorage box = GetStorage();

  static Future sendPost(String alasan, String awalIzin, String akhirIzin, List<PlatformFile>? bukti, String tipeIzin)
  async {
    try {
      final Uri url = Uri.parse('${dotenv.get('API_URL')}/absensi/izin');
      var request = http.MultipartRequest('POST', url);
      request.headers['x-api-key'] = dotenv.get('API_KEY');

      // Tambahkan data string
      request.fields['name'] = box.read('dataLogin')['user']['name'].toString();
      request.fields['tipe_izin'] = tipeIzin;
      request.fields['alasan'] = alasan;
      request.fields['awal_izin'] = awalIzin;
      request.fields['akhir_izin'] = akhirIzin;

      // Tambahkan file
      if (bukti != null && bukti.isNotEmpty) {
        var file = bukti[0]; // Ambil elemen pertama dari daftar file
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

      // Kirim request dan dapatkan respons
      var response = await http.Response.fromStream(await request.send());
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {'izin': {'success': false, 'message': 'Ada kesalahan server!'}};
    }
  }
}
