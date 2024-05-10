import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pkl_smkn1mejayan/model/jurnal_model.dart';
import 'package:pkl_smkn1mejayan/env.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/utility.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/pagination_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/detail_pages/detail_jurnal_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_pages/edit_jurnal_page.dart';

class RiwayatJurnalPage extends StatefulWidget {
  const RiwayatJurnalPage({super.key});
  static const String routeName = '/riwayat-jurnal';

  @override
  State<RiwayatJurnalPage> createState() => _RiwayatJurnalView();
}

class _RiwayatJurnalView extends State<RiwayatJurnalPage> {
  bool isExpanded = false;
  Uri? changeAbsen;

  File? downloadedFile;
  String downloadMessage = "Press download";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      body: FutureBuilder(
        future: JurnalModel.getData(changeAbsen),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            print(snapshot.data);
            var page = snapshot.data['data'];

            void passingDownEvent(Uri url) {
              setState(() {
                changeAbsen = url;
              });
            }

            return ((snapshot.data['data']['data'] == null) || snapshot.data['data']['data'].isEmpty)
                ? const Center(
                    child: Text("Belum ada riwayat jurnal PKL"),
                  )
                : Container(
                    margin: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Riwayat Jurnal PKL',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: ListView(
                            children: [
                              if(snapshot.data['doenst_jurnal'] == 0)
                              Card(
                                child: TextButton.icon(
                                    onPressed: () async {
                                      launchUrl(Uri.parse(
                                          "${Env.APP_URL}/print/jurnal/${GetStorage().read('dataLogin')['user']['id']}"));
                                    },
                                    icon: const Icon(Icons.print),
                                    label: const Text("Cetak "
                                        "Jurnal")),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: snapshot.data['data']['data'].length,
                                itemBuilder: (context, index) {
                                  var dataJurnal = snapshot.data['data']['data'][index];
                                  String status;
                                  Color warnaStatus;

                                  if (dataJurnal['status'] == '1') {
                                    warnaStatus = const Color.fromRGBO(21, 115, 71, 1);
                                    status = 'Disetujui';
                                  } else if (dataJurnal['status'] == '2') {
                                    warnaStatus = const Color.fromRGBO(220, 53, 69, 1);
                                    status = 'Ditolak';
                                  } else if (dataJurnal['status'] == '0') {
                                    warnaStatus = const Color.fromRGBO(255, 202, 44, 1);
                                    status = 'Pending';
                                  } else {
                                    warnaStatus = Colors.brown;
                                    status = 'Tidak mengisi';
                                  }

                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  DateFormat('dd MMMM yyyy', 'id_ID')
                                                      .format(DateTime.parse(dataJurnal['created_at'])),
                                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                              Row(
                                                children: [
                                                  const Text("status: "),
                                                  Text(
                                                    status,
                                                    style: TextStyle(color: warnaStatus),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 7),
                                            child: Container(
                                              height: 1.0,
                                              width: double.infinity,
                                              color: Colors.green,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 500,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(top: 8),
                                                      child: Text("Keterangan Jurnal:",
                                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                                    ),
                                                    Text(truncatedText(dataJurnal['kegiatan']))
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  if (dataJurnal['status'] != '1')
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext context) => EditJurnalPage(
                                                                        idJurnal: dataJurnal['id'],
                                                                      )));
                                                        },
                                                        style: const ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(Color.fromRGBO(255, 202, 44, 1))),
                                                        child: const Icon(Icons.edit_note, color: Colors.white,)),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext context) => DetailJurnalPage(data: dataJurnal)));
                                                        },
                                                        style: const ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(Colors.blueAccent)),
                                                        child: const Icon(Icons.list_alt, color: Colors.white,)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (page['next_page_url'] != null || page['prev_page_url'] != null)
                                PaginationComponent(page: page, passingDownEvent: passingDownEvent)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          }
        },
      ),
    );
  }
}
