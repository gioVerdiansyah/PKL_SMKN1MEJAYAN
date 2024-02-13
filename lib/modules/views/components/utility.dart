import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String truncatedText(String data, {int len = 200}) {
  String kegiatan = data;
  String truncatedKegiatan = kegiatan.length > len ? kegiatan.substring(0, len) + '...' : kegiatan;
  return truncatedKegiatan;
}

String getStatusName(status) {
  if (status == '1') {
    return 'Disetujui';
  } else if (status == '2') {
    return 'Ditolak';
  } else if (status == '0') {
    return 'Pending';
  } else {
    return 'Tidak mengisi';
  }
}

String getDifferentDayInInt(String startDate, String endDate){
  String timeNow = DateTime.now().toString().split(" ")[1];
  DateTime startDateParse = DateTime.parse(startDate + " " + timeNow);
  DateTime endDateParse = DateTime.parse(endDate + " " + timeNow);

  int remainingDay = endDateParse.difference(startDateParse).inDays;

  return
    (remainingDay.toString() == '0')
        ?
    "Sehari"
        :
    "$remainingDay Hari";
}

Color getColorStatus(status) {
  if (status == '1') {
    return const Color.fromRGBO(21, 115, 71, 1);
  } else if (status == '2') {
    return const Color.fromRGBO(220, 53, 69, 1);
  } else if (status == '0') {
    return const Color.fromRGBO(255, 202, 44, 1);
  } else {
    return Colors.brown;
  }
}

class DescriptionText extends StatefulWidget {
  const DescriptionText({super.key, required this.teks, this.len = 200});
  final String teks;
  final int len;

  @override
  State<DescriptionText> createState() => _DescriptionFragment();
}

class _DescriptionFragment extends State<DescriptionText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String alasan = widget.teks;
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Text(
        isExpanded ? alasan : (alasan.length > widget.len ? '${alasan.substring(0, widget.len)}...' : alasan),
        overflow: TextOverflow.visible,
      ),
    );
  }
}
