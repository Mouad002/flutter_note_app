import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/apilink.dart';
import 'package:notes_app/crud.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/view/addnote.dart';
import 'package:notes_app/view/login.dart';

import '../controller/homecontroller.dart';
import '../sqldb.dart';
import 'note.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Crud _crud = Crud();
  bool isLoading = false;
  int i = 0;
  List<Map> items = [];
  SqlDb sqldb = SqlDb();

  Future<List<Map>> getNotes() async {
    List<Map> response = await sqldb.readData("select * from notes");
    return response;
  }

  Future<List> getAllNotes() async {
    String? id = sharedPreferences.getString('user_id');
    Map userInfos = {'id': id};
    var jsonResponse = await _crud.postRequest(viewNotesLink, userInfos);
    if (jsonResponse != null) {
      dynamic response = jsonDecode(jsonResponse);
      if (response['status'] == 'success') {
        return response['data'];
      } else {
        print('++++++++++++++++++++ fail ++++++++++++++++++++');
        return [];
      }
    } else {
      print('response is null');
      return [];
    }
  }

  void deleteNote(int id,String image) async {
    setState(() {
      isLoading = true;
    });
    Map noteInfos = {
      'id': id.toString(),
      'note_image': image,
    };
    var response = await _crud.postRequest(deleteNoteLink, noteInfos);
    if (response != null) {
      dynamic data = jsonDecode(response);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('note deleted successfully')));
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
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () {
                  sharedPreferences.clear();
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const AddNotePage(),
                ),
              );
            }),
        body: FutureBuilder(
          future: getAllNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            deleteNote(snapshot.data![index]['id'],snapshot.data![index]['image']);
                            print(snapshot.data![index]['id']);
                          },
                          child: Card(
                              // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 50,
                                    width: 50,
                                    color: Colors.amber,
                                    child: Image.network(
                                      '$serverName/upload/${snapshot.data![index]['image']}',
                                      fit: BoxFit.cover,
                                    )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text(
                                      '${snapshot.data![index]['title']}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        width: 200,
                                        child: Text(
                                          '${snapshot.data![index]['text']}',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          )),
                        );
                      },
                    );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

// FutureBuilder(
//           future: getNotes(),
//           builder: ((context, snapshot) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                 // physics: NeverScrollableScrollPhysics(),
//                 // shrinkWrap: true,
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                       child: ListTile(
//                     onLongPress: () async {
//                       int response = await sqldb.deleteData('''
//                     delete from notes where id = ${snapshot.data![index]['id']};
//                   ''');
//                       print('some item has been deleted');
//                       controller.newState();
//                     },
//                     title: Container(
//                         padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
//                         child: Text('${snapshot.data![index]['title']}')),
//                     subtitle: Container(
//                         padding: EdgeInsets.all(10),
//                         child: Text('${snapshot.data![index]['note']}')),
//                   ));
//                 },
//               );
//             }
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }),
//         ),
