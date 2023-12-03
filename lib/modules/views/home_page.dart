import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/model/absen_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/side_bar_component.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

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
    final positionData = widget.box.read('position');

    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBar(),
      body: ListView(
        children: [
          Center(
            child: Container(
              width: 330,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SingleChildScrollView(
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
                              width: double.infinity,
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
                                        widget.box.read('dataLogin')?['user']?['detail_user']?['detail_pkl']
                                                ?['tempat_dudi'] ??
                                            "",
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
                                              widget.box.read('dataLogin')['user']['detail_user']['detail_pkl']['jam_pkl']
                                                      [getDay().toLowerCase()] ??
                                                  "00:00 - 00:00",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 18, color: textColor),
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
                                              widget.box.read('dataLogin')['user']['detail_user']['detail_pkl']['jam_pkl']
                                                      ?['ji_${getDay().toLowerCase()}'] ??
                                                  "00:00 - 00:00",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 18, color: textColor),
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
                              width: double.infinity,
                              child: FormBuilder(
                                child: Column(
                                  children: [
                                    Card(
                                        margin: EdgeInsets.zero,
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 80),
                                          child: FormBuilderCheckbox(
                                            title: const Center(
                                              child: Text(
                                                "Work From Home",
                                                style:
                                                    TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.bold),
                                              ),
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
                                              icon: const Icon(Icons.login),
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
                                                  } else if (absensi['absen']['status'] == 1 ||
                                                      absensi['absen']['status'] == 4) {
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
                                                    widget.box.write('hasErrorAbsen', true);
                                                    print(widget.box.read('hasErrorAbsen'));
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
                                              label: const Padding(
                                                padding: EdgeInsets.all(10.5),
                                                child: Text("Absen"),
                                              )),
                                          ElevatedButton.icon(
                                            style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(Color.fromRGBO(239, 80, 107, 1))),
                                            onPressed: () async {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: const Text('Processing Data'),
                                                backgroundColor: Colors.green.shade300,
                                              ));
                                              var absensi = await Absen.sendAbsenPulang(isWFH);
                                              print(absensi);
                                              if (absensi['absen']['status'] == 1 ||
                                                    absensi['absen']['status'] == 4) {
                                                  if (context.mounted) {
                                                    ArtSweetAlert.show(
                                                      context: context,
                                                      artDialogArgs: ArtDialogArgs(
                                                        type: ArtSweetAlertType.success,
                                                        title: "Berhasil Absen Pulang!",
                                                        text: absensi['absen']['message'],
                                                      ),
                                                    );
                                                  }
                                                }else {
                                                if (context.mounted) {
                                                  ArtSweetAlert.show(
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType.danger,
                                                      title: "Gagal Absen Pulang!",
                                                      text: absensi['absen']['message'],
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            icon: const Icon(Icons.logout),
                                            label: const Padding(padding: EdgeInsets.all(10.5), child: Text("Pulang")),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                          children: [
                                            const Center(
                                              child: Text("Posisi Anda",style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                              ),textAlign: TextAlign.center),
                                            ),
                                            SizedBox(
                                              height: 200,
                                              child: Card(
                                                elevation: 5,
                                                child: FlutterMap(
                                                  options: MapOptions(
                                                    initialCenter: LatLng(positionData['latitude'],
                                                        positionData['longitude']),
                                                    initialZoom: 15.5,
                                                  ),
                                                  children: [
                                                    TileLayer(
                                                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                      userAgentPackageName: 'com.pklsmkn1mejayan.app',
                                                    ),
                                                    MarkerLayer(
                                                      markers: [
                                                        Marker(
                                                          width: 40.0,
                                                          height: 40.0,
                                                          point: LatLng(positionData['latitude'], positionData['longitude']),
                                                          child: const Icon(
                                                            Icons.location_on,
                                                            color: Colors.red,
                                                            size: 40.0,
                                                          )
                                                        ),
                                                      ],
                                                    ),
                                                    RichAttributionWidget(
                                                      attributions: [
                                                        TextSourceAttribution(
                                                          'OpenStreetMap contributors',
                                                          onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ),
                                            ),
                                            const Center(
                                              child: Text("Posisi bermasalah?"),
                                            ),
                                            Card(
                                              color: const Color.fromRGBO(252,198,43, 1),
                                              child: InkWell(
                                                onTap: ()async{
                                                  if (widget.box.read('hasErrorAbsen') == null || !widget.box.read('hasErrorAbsen')) {
                                                    ArtSweetAlert.show(
                                                      context: context,
                                                      artDialogArgs: ArtDialogArgs(
                                                        type: ArtSweetAlertType.danger,
                                                        title: "Gagal!",
                                                        text: "Anda belum mencoba absen secara biasa!",
                                                      ),
                                                    );
                                                  }else{
                                                    var absensi = await Absen.sendPaksa();
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
                                                      } else if (absensi['absen']['status'] == 1 ||
                                                          absensi['absen']['status'] == 4) {
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
                                                        widget.box.write('hasErrorAbsen', true);
                                                        print(widget.box.read('hasErrorAbsen'));
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
                                                  }
                                                },
                                                child: const SizedBox(
                                                  height: 40,
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text("Absen Paksa", style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                    ),

                                  ],
                                ),
                              )))
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
