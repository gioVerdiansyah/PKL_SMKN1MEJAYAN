import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/routes/app_route.dart';

class SideBar extends StatelessWidget {
  SideBar({super.key});
  static final box = GetStorage();


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
              decoration: BoxDecoration(color: Colors.green),
              child: Text(box.read('dataLogin')['user']['name'],
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
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
