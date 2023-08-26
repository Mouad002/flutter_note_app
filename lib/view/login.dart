import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes_app/apilink.dart';
import 'package:notes_app/crud.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/view/register.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Crud _crud = Crud();
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void logIn() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map userInfos = {
      'email': emailController.text,
      'password': passwordController.text
    };
    var jsonResponse = await _crud.postRequest(loginLink, userInfos);
    if (jsonResponse != null) {
      dynamic response = jsonDecode(jsonResponse);
      if (response['status'] == 'success') {
        sharedPreferences.setString(
            'user_id', response['data']['id'].toString());
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('fail to login')));
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
        title: const Text('login page'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 50),
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.length < 4) {
                                  return 'can\'t be less than 4 caracters';
                                }
                              },
                              decoration:
                                  const InputDecoration(hintText: "email"),
                              controller: emailController,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.length < 4) {
                                  return 'can\'t be less than 4 caracters';
                                }
                              },
                              decoration:
                                  const InputDecoration(hintText: "password"),
                              controller: passwordController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: ((context) {
                                      return RegisterPage();
                                    })));
                                  },
                                  color: Colors.red,
                                  child: const Text('create account',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    logIn();
                                  },
                                  color: Colors.red,
                                  child: const Text('log in',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
    );
  }
}
