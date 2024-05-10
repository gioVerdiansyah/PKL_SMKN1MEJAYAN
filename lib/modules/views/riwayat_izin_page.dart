import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pkl_smkn1mejayan/model/perizinan_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/utility.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/pagination_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/detail_pages/detail_izin_page.dart';
import 'package:pkl_smkn1mejayan/modules/views/edit_pages/edit_izin_page.dart';

class RiwayatIzinPage extends StatefulWidget {
  const RiwayatIzinPage({super.key});
  static const String routeName = '/riwayat-izin';

  @override
  State<RiwayatIzinPage> createState() => _RiwayatIzinView();
}

class _RiwayatIzinView extends State<RiwayatIzinPage> {
  bool isExpanded = false;
  Uri? changeIzin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      body: FutureBuilder(
        future: PerizinanModel.getData(changeIzin),
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
                changeIzin = url;
              });
            }

            return ((snapshot.data['data']['data'] == null) || snapshot.data['data']['data'].isEmpty)
                ? const Center(
                    child: Text("Belum ada riwayat izin"),
                  )
                : Container(
                    margin: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Riwayat Izin',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: ListView(children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: snapshot.data['data']['data'].length,
                              itemBuilder: (context, index) {
                                var dataIzin = snapshot.data['data']['data'][index];
                                var i = index + 1;
                                String status;
                                Color warnaStatus;

                                if (dataIzin['status'] == '1') {
                                  warnaStatus = const Color.fromRGBO(21, 115, 71, 1);
                                  status = 'Disetujui';
                                } else if (dataIzin['status'] == '2') {
                                  warnaStatus = const Color.fromRGBO(220, 53, 69, 1);
                                  status = 'Ditolak';
                                } else {
                                  warnaStatus = const Color.fromRGBO(255, 202, 44, 1);
                                  status = 'Pending';
                                }

                                return Container(
                                  child: Card(
                                    margin: const EdgeInsets.all(5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("#$i ${dataIzin['tipe_izin']}",
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
                                                    Text(
                                                        "${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(dataIzin['awal_izin']))} - ${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(dataIzin['akhir_izin']))}"),
                                                    const Padding(
                                                      padding: EdgeInsets.only(top: 8),
                                                      child: Text("Alasan Izin:",
                                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                                    ),
                                                    DescriptionText(teks: dataIzin['alasan'])
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  if (dataIzin['status'] != '1')
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext context) => EditIzinPage(
                                                                        idIzin: dataIzin['id'],
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
                                                                  builder: (BuildContext context) =>
                                                                      DetailIzinPage(data: dataIzin)));
                                                        },
                                                        style: const ButtonStyle(
                                                            backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)),
                                                        child: const Icon(Icons.list, color: Colors.white,)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (page['prev_page_url'] != null || page['next_page_url'] != null)
                              PaginationComponent(page: page, passingDownEvent: passingDownEvent)
                          ]),
                        )
                      ],
                    ),
                  );
          }
        },
      ),
    );
  }
}
