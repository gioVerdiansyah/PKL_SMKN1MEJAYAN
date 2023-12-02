import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/modules/views/login_page.dart';
import 'package:pkl_smkn1mejayan/routes/app_route.dart';

class SideBar extends StatelessWidget {
  SideBar({super.key});
  static final box = GetStorage();


  @override
  Widget build(BuildContext context) {
    final user = box.read('dataLogin')['user'] ?? "";
    final detailUser = box.read('dataLogin')['user']['detail_user'] ?? "";
    void NavigasiKe(routeName){
      if(ModalRoute.of(context)?.settings.name != routeName) {
        Navigator.pushNamed(context, routeName);
      }
    }

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Card(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/jurusan/${box.read('dataLogin')['user']['detail_user']['jurusan']}.png',
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
                            user['name'],
                            style: TextStyle(fontSize: user['name'].length * 3.8),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 2.0,
                            width: 150.0,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${detailUser['tingkat']} ${detailUser['jurusan']} ${detailUser['kelas']}',
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          ListTile(
            title: const Text("Home"),
            onTap: () {
              NavigasiKe(AppRoute.homeRoute);
            },
          ),ListTile(
            title: const Text("Izin"),
            onTap: () {
              NavigasiKe(AppRoute.izinRoute);
            },
          ),ListTile(
            title: const Text("Jurnal"),
            onTap: () {
              NavigasiKe(AppRoute.jurnalRoute);
            },
          ),ListTile(
            title: const Text("Ubah Password"),
            onTap: () {
              NavigasiKe(AppRoute.ubahPassRoute);
            },
          ),ListTile(
            title: const Text("Logout"),
            onTap: () async {
              ArtDialogResponse response = await ArtSweetAlert.show(
                  barrierDismissible: false,
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      denyButtonText: "Batal",
                      title: "Apakah Anda yakin?",
                      confirmButtonText: "Ya, logout",
                      type: ArtSweetAlertType.warning
                  )
              );

              if(response==null) {
                return;
              }

              if(response.isTapConfirmButton) {
                GetStorage().erase();
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
