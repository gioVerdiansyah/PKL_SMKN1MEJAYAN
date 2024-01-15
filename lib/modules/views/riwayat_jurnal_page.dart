import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pkl_smkn1mejayan/model/jurnal_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/pagination_component.dart';
import 'package:pkl_smkn1mejayan/routes/api_route.dart';
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

            void passingDownEvent(Uri url){
              setState(() {
                changeAbsen = url;
              });
            }

            return ((snapshot.data['data']['data'] == null) || snapshot.data['data']['data'].isEmpty)
                ? const Center(
                    child: Text("Belum ada riwayat jurnal PKL"),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
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
                              Card(
                                child: TextButton.icon(onPressed: () async {
                                  launchUrl(Uri.parse("${dotenv.get('APP_URL')}/print/jurnal/${GetStorage().read
                                    ('dataLogin')['user']['id']}"));
                                }, icon: const Icon(Icons.print), label: const Text("Cetak "
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

                                  print(dataJurnal);

                                  if (dataJurnal['status'] == '1') {
                                    warnaStatus = const Color.fromRGBO(21, 115, 71, 1);
                                    status = 'Disetujui';
                                  } else if (dataJurnal['status'] == '2') {
                                    warnaStatus = const Color.fromRGBO(220, 53, 69, 1);
                                    status = 'Ditolak';
                                  } else {
                                    warnaStatus = const Color.fromRGBO(255, 202, 44, 1);
                                    status = 'Pending';
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
                                                    Center(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.green,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Image.network("${ApiRoute.storageRoute}/${dataJurnal['bukti']}",
                                                            width: 150),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(top: 8),
                                                      child: Text("Keterangan Jurnal:",
                                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                                    ),
                                                    DescriptionAlasan(alasan: dataJurnal['kegiatan'])
                                                  ],
                                                ),
                                              ),
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
                                                    child: const Icon(Icons.edit_note)),
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

class DescriptionAlasan extends StatefulWidget {
  const DescriptionAlasan({super.key, required this.alasan});
  final String alasan;

  @override
  State<DescriptionAlasan> createState() => _DescriptionFragment();
}

class _DescriptionFragment extends State<DescriptionAlasan> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String alasan = widget.alasan;
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Text(
        isExpanded ? alasan : (alasan.length > 200 ? '${alasan.substring(0, 200)}...' : alasan),
        overflow: TextOverflow.visible,
      ),
    );
  }
}
