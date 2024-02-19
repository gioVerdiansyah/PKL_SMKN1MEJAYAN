import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/utility.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';

import '../../../routes/api_route.dart';

class DetailJurnalPage extends StatelessWidget {
  DetailJurnalPage({required this.data});
  final data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Column(
                  children: [
                    Text("Detail Jurnal", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                      DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(data['created_at'])),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("status: "),
                                    Text(
                                      getStatusName(data['status']),
                                      style: TextStyle(color: getColorStatus(data['status'])),
                                    ),
                                  ],
                                ),
                                if (data['status'] != '3' && data['status'] != '0')
                                  Text(
                                      "${getStatusName(data['status'])} pada : ${DateFormat('dd MMM At HH:mm:ss', 'id_ID'
                                          '').format(DateTime.parse(data['updated_at']).toLocal())}")
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
                                            border: data['bukti'] != null
                                                ? Border.all(
                                                    color: Colors.green,
                                                    width: 2,
                                                  )
                                                : null,
                                          ),
                                          child: (data['bukti'] == null)
                                              ? const Text('No Image...')
                                              : Image.network(
                                                  "${ApiRoute.storageRoute}/${data['bukti']}",
                                                  width: 150,
                                                ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Kegiatan Jurnal:",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DescriptionText(teks: data['kegiatan'], len: 300),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: Divider(
                                          color: Colors.green,
                                          thickness: 2,
                                        ),
                                      ),
                                      const Text("Catatan Guru:",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: DescriptionText(
                                            teks: data['keterangan'] ?? "Tidak ada catatan guru...", len: 300),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
