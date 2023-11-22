import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/side_bar_component.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  static const String routeName = '/';
  final box = GetStorage();

  @override
  State<HomePage> createState() => _HomeView();
}

class _HomeView extends State<HomePage> {
  late String currentTime;
  late String currentDate;

  @override
  void initState() {
    super.initState();
    updateDateTime();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateDateTime();
    });
  }

  void updateDateTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat.Hm().format(now);
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);

    setState(() {
      currentTime = formattedTime;
      currentDate = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color.fromRGBO(55, 73, 87, 1);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "images/Logo_SMK.png",
          width: 45,
          height: 45,
        ),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      drawer: SideBar(),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Text(
                    currentTime ?? "",
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  Text(
                    currentDate ?? "",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
                  ),
                  Card(
                    margin: const EdgeInsets.only(top: 15),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: 330,
                          child: Center(
                            child: Column(
                              children: [
                                const Text(
                                  "PKL di: ",
                                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    widget.box.read('dataLogin')['detail_user'][0]['tempat_dudi'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                  const Card(
                    margin: EdgeInsets.only(top: 15),
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: 330,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  "Senin",
                                  style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 15),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "Jam Masuk",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
