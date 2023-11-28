import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/app_bar_component.dart';
import 'package:pkl_smkn1mejayan/modules/views/components/side_bar_component.dart';

class JurnalPage extends StatefulWidget {
  JurnalPage({super.key});
  static const String routeName = '/jurnal';

  @override
  State<JurnalPage> createState() => _JurnalView();
}

class _JurnalView extends State<JurnalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(),
      drawer: SideBar(),
      body: Container(
        child: Card(
          margin: EdgeInsets.all(20),
            child: FormBuilder(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                FormBuilderFilePicker(
                  name: "images",
                  allowMultiple: true,
                  maxFiles: 5,
                  allowedExtensions: const ['png', 'jpg', 'jpeg', 'pdf'],
                  validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  previewImages: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: '',
                  ),
                  onChanged: (value) {
                    // buktiController = value;
                  },
                  typeSelectors: [
                    TypeSelector(
                      type: FileType.custom,
                      selector: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: const Card(
                          color: Colors.white70,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [Icon(Icons.drive_folder_upload), Text("Upload Bukti")],
                         ),
                        )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
