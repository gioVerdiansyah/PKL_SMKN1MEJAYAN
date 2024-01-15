import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:pkl_smkn1mejayan/model/perizinan_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/routes/api_route.dart';
import 'package:pkl_smkn1mejayan/routes/app_route.dart';

class EditIzinPage extends StatefulWidget {
  const EditIzinPage({super.key, required this.idIzin});
  static const String routeName = '/izin/edit';
  final String idIzin;

  @override
  State<EditIzinPage> createState() => _IzinView();
}

class _IzinView extends State<EditIzinPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      body: FutureBuilder(
        future: PerizinanModel.getSpecificData(widget.idIzin),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return Center(child: Text("Error: ${snapshot.error}"),);
          }else{
            var dataIzin = snapshot.data['izin']['data'];

            String tipeIzinController = dataIzin['tipe_izin'];
            TextEditingController alasanController = TextEditingController(text: dataIzin['alasan']);
            TextEditingController awalIzinController = TextEditingController(text: dataIzin['awal_izin']);
            TextEditingController akhirIzinController = TextEditingController(text: dataIzin['akhir_izin']);
            List<PlatformFile>? buktiController;

            return Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              child: Column(
                                children: [
                                  const Text(
                                    "Edit izin",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  FormBuilderTextField(
                                    initialValue: dataIzin['user']['name'],
                                    name: 'fullName',
                                    readOnly: true,
                                    style: const TextStyle(color: Colors.grey),
                                    decoration: const InputDecoration(
                                      labelText: "Nama Lengkap",
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                    ),
                                    autofocus: true,
                                  ),
                                  FormBuilderDropdown(
                                      name: 'tipeizin',
                                      initialValue: tipeIzinController,
                                      items: ['Sakit', 'Izin', 'Dispensasi']
                                          .map((option) => DropdownMenuItem(
                                        value: option,
                                        child: Text(option),
                                      ))
                                          .toList(),
                                      onChanged: (value) {
                                        tipeIzinController = value.toString();
                                      },
                                      decoration: const InputDecoration(
                                        labelText: "Tipe Izin",
                                      )
                                  ),
                                  FormBuilderTextField(
                                    name: 'textareaField',
                                    maxLines: 5,
                                    decoration: const InputDecoration(
                                        labelText: 'Alasan izin', floatingLabelBehavior: FloatingLabelBehavior.always),
                                    validator: FormBuilderValidators.compose(
                                        [FormBuilderValidators.required(), FormBuilderValidators.max(1000)]),
                                    controller: alasanController,
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
                                            initialValue: DateTime.parse(dataIzin['awal_izin']),
                                            inputType: InputType.date,
                                            format: DateFormat('dd MMMM y', 'id_ID'),
                                            controller: awalIzinController,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                            decoration: const InputDecoration(
                                              labelText: "Mulai tanggal Izin",
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                            ),
                                            validator: FormBuilderValidators.compose([
                                              FormBuilderValidators.required(),
                                            ]),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: FormBuilderDateTimePicker(
                                            name: 'akhir-tanggal-izin',
                                            initialValue: DateTime.parse(dataIzin['akhir_izin']),
                                            inputType: InputType.date,
                                            format: DateFormat('dd MMMM y', 'id_ID'),
                                            controller: akhirIzinController,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                            decoration: const InputDecoration(
                                              labelText: "Akhir tanggal Izin",
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                            ),
                                            validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text("Gambar bukti Sebelumnya", style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17
                                          )),
                                        ),
                                        Image.network("${ApiRoute.storageRoute}/${dataIzin['bukti']}", width: 300),
                                      ],
                                    ),
                                  ),
                                  FormBuilderFilePicker(
                                    name: "images",
                                    allowMultiple: false,
                                    maxFiles: 1,
                                    decoration: const InputDecoration(labelText: "Bukti"),
                                    allowedExtensions: const ['png', 'jpg', 'jpeg', 'pdf'],
                                    previewImages: true,
                                    onChanged: (value) {
                                      buktiController = value;
                                    },
                                    typeSelectors: const [
                                      TypeSelector(
                                        type: FileType.custom,
                                        selector: Row(
                                          children: <Widget>[
                                            Icon(Icons.file_upload_outlined),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8.0),
                                              child: Text("Update bukti Izin"),
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
                          Card(
                              margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                              color: Colors.green,
                              child: InkWell(
                                onTap: () async {
                                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: const Text('Processing Data'),
                                      backgroundColor: Colors.green.shade300,
                                    ));
                                    var response = await PerizinanModel.sendEditAbsen(widget.idIzin,alasanController.text,
                                        awalIzinController
                                        .text,
                                        akhirIzinController.text, buktiController, tipeIzinController);
                                    if (response['izin']['success']) {
                                      if (context.mounted) {
                                        ArtSweetAlert.show(
                                          context: context,
                                          artDialogArgs: ArtDialogArgs(
                                            type: ArtSweetAlertType.success,
                                            title: "Berhasil me-edit izin!",
                                            text: response['izin']['message'],
                                            onConfirm: (){
                                              Navigator.pushNamed(context, AppRoute.izinRoute);
                                            }
                                          ),
                                          barrierDismissible: false
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ArtSweetAlert.show(
                                          context: context,
                                          artDialogArgs: ArtDialogArgs(
                                            type: ArtSweetAlertType.danger,
                                            title: "Gagal me-edit izin!",
                                            text: response['izin']['message'],
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Update Izin",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Icon(Icons.send, color: Colors.white,)
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )));
          }
        },
      )
    );
  }
}