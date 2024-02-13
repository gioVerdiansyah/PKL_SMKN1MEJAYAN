import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/modules/views/login_page.dart';
import 'package:pkl_smkn1mejayan/routes/app_route.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});
  static final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final user = box.read('dataLogin')['user'] ?? "";
    void NavigasiKe(routeName) {
      if (ModalRoute.of(context)?.settings.name != routeName) {
        Navigator.pushNamed(context, routeName);
      }
    }

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Row(
                children: [
                  Image.network(
                    "${user['photo_profile']}",
                    width: 75,
                    height: 75,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${user['name']} (${user['absen']})",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 2.0,
                          width: 200.0,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user['kelas']['kelas'],
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          ListTile(
            title: const Text("Home"),
            onTap: () {
              NavigasiKe(AppRoute.homeRoute);
            },
          ),
          ListTile(
            title: const Text("Izin"),
            onTap: () {
              NavigasiKe(AppRoute.izinRoute);
            },
          ),
          ListTile(
            title: const Text("Jurnal"),
            onTap: () {
              NavigasiKe(AppRoute.jurnalRoute);
            },
          ),
          ListTile(
            title: const Text("Edit Profile"),
            onTap: () {
              NavigasiKe(AppRoute.ubahPassRoute);
            },
          ),
          ListTile(
            title: const Text("Logout"),
            onTap: () async {
              ArtDialogResponse response = await ArtSweetAlert.show(
                  barrierDismissible: false,
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      denyButtonText: "Batal",
                      title: "Apakah Anda yakin?",
                      confirmButtonText: "Ya, logout",
                      type: ArtSweetAlertType.warning));

              if (response == null) {
                return;
              }

              if (response.isTapConfirmButton) {
                GetStorage().remove('dataLogin');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
                return;
              }
            },
          ),
        ],
      ),
    );
  }
}
