import 'dart:html';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/side_bar_component.dart';

class IzinPage extends StatefulWidget {
  IzinPage({super.key});
  static const String routeName = '/izin';

  @override
  State<IzinPage> createState() => _IzinView();
}

class _IzinView extends State<IzinPage> {
  final box = GetStorage();
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBarComponent(),
      drawer: SideBar(),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.access_time),
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text('History Izin'),
              ),
            ),
            FormBuilder(
                child: Column(
              children: [
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Column(
                      children: [
                        const Text(
                          "Perizinan",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        FormBuilderTextField(
                          initialValue: box.read('dataLogin')['user']['name'],
                          name: 'fullName',
                          readOnly: true,
                          style: const TextStyle(color: Colors.grey),
                          decoration: const InputDecoration(
                            labelText: "Nama Lengkap",
                            labelStyle: TextStyle(color: Colors.black),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          autofocus: true,
                        ),
                        FormBuilderDropdown(
                          name: 'tipeizin',
                          initialValue: "--Pilih Tipe Izin--",
                          items: ['--Pilih Tipe Izin--', 'Opsi 1', 'Opsi 2', 'Opsi 3']
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          decoration: const InputDecoration(
                            labelText: "Tipe Izin",
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(), FormBuilderValidators.notEqual("--Pilih Tipe Izin--")]),
                        ),
                        FormBuilderTextField(
                          name: 'textareaField',
                          maxLines: 5,
                          decoration: const InputDecoration(
                              labelText: 'Textarea Label', floatingLabelBehavior: FloatingLabelBehavior.always),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 300.0,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: FormBuilderDateTimePicker(
                                  name: 'mulai-tanggal-izin',
                                  inputType: InputType.date,
                                  initialValue: DateTime.now(),
                                  format: DateFormat('d-M-y'),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: "Mulai tanggal Izin",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8), // Menambahkan jarak antara dua picker
                              Flexible(
                                child: FormBuilderDateTimePicker(
                                  name: 'mulai-tanggal-izin',
                                  inputType: InputType.date,
                                  initialValue: DateTime.now(),
                                  format: DateFormat('d-M-y'),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: "Mulai tanggal Izin",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
