import 'package:pkl_smkn1mejayan/env.dart';

class ApiRoute{
  static final String API_KEY = Env.API_KEY;
  static final Uri storageRoute = Uri.parse("${Env.APP_URL}/storage");

  static final Uri loginRoute = Uri.parse("${Env.API_URL}/login");
  static final Uri logoutRoute = Uri.parse("${Env.API_URL}/logout");
  static final Uri checkLoginRoute = Uri.parse('${Env.API_URL}/check-login');
  static final Uri updateAbsenRoute = Uri.parse('${Env.API_URL}/absensi/salah');
  static final Uri absenHadirRoute = Uri.parse('${Env.API_URL}/absensi/hadir');
  static final Uri absenPulangRoute = Uri.parse('${Env.API_URL}/absensi/pulang');
  static final Uri izinPostRoute = Uri.parse('${Env.API_URL}/absensi/izin');
  static final Uri izinPutRoute = Uri.parse('${Env.API_URL}/absensi/izin/edit');
  static final Uri izinGetRoute = Uri.parse('${Env.API_URL}/absensi/izin/get');
  static final Uri izinGetSpecificRoute = Uri.parse('${Env.API_URL}/absensi/izin/show');
  static final Uri jurnalPostRoute = Uri.parse('${Env.API_URL}/jurnal');
  static final Uri jurnalPutRoute = Uri.parse('${Env.API_URL}/jurnal/edit');
  static final Uri jurnalGetRoute = Uri.parse('${Env.API_URL}/jurnal/get');
  static final Uri jurnalGetSpesificRoute = Uri.parse('${Env.API_URL}/jurnal/show');
  static final Uri editProfileRoute = Uri.parse('${Env.API_URL}/edit-profile');
  static final Uri downloadJurnalPdfRoute = Uri.parse('${Env.API_URL}/print/jurnal');
}
