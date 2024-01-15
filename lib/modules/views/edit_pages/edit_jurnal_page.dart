import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pkl_smkn1mejayan/model/jurnal_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/routes/app_route.dart';

import '../../../routes/api_route.dart';


class EditJurnalPage extends StatefulWidget {
  const EditJurnalPage({super.key, required this.idJurnal});
  static const String routeName = '/jurnal/show';

  final String idJurnal;

  @override
  State<EditJurnalPage> createState() => _EditJurnalView();
}

class _EditJurnalView extends State<EditJurnalPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarComponent(),
        body: FutureBuilder(
          future: JurnalModel.getSpecificData(widget.idJurnal),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }else{
              var dataJurnal = snapshot.data['jurnal']['data'];

              List<PlatformFile>? buktiController;
              TextEditingController kegiatanController = TextEditingController(text: dataJurnal['kegiatan']);

              return ListView(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Column(
                        children: [
                          Card(
                              child: FormBuilder(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Center(
                                        child: Text('Edit Jurnal', style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        )),
                                      ),
                                      Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: Text("Gambar jurnal Sebelumnya", style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17
                                            )),
                                          ),
                                          Image.network("${ApiRoute.storageRoute}/${dataJurnal['bukti']}", width: 200),
                                          SizedBox(
                                            width: double.infinity,
                                            child: FormBuilderFilePicker(
                                              name: "images",
                                              allowMultiple: false,
                                              maxFiles: 1,
                                              allowedExtensions: const ['png', 'jpg', 'jpeg'],
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
                                                  selector: SizedBox(
                                                    width: 200,
                                                    child: Card(
                                                      color: Colors.white70,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [Icon(Icons.drive_folder_upload), Text("Upload Bukti"
                                                              " Baru")],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                                var response = await JurnalModel.editJurnal(widget.idJurnal,kegiatanController
                                                    .text,
                                                    buktiController);
                                                if (response['jurnal']['success']) {
                                                  if (context.mounted) {
                                                    ArtSweetAlert.show(
                                                      context: context,
                                                      artDialogArgs: ArtDialogArgs(
                                                        type: ArtSweetAlertType.success,
                                                        title: "Berhasil mengisi jurnal!",
                                                        text: response['jurnal']['message'],
                                                        onConfirm: (){
                                                          Navigator.pushNamed(context, AppRoute.jurnalRoute);
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
                                                        title: "Gagal mengisi jurnal!",
                                                        text: response['jurnal']['message'],
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
                                                      "Edit Jurnal",
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
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        )
    );
  }
}
