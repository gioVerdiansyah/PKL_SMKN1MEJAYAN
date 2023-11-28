import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/model/absen_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/side_bar_component.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  static const String routeName = '/';
  final box = GetStorage();

  @override
  State<HomePage> createState() => _HomeView();
}

class _HomeView extends State<HomePage> {
  // input
  var isWFH;

  late String currentTime;
  late String currentDate;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    updateDateTime();
    // Use a Timer.periodic and store it in a class variable
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        updateDateTime();
      } else {
        t.cancel();
      }
    });
  }

  void updateDateTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat.Hm().format(now);
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);

    if (mounted) {
      setState(() {
        currentTime = formattedTime;
        currentDate = formattedDate;
      });
    }
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    timer.cancel();
    super.dispose();
  }

  String getDay() {
    var now = DateTime.now();
    var formatter = DateFormat('EEEE', 'id_ID');
    var hari = formatter.format(now);
    return hari;
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color.fromRGBO(55, 73, 87, 1);

    return Scaffold(
      appBar: AppBarComponent(),
      drawer: SideBar(),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Text(
                    currentTime,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  Text(
                    currentDate,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
                  ),
                  Card(
                    elevation: 5,
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
                                    widget.box.read('dataLogin')?['user']?['detail_user']?['detail_pkl']?['tempat_dudi']
                                        ?? "",
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
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(top: 15),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: 330,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  getDay(),
                                  style: const TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Jam Masuk',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          widget.box.read('dataLogin')['user']['detail_user']['detail_pkl']
                                          ['jam_pkl'][getDay().toLowerCase()] ?? "00:00 - 00:00",
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: textColor),
                                        ),
                                        const Text(
                                          'Jam Istirahat',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          widget.box.read('dataLogin')['user']['detail_user']['detail_pkl']
                                                  ['jam_pkl']?['ji_${getDay().toLowerCase()}']
                                              ?? "00:00 - 00:00",
                                          style:
                                              const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: textColor),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        )),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                          width: 330,
                          child: FormBuilder(
                            child: Column(
                              children: [
                                Card(
                                    margin: EdgeInsets.zero,
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 50),
                                      child: FormBuilderCheckbox(
                                        title: const Text(
                                          "Work From Home",
                                          style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.bold),
                                        ),
                                        name: "wfh",
                                        onChanged: (value) {
                                          setState(() {
                                            isWFH = value ?? false;
                                          });
                                        },
                                      ),
                                    )),
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                          icon: Icon(Icons.login),
                                          onPressed: () async {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: const Text('Processing Data'),
                                              backgroundColor: Colors.green.shade300,
                                            ));
                                            var absensi = await Absen.sendAbsen(isWFH);
                                            print(absensi);
                                            if (absensi['absen']['success']) {
                                              if (absensi['absen']['status'] == 2) {
                                                if (context.mounted) {
                                                  ArtSweetAlert.show(
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType.warning,
                                                      title: "Berhasil Absen!",
                                                      text: absensi['absen']['message'],
                                                    ),
                                                  );
                                                }
                                              } else if (absensi['absen']['status'] == 1 || absensi['absen']['status'] == 4) {
                                                if (context.mounted) {
                                                  ArtSweetAlert.show(
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType.success,
                                                      title: "Berhasil Absen!",
                                                      text: absensi['absen']['message'],
                                                    ),
                                                  );
                                                }
                                              }
                                            } else {
                                              if (context.mounted) {
                                                ArtSweetAlert.show(
                                                  context: context,
                                                  artDialogArgs: ArtDialogArgs(
                                                    type: ArtSweetAlertType.danger,
                                                    title: "Gagal Absen!",
                                                    text: absensi['absen']['message'],
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          label: Padding(
                                            padding: EdgeInsets.all(10.5),
                                            child: const Text("Absen"),
                                          )),
                                      ElevatedButton.icon(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(239, 80, 107, 1))),
                                        onPressed: () async {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: const Text('Processing Data'),
                                            backgroundColor: Colors.green.shade300,
                                          ));
                                          var absensi = await Absen.sendAbsenPulang(isWFH);
                                          print(absensi);
                                          if (absensi == 500) {
                                            if (context.mounted) {
                                              ArtSweetAlert.show(
                                                context: context,
                                                artDialogArgs: ArtDialogArgs(
                                                  type: ArtSweetAlertType.danger,
                                                  title: "Gagal!",
                                                  text: "Ada kesalahan server!",
                                                ),
                                              );
                                            }
                                          } else if (absensi['absen']['success']) {
                                            if (absensi['absen']['status'] == 2) {
                                              if (context.mounted) {
                                                ArtSweetAlert.show(
                                                  context: context,
                                                  artDialogArgs: ArtDialogArgs(
                                                    type: ArtSweetAlertType.warning,
                                                    title: "Berhasil Absen!",
                                                    text: absensi['absen']['message'],
                                                  ),
                                                );
                                              }
                                            } else if (absensi['absen']['status'] == 1 || absensi['absen']['status'] == 4) {
                                              if (context.mounted) {
                                                ArtSweetAlert.show(
                                                  context: context,
                                                  artDialogArgs: ArtDialogArgs(
                                                    type: ArtSweetAlertType.success,
                                                    title: "Berhasil Absen!",
                                                    text: absensi['absen']['message'],
                                                  ),
                                                );
                                              }
                                            }
                                          } else {
                                            if (context.mounted) {
                                              ArtSweetAlert.show(
                                                context: context,
                                                artDialogArgs: ArtDialogArgs(
                                                  type: ArtSweetAlertType.danger,
                                                  title: "Gagal Absen!",
                                                  text: absensi['absen']['message'],
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        icon: Icon(Icons.logout),
                                        label: Padding(padding: EdgeInsets.all(10.5), child: Text("Pulang")),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
