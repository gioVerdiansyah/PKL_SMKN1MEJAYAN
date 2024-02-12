import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/model/perizinan_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/side_bar_component.dart';
import 'package:pkl_smkn1mejayan/routes/app_route.dart';

class IzinPage extends StatefulWidget {
  const IzinPage({super.key});
  static const String routeName = '/izin';

  @override
  State<IzinPage> createState() => _IzinView();
}

class _IzinView extends State<IzinPage> {
  static final box = GetStorage();
  final _formKey = GlobalKey<FormBuilderState>();

  late String tipeIzinController;
  final TextEditingController alasanController = TextEditingController();
  final TextEditingController awalIzinController = TextEditingController();
  final TextEditingController akhirIzinController = TextEditingController();
  late List<PlatformFile>? buktiController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBar(),
      body: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
              child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                Card(
                    margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    color: Colors.green,
                    child: InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, AppRoute.riwayatIzinRoute);
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history_edu_outlined, color: Colors.white,),
                              Text(
                                "Riwayat Izin",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Column(
                      children: [
                        const Text(
                          "Perizinan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        FormBuilderTextField(
                          initialValue: "${box.read('dataLogin')['user']['name']}",
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
                          initialValue: "--Pilih Tipe Izin--",
                          items: ['--Pilih Tipe Izin--', 'Sakit', 'Izin', 'Dispensasi']
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              tipeIzinController = value.toString();
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: "Tipe Izin",
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(), FormBuilderValidators.notEqual("--Pilih Tipe Izin--")]),
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
                                  inputType: InputType.date,
                                  initialValue: DateTime.now(),
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
                                    (value) {
                                      if (value != null &&
                                          value.isBefore(
                                              DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
                                        return 'Tanggal harus setelah atau sama dengan hari ini';
                                      }
                                      return null;
                                    }
                                  ]),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: FormBuilderDateTimePicker(
                                  name: 'akhir-tanggal-izin',
                                  inputType: InputType.date,
                                  initialValue: DateTime.now(),
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
                        FormBuilderFilePicker(
                          withData: true,
                          name: "images",
                          allowMultiple: false,
                          maxFiles: 1,
                          decoration: const InputDecoration(labelText: "Bukti"),
                          allowedExtensions: const ['png', 'jpg', 'jpeg', 'pdf'],
                          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
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
                                    child: Text("Bukti Izin"),
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
                          var response = await PerizinanModel.sendPost(alasanController.text, awalIzinController.text,
                              akhirIzinController.text, buktiController!, tipeIzinController);
                          if (response['success']) {
                            if (context.mounted) {
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.success,
                                  title: "Berhasil izin!",
                                  text: response['message'],
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.danger,
                                  title: "Gagal izin!",
                                  text: response['message'],
                                ),
                              );
                            }
                          }
                          _formKey.currentState?.reset();
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
                                "Kirim Izin",
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
          ))),
    );
  }
}
