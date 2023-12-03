import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pkl_smkn1mejayan/model/ubah_pass_model.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/side_bar_component.dart';

class UbahPassPage extends StatefulWidget {
  const UbahPassPage({super.key});
  static const String routeName = '/ubah-pass';

  @override
  State<UbahPassPage> createState() => _UbahPassView();
}

class _UbahPassView extends State<UbahPassPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBar(),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Card(
            child: FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Column(
                  children: [
                    const Center(
                      child: Text('Ubah Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    FormBuilderTextField(
                        name: 'oldPass',
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password Lama'),
                        controller: oldPassController,
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required()])),
                    FormBuilderTextField(
                      name: 'newPass',
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password Baru'),
                      controller: newPassController,
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(), FormBuilderValidators.minLength(8)]),
                    ),
                    FormBuilderTextField(
                        name: 'confirmPass',
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8),
                          (val) {
                            if (val != _formKey.currentState!.fields['newPass']?.value) {
                              return 'Konfirmasi password tidak sesuai dengan password baru';
                            }
                            return null;
                          },
                        ])),
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
                            var response = await UbahPassModel.sendPost(oldPassController.text, newPassController.text);
                            print(response);
                            if (response['ubahPass']['success']) {
                              if (context.mounted) {
                                ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                    type: ArtSweetAlertType.success,
                                    title: "Berhasil mengubah password!",
                                    text: response['ubahPass']['message'],
                                  ),
                                );
                              }
                            } else {
                              if (context.mounted) {
                                ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                    type: ArtSweetAlertType.danger,
                                    title: "Gagal mengubah password!",
                                    text: response['ubahPass']['message'],
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
                                  "Ubah Password",
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
    );
  }
}
