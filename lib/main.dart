import 'package:flutter/material.dart';
import 'package:pkl_smkn1mejayan/routes/app_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await dotenv.load();
  await GetStorage.init();

  var connectivityResult = await Connectivity().checkConnectivity();
  bool isConnected = connectivityResult != ConnectivityResult.none;

  runApp(isConnected ? const MainApp() : const NoInternetModal());
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
                  var connectivityResult = await Connectivity().checkConnectivity();
                  bool isConnected = connectivityResult != ConnectivityResult.none;
                  runApp(isConnected ? const MainApp() : const NoInternetModal());
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
