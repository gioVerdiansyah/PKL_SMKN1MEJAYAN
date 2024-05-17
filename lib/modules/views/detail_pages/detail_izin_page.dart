import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/utility.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';

import '../../../routes/api_route.dart';

class DetailIzinPage extends StatelessWidget {
  DetailIzinPage({required this.data});
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
                    Text("Detail Izin", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                      DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(data['created_at'])),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    children: [
                                      const Text("status: "),
                                      Text(
                                        getStatusName(data['status']),
                                        style: TextStyle(color: getColorStatus(data['status'])),
                                      ),
                                    ],
                                  ),
                                ),
                                if (data['status'] != '0')
                                  Text("${getStatusName(data['status'])} pada : ${DateFormat('dd MMM At HH:mm:ss', 'id_ID'
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
                                              : FadeInImage(
                                                  placeholder: const AssetImage('assets/images/loading.gif'),
                                                  image: NetworkImage("${ApiRoute.storageRoute}/${data['bukti']}"),
                                                  width: 150,
                                                ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Alasan Izin:",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DescriptionText(teks: data['alasan'], len: 300),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Izin selama: ",
                                                style: TextStyle(color: Color.fromRGBO(52, 53, 65, 1))),
                                            Text(
                                              getDifferentDayInInt(data['awal_izin'], data['akhir_izin']),
                                              style: const TextStyle(color: Color.fromRGBO(52, 53, 65, 1)),
                                            )
                                          ],
                                        ),
                                      ),
                                      if (data['status'] != '0')
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(bottom: 10),
                                              child: Divider(
                                                color: Colors.green,
                                                thickness: 2,
                                              ),
                                            ),
                                            const Text("Catatan Guru:",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: DescriptionText(
                                                  teks: data['comment_guru'] ?? "Tidak ada catatan guru...", len: 300),
                                            ),
                                          ],
                                        )
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
