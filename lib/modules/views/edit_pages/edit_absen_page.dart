import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pkl_smkn1mejayan/model/absen_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';

class EditAbsenPage extends StatefulWidget {
  const EditAbsenPage({super.key});
  static const String routeName = '/edit-absen';

  @override
  State<EditAbsenPage> createState() => _EditAbsenView();
}

class _EditAbsenView extends State<EditAbsenPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController statusController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarComponent(),
        body: ListView(children: [
          Center(
              child: Container(
                  width: 330,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    const Center(
                      child: Text('Edit absen hari ini', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Card(
                      child: FormBuilder(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              FormBuilderDropdown(
                                name: 'status',
                                initialValue: '-- Pilih Status Absensi --',
                                onChanged: (value) {
                                  setState(() {
                                    statusController.text = value.toString();
                                  });
                                },
                                items: ['-- Pilih Status Absensi --', 'Hadir', 'WFH', 'Reset']
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.notEqual('-- Pilih Status Absensi --')
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Card(
                                  color: const Color.fromRGBO(252, 198, 43, 1),
                                  child: InkWell(
                                    onTap: () async {
                                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: const Text('Processing Data'),
                                          backgroundColor: Colors.green.shade300,
                                        ));
                                        var absensi = await Absen.sendUpdateAbsen(statusController.text);
                                        if (absensi['success']) {
                                          if (absensi['status'] == 2 || absensi['status'] == 3 || absensi['status'] == 5) {
                                            if (context.mounted) {
                                              ArtSweetAlert.show(
                                                context: context,
                                                artDialogArgs: ArtDialogArgs(
                                                  type: ArtSweetAlertType.warning,
                                                  title: "Berhasil me-edit absen Namun!",
                                                  text: absensi['message'],
                                                ),
                                              );
                                            }
                                          } else if (absensi['status'] == 1 || absensi['status'] == 4) {
                                            if (context.mounted) {
                                              ArtSweetAlert.show(
                                                context: context,
                                                artDialogArgs: ArtDialogArgs(
                                                  type: ArtSweetAlertType.success,
                                                  title: "Berhasil me-edit absen!",
                                                  text: absensi['message'],
                                                ),
                                              );
                                            }
                                          }
                                        } else {
                                          if (context.mounted) {
                                            ArtSweetAlert.show(
                                              context: context,
                                              artDialogArgs: ArtDialogArgs(
                                                type: ArtSweetAlertType.danger,
                                                title: "Gagal Absen!",
                                                text: absensi['message'],
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                    child: const SizedBox(
                                      height: 40,
                                      width: double.infinity,
                                      child: Center(
                                        child: Text("Edit Absen",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ]))))
        ]));
  }
}
