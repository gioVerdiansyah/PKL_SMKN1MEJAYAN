import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/model/edit_profile_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/side_bar_component.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  static const String routeName = '/edit-profile';

  @override
  State<EditProfilePage> createState() => _EditProfileView();
}

class _EditProfileView extends State<EditProfilePage> {
  var box = GetStorage().read('dataLogin')['user'];
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  late final TextEditingController newPhoneController;
  late TextEditingController newPhoneParentController = TextEditingController();
  late TextEditingController newAddressController = TextEditingController();
  late final TextEditingController newEmailController;
  List<PlatformFile>? photoProfileController;

  @override
  void initState() {
    super.initState();
    box = GetStorage().read('dataLogin')['user'];
    newPhoneController = TextEditingController(text: box['no_hp'].toString());
    if (box['no_hp_ortu'] != null) newPhoneParentController = TextEditingController(text: box['no_hp_ortu'].toString());
    if (box['alamat'] != null) newAddressController = TextEditingController(text: box['alamat'].toString());
    newEmailController = TextEditingController(text: box['email'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBar(),
      body: ListView(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          child: Center(
            child: Card(
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Center(
                        child: Text('Photo Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Column(
                        children: [
                          FadeInImage(
                            placeholder: const AssetImage('assets/images/loading.gif'),
                            image: NetworkImage(
                              "${GetStorage().read('dataLogin')['user']['photo_profile']}",
                            ),
                            width: 75,
                            height: 75,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              children: [
                                Text(
                                  box['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  box['nis'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          FormBuilderFilePicker(
                            withData: true,
                            name: "images",
                            allowMultiple: false,
                            maxFiles: 1,
                            decoration: const InputDecoration(labelText: "Photo"),
                            allowedExtensions: const ['png', 'jpg', 'jpeg', 'pdf'],
                            previewImages: true,
                            onChanged: (value) {
                              photoProfileController = value;
                            },
                            typeSelectors: const [
                              TypeSelector(
                                type: FileType.custom,
                                selector: Row(
                                  children: <Widget>[
                                    Icon(Icons.file_upload_outlined),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text("Photo Baru"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(labelText: 'Email Anda'),
                        controller: newEmailController,
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required(), FormBuilderValidators.email()]),
                      ),
                      FormBuilderTextField(
                        name: 'no_hp',
                        decoration: const InputDecoration(labelText: 'Nomor HP (62xxx)'),
                        controller: newPhoneController,
                        validator: (value) {
                          if (!RegExp(r'^62\d+$').hasMatch(value!)) {
                            return "Invalid input. Must start with 62.";
                          }
                        },
                      ),
                      FormBuilderTextField(
                        name: 'no_hp_ortu',
                        decoration: const InputDecoration(labelText: 'Nomor HP Ortu (62xxx)', floatingLabelBehavior: FloatingLabelBehavior.always),
                        controller: newPhoneParentController,
                        validator: (value) {
                          if (value!.isNotEmpty && !RegExp(r'^62\d+$').hasMatch(value!)) {
                            return "Invalid input. Must start with 62.";
                          }
                        },
                      ),
                      FormBuilderTextField(
                        name: 'alamat',
                        decoration: const InputDecoration(labelText: 'Alamat', floatingLabelBehavior: FloatingLabelBehavior.always),
                        controller: newAddressController,
                        maxLines: 3,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text('Ubah Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'oldPass',
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password Lama'),
                        controller: oldPassController,
                      ),
                      FormBuilderTextField(
                        name: 'newPass',
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password Baru'),
                        controller: newPassController,
                      ),
                      FormBuilderTextField(
                        name: 'confirmPass',
                        obscureText: true,
                        controller: confirmPassController,
                        decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
                      ),
                      Card(
                        margin: const EdgeInsets.only(top: 20),
                        color: Colors.green,
                        child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState?.saveAndValidate() ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text('Processing Data'),
                                backgroundColor: Colors.green.shade300,
                              ));
                              var response = await EditProfileModel.sendPost(
                                  oldPassController.text,
                                  confirmPassController.text,
                                  newPassController.text,
                                  photoProfileController,
                                  newPhoneController.text,
                                  newPhoneParentController.text,
                                  newEmailController.text,
                                  newAddressController.text);
                              if (response['success']) {
                                if (context.mounted) {
                                  ArtSweetAlert.show(
                                    context: context,
                                    artDialogArgs: ArtDialogArgs(
                                      type: ArtSweetAlertType.success,
                                      title: "Berhasil mengubah profile!",
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
                                      title: "Gagal mengubah profile!",
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
                                    "Update Profile",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
