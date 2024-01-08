import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoute{
  static final String API_KEY = dotenv.get("API_KEY");
  static final Uri storageRoute = Uri.parse("${dotenv.get("APP_URL")}/storage");

  static final Uri loginRoute = Uri.parse("${dotenv.get("API_URL")}/login");
  static final Uri checkLoginRoute = Uri.parse('${dotenv.get("API_URL")}/check-login');
  static final Uri updateAbsenRoute = Uri.parse('${dotenv.get("API_URL")}/absensi/salah');
  static final Uri absenHadirRoute = Uri.parse('${dotenv.get('API_URL')}/absensi/hadir');
  static final Uri absenPulangRoute = Uri.parse('${dotenv.get('API_URL')}/absensi/pulang');
  static final Uri izinPostRoute = Uri.parse('${dotenv.get('API_URL')}/absensi/izin');
  static final Uri izinPutRoute = Uri.parse('${dotenv.get('API_URL')}/absensi/izin/edit');
  static final Uri izinGetRoute = Uri.parse('${dotenv.get('API_URL')}/absensi/izin/get');
  static final Uri izinGetSpecificRoute = Uri.parse('${dotenv.get('API_URL')}/absensi/izin/show');
  static final Uri jurnalPostRoute = Uri.parse('${dotenv.get('API_URL')}/jurnal');
  static final Uri jurnalPutRoute = Uri.parse('${dotenv.get('API_URL')}/jurnal/edit');
  static final Uri jurnalGetRoute = Uri.parse('${dotenv.get('API_URL')}/jurnal/get');
  static final Uri jurnalGetSpesificRoute = Uri.parse('${dotenv.get('API_URL')}/jurnal/show');
  static final Uri ubasPassPostRoute = Uri.parse('${dotenv.get('API_URL')}/ubah-pass');
  static final Uri downloadJurnalPdfRoute = Uri.parse('${dotenv.get('API_URL')}/print/jurnal');
}
