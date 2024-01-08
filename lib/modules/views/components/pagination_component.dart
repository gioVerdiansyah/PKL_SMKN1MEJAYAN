import 'package:flutter/material.dart';

class PaginationComponent extends StatelessWidget{
  PaginationComponent({super.key, required this.page, required this.passingDownEvent});
  Map<String, dynamic> page;
  void Function(Uri)? passingDownEvent;
  late List<Widget> paginate;

  @override
  Widget build(BuildContext context) {
    if (page['next_page_url'] != null && page['prev_page_url'] != null) {
      paginate = [
        TextButton(
            onPressed: (){
              passingDownEvent!(Uri.parse(page['prev_page_url']));
            },
            child: const Text("<< Sebelumnya")),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(page['current_page'].toString()),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(1.8),
            child: TextButton(
                onPressed: (){
                  passingDownEvent!(Uri.parse(page['next_page_url']));
                },
                child: const Text("Selanjutnya >>")),
          ),
        )
      ];
    } else if (page['prev_page_url'] != null) {
      paginate = [
        Card(
          child: Padding(
              padding: const EdgeInsets.all(1.8),
              child: TextButton(
                  onPressed: (){
                    passingDownEvent!(Uri.parse(page['prev_page_url']));
                  },
                  child: const Text("<< Sebelumnya"))),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(page['current_page'].toString()),
          ),
        )
      ];
    } else if (page['next_page_url'] != null) {
      paginate = [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(page['current_page'].toString()),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(1.8),
            child: TextButton(
                onPressed: (){
                  passingDownEvent!(Uri.parse(page['next_page_url']));
                },
                child: const Text("Selanjutnya >>")),
          ),
        )
      ];
    }
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: paginate));
  }
}