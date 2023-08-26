import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/apilink.dart';
import 'package:notes_app/crud.dart';
import 'package:notes_app/sqldb.dart';

import '../main.dart';
import 'home.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final Crud _crud = Crud();
  bool isLoading = false;
  SqlDb db = SqlDb();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  File? theImage;
  bool insertImage = false;

  void addNote() async {
    if (insertImage == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('insert the image first'),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    String? id = sharedPreferences.getString('user_id');
    Map noteInfos = {
      'title': titleController.text,
      'text': textController.text,
      'owner': id,
    };
    var response =
        await _crud.postRequestWithFile(AddNoteLink, noteInfos, theImage);
    if (response != null) {
      dynamic data = jsonDecode(response);
      if (data['status'] == 'success') {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => HomePage(),
          ),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('note added successfully')));
      } else {
        print('++++++++++++++++++++ fail ++++++++++++++++++++');
      }
    } else {
      print('response is null');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add new note')),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.length < 4) {
                        return 'can\'t be less than 4 caracters';
                      }
                    },
                    decoration: const InputDecoration(hintText: "title"),
                    controller: titleController,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.length < 4) {
                        return 'can\'t be less than 4 caracters';
                      }
                    },
                    decoration: InputDecoration(hintText: "note"),
                    controller: textController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        pickImage(context);
                      },
                      child: Container(
                          height: 200,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: (insertImage == false)
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 130,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 40, 0, 10),
                                          child: Text(
                                            'empty',
                                          ),
                                        ),
                                        Text(
                                          'click here to upload the image',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      ],
                                    )
                                  : Image.file(
                                      theImage!,
                                      fit: BoxFit.cover,
                                    )))),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              addNote();
                            },
                            color: Colors.red,
                            child: const Text('add',
                                style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pushReplacement<void, void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            },
                            color: Colors.red,
                            child: const Text('cancel',
                                style: TextStyle(color: Colors.white)),
                          )
                        ]),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void pickImage(BuildContext context) async {
    // PermissionStatus galleryStatus = await Permission.storage.request();
    // if (await Permission.storage.isDenied) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('allow storage permission for image upload'),
    //     duration: Duration(seconds: 2),
    //   ));
    // }
    // if (galleryStatus.isGranted) {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final image = File(pickedImage.path);
    insertImage = true;
    theImage = image;
    setState(() {});
    // }
  }
}
