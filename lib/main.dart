import 'package:flutter/material.dart';
import 'package:pkl_smkn1mejayan/routes/app_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restart_app/restart_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await dotenv.load(fileName: 'assets/.env');
  await GetStorage.init();
  final box = GetStorage();
  await Geolocator.requestPermission();

  var connectivityResult = await Connectivity().checkConnectivity();
  bool isConnected = connectivityResult != ConnectivityResult.none;
  late bool isEnableLocation = false;

  // Deklarasi fungsi _determinePosition()
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isEnableLocation = true;
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isEnableLocation = true;
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isEnableLocation = true;
      return Future.error('Location permissions are permanently denied.');
    }

    // Permissions are granted, and we can continue accessing the position.
    return await Geolocator.getCurrentPosition();
  }

  // Pemanggilan fungsi _determinePosition()
  try {
    Position position = await _determinePosition();
    box.write('position', {
      'latitude': position.latitude,
      'longitude': position.longitude
    });
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  } catch (e) {
    print('Error: $e');
  }
  if(!isConnected){
    runApp(const NoInternetModal());
  }else if(isEnableLocation){
    runApp(const PosisitionDeniedModal());
  }else{
    runApp(const MainApp());
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoute.INITIAL,
      routes: AppRoute.routes,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}

class NoInternetModal extends StatelessWidget {
  const NoInternetModal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AlertDialog(
            title: const Text("Tidak Terkoneksi dengan Internet"),
            content: const Text("Anda tidak terkoneksi dengan internet!!\nRestart aplikasi jika sudah terhubung."),
            actions: [
              TextButton(
                onPressed: () async {
                  Restart.restartApp();
                  },
                child: const Text("Restart"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class PosisitionDeniedModal extends StatelessWidget {
  const PosisitionDeniedModal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AlertDialog(
            title: const Text("Lokasi telah di tolak!!!"),
            content: const Text("Anda tidak dapat me akses aplikasi!\nCoba nyalakan lokasi anda lalu setujui aplikasi "
                "untuk mengakses aplikasi anda\nKlik OK untuk Merestart"),
            actions: [
              TextButton(
                onPressed: () async {
                  Restart.restartApp();
                  },
                child: const Text("OK"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
