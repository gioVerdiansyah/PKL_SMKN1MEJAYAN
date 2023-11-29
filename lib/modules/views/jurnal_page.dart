import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pkl_smkn1mejayan/model/jurnal_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/side_bar_component.dart';

class JurnalPage extends StatefulWidget {
  JurnalPage({super.key});
  static const String routeName = '/jurnal';

  @override
  State<JurnalPage> createState() => _JurnalView();
}

class _JurnalView extends State<JurnalPage> {
  late List<PlatformFile>? buktiController;
  final TextEditingController kegiatanController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(),
      drawer: SideBar(),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Card(
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        child: FormBuilderFilePicker(
                          name: "images",
                          allowMultiple: false,
                          maxFiles: 1,
                          allowedExtensions: const ['png', 'jpg', 'jpeg', 'pdf'],
                          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                          previewImages: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: '',
                          ),
                          onChanged: (value) {
                            buktiController = value;
                          },
                          typeSelectors: const [
                            TypeSelector(
                              type: FileType.custom,
                              selector: Card(
                                color: Colors.white70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Icon(Icons.drive_folder_upload), Text("Upload Bukti")],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'textareaField',
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Kegiatan',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(), FormBuilderValidators.max(2000)],
                        ),
                        controller: kegiatanController,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Card(
                          margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          color: Colors.green,
                          child: InkWell(
                            onTap: () async {
                              if (_formKey.currentState?.saveAndValidate() ?? false) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text('Processing Data'),
                                  backgroundColor: Colors.green.shade300,
                                ));
                                var response = await JurnalModel.sendPost(kegiatanController.text, buktiController!);
                                if (response['jurnal']['success']) {
                                  if (context.mounted) {
                                    ArtSweetAlert.show(
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                        type: ArtSweetAlertType.success,
                                        title: "Berhasil mengisi jurnal!",
                                        text: response['jurnal']['message'],
                                      ),
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    ArtSweetAlert.show(
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                        type: ArtSweetAlertType.danger,
                                        title: "Gagal mengisi jurnal!",
                                        text: response['jurnal']['message'],
                                      ),
                                    );
                                  }
                                }
                                _formKey.currentState?.reset();
                              }
                            },
                            child: SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Isi Jurnal",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(Icons.send, color: Colors.white,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),
          ),
        ],
      )
    );
  }
}
