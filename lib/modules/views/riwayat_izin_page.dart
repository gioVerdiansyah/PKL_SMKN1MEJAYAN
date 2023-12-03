import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pkl_smkn1mejayan/model/perizinan_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';

class RiwayatIzinPage extends StatefulWidget {
  const RiwayatIzinPage({super.key});
  static const String routeName = '/riwayat-izin';

  @override
  State<RiwayatIzinPage> createState() => _RiwayatIzinView();
}

class _RiwayatIzinView extends State<RiwayatIzinPage> {
  List<dynamic> izinData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var data = await PerizinanModel.getData();
    setState(() {
      izinData = data['izin']['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      body: FutureBuilder(
        future: PerizinanModel.getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Column(
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
                  child: ListView.builder(
                    itemCount: snapshot.data['izin']['data'].length,
                    itemBuilder: (context, index) {
                      var dataIzin = snapshot.data['izin']['data'][index];
                      var i = index + 1;
                      print(dataIzin);
                      return Container(
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#$i ${dataIzin['tipe_izin']}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 7),
                                  child: Container(
                                    height: 1.0,
                                    width: double.infinity,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                    "${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(dataIzin['awal_izin']))} - ${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(dataIzin['akhir_izin']))}"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      flex: 100,
                                      child: Column(
                                        children: [
                                          Text("Alasan Izin"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 500,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(": ${dataIzin['alasan']}",overflow: TextOverflow.visible,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
