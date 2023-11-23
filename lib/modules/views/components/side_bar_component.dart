import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/routes/app_route.dart';

class SideBar extends StatelessWidget {
  SideBar({super.key});
  static final box = GetStorage();
  final user = box.read('dataLogin')['user'];
  final detailUser = box.read('dataLogin')['user']['detail_user'];


  @override
  Widget build(BuildContext context) {
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
                      'images/jurusan/${box.read('dataLogin')['user']['detail_user']['jurusan']}.png',
                      width: 75,
                      height: 75,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        verticalDirection: VerticalDirection.down,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            box.read('dataLogin')['user']['name'],
                            style: TextStyle(fontSize: box.read('dataLogin')['user']['name'].length * 3.8),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 2.0,
                            width: 150.0,
                            color: Colors.black,
                          ),
                          SizedBox(height: 10),
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
          ),
        ],
      ),
    );
  }
}
