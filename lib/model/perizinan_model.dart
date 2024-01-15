import 'dart:convert';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pkl_smkn1mejayan/routes/api_route.dart';

class PerizinanModel {
  static GetStorage box = GetStorage();

  static Future sendPost(
      String alasan, String awalIzin, String akhirIzin, List<PlatformFile> bukti, String tipeIzin) async {
    try {
      final Uri url = ApiRoute.izinPostRoute;
      var request = http.MultipartRequest('POST', url);
      request.headers['x-api-key'] = ApiRoute.API_KEY;

      // Tambahkan data string
      request.fields['name'] = box.read('dataLogin')['user']['name'].toString();
      request.fields['tipe_izin'] = tipeIzin;
      request.fields['alasan'] = alasan;
      request.fields['awal_izin'] = DateFormat("yyyy-MM-dd").format(DateFormat('dd MMMM y', 'id_ID').parse(awalIzin));
      request.fields['akhir_izin'] = DateFormat("yyyy-MM-dd").format(DateFormat('dd MMMM y', 'id_ID').parse(akhirIzin));

      // Tambahkan file
      if (bukti.isNotEmpty) {
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
      return {
        'success': false, 'message': 'Ada kesalahan aplikasi!'
      };
    }
  }

  static Future getData(Uri? changeIzin) async {
    try {
      final Uri url = changeIzin ?? Uri.parse('${ApiRoute.izinGetRoute}/${box.read('dataLogin')['user']['id']}');
      var response = await http.get(url, headers: {"Content-Type": 'applicatio/json', "x-api-key": ApiRoute.API_KEY});

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return {
        'success': false, 'message': "Ada kesalahan aplikasi"
      };
    }
  }

  static Future getSpecificData(String id) async {
    try{
      final Uri url = Uri.parse('${ApiRoute.izinGetSpecificRoute}/$id');
      print(url);
      var response = await http.get(url, headers: {
        "Content-Type": 'applicatio/json', "x-api-key": ApiRoute.API_KEY
      });
      var data = json.decode(response.body);
      print(data);
      return data;
    }catch(e){
      return {
        'success': false, 'message': "Ada kesalahan aplikasi"
      };
    }
  }

  static Future sendEditAbsen(
      String id, String alasan, String awalIzin, String akhirIzin, List<PlatformFile>? bukti, String tipeIzin) async {
    try {
      final Uri url = Uri.parse("${ApiRoute.izinPutRoute}/$id");
      var request = http.MultipartRequest('POST', url);
      request.headers['x-api-key'] = ApiRoute.API_KEY;

      // Tambahkan data string
      request.fields['name'] = box.read('dataLogin')['user']['name'].toString();
      request.fields['tipe_izin'] = tipeIzin;
      request.fields['alasan'] = alasan;
      request.fields['awal_izin'] = DateFormat("yyyy-MM-dd").format(DateFormat('dd MMMM y', 'id_ID').parse(awalIzin));
      request.fields['akhir_izin'] = DateFormat("yyyy-MM-dd").format(DateFormat('dd MMMM y', 'id_ID').parse(akhirIzin));

      // Tambahkan file
      if (bukti != null) {
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
      print(response.body);
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'success': false, 'message': 'Ada kesalahan aplikasi!'
      };
    }
  }
}
