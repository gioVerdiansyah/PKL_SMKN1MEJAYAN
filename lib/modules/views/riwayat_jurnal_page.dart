import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pkl_smkn1mejayan/model/jurnal_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/routes/api_route.dart';

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

            // Handle element pagination
            late List<Widget> paginate;
            late MainAxisAlignment handleMainAxis;

            var page = snapshot.data['jurnal']['data'];
            if (page['next_page_url'] != null && page['prev_page_url'] != null) {
              handleMainAxis = MainAxisAlignment.spaceBetween;
              paginate = [
                TextButton(
                    onPressed: () {
                      setState(() {
                        changeAbsen = Uri.parse(page['prev_page_url']);
                      });
                    },
                    child: const Text("<< Sebelumnya")),
                TextButton(
                    onPressed: () {
                      setState(() {
                        changeAbsen = Uri.parse(page['next_page_url']);
                      });
                    },
                    child: const Text("Selanjutnya >>"))
              ];
            } else if (page['prev_page_url'] != null) {
              handleMainAxis = MainAxisAlignment.start;
              paginate = [
                TextButton(
                    onPressed: () {
                      setState(() {
                        changeAbsen = Uri.parse(page['prev_page_url']);
                      });
                    },
                    child: const Text("<< Sebelumnya"))
              ];
            } else if (page['next_page_url'] != null) {
              handleMainAxis = MainAxisAlignment.end;
              paginate = [
                TextButton(
                    onPressed: () {
                      setState(() {
                        changeAbsen = Uri.parse(page['next_page_url']);
                      });
                    },
                    child: const Text("Selanjutnya >>"))
              ];
            }

            return ((snapshot.data['jurnal']['data']['data'] == null) || snapshot.data['jurnal']['data']['data'].isEmpty)
                ? const Center(
              child: Text("Belum ada riwayat jurnal PKL"),
            )
                : Column(
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
                  child: ListView.builder(
                    itemCount: snapshot.data['jurnal']['data']['data'].length,
                    itemBuilder: (context, index) {
                      var dataJurnal = snapshot.data['jurnal']['data']['data'][index];
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

                      return Container(
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse
                                      (dataJurnal['created_at'])),
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
                                                  width: 200),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child:
                                            Text("Keterangan Jurnal:", style: TextStyle(fontWeight: FontWeight.bold)),
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
                        ),
                      );
                    },
                  ),
                ),
                if(page['next_page_url'] != null || page['prev_page_url'] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Card(
                    child: Row(
                        mainAxisAlignment: handleMainAxis,
                        children: paginate
                    ),
                  )
                )
              ],
            );
          }
        },
      ),
    );
  }
}


class DescriptionAlasan extends StatefulWidget{
  DescriptionAlasan({required this.alasan});
  final String alasan;

  @override
  State<DescriptionAlasan> createState() => _DescriptionFragment();
}

class _DescriptionFragment extends State<DescriptionAlasan>{
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