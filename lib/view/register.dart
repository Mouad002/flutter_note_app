import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes_app/crud.dart';
import 'package:notes_app/view/home.dart';
import 'package:notes_app/apilink.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Crud _crud = Crud();
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map userInfos = {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text
    };
    var response = await _crud.postRequest(linkRegister, userInfos);
    if (response != null) {
      dynamic data = jsonDecode(response);
      if (data['status'] == 'success') {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => LoginPage(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('account created successfully')));
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
                                'Register',
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
                                  const InputDecoration(hintText: "username"),
                              controller: usernameController,
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
                                      return LoginPage();
                                    })));
                                  },
                                  color: Colors.red,
                                  child: const Text('already have account',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    register();
                                    // Navigator.of(context).pushReplacement(
                                    //     MaterialPageRoute(builder: ((context) {
                                    //   return LoginPage();
                                    // })));
                                  },
                                  color: Colors.red,
                                  child: const Text('register',
                                      style: TextStyle(color: Colors.white)),
                                )
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
