import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoute{
  static final String API_KEY = dotenv.get("API_KEY");

  static final Uri loginRoute = Uri.parse("${dotenv.get("API_URL")}/login");
  static final Uri checkLoginRoute = Uri.parse('${dotenv.get("API_URL")}/check-login');
  static final Uri absenHadirRoute = Uri.parse('${dotenv.get('API_URL')}/absensi/hadir');
  static final Uri absenPulangRoute = Uri.parse('${dotenv.get('API_URL')}/absensi/pulang');
  static final Uri izinPostRoute = Uri.parse('${dotenv.get('API_URL')}/absensi/izin');
  static final Uri izinGetRoute = Uri.parse('${dotenv.get('API_URL')}/absensi/izin/get');
  static final Uri jurnalPostRoute = Uri.parse('${dotenv.get('API_URL')}/jurnal');
  static final Uri ubasPassPostRoute = Uri.parse('${dotenv.get('API_URL')}/ubah-pass');
}