import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

class Crud {
  getRequest(String url, Map data) async {
    try {
      await Future.delayed(const Duration(seconds: 1), () {});
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = response.body;
        return responsebody;
      } else {
        print('Error ${response.statusCode}');
      }
    } catch (e) {
      print('Error catch $e');
    }
  }

  postRequest(String url, Map data) async {
    try {
      await Future.delayed(const Duration(seconds: 1), () {});
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsebody = response.body;
        return responsebody;
      } else {
        print('Error ${response.statusCode}');
      }
    } catch (e) {
      print('Error catch $e');
    }
  }

  postRequestWithFile(String url, Map data, File? file) async {
    var request = http.MultipartRequest("post", Uri.parse(url));
    var lenght = await file!.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile("note_image", stream, lenght,
        filename: basename(file.path));
    request.files.add(multipartFile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200) {
      return response.body;
    } else {
      print("error ${myRequest.statusCode}");
    }
  }
}
