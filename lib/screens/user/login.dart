import 'dart:convert';
import 'dart:io';

import 'package:cyberaware/models/Usuari.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cyberaware/screens/user/sign-up.dart';

import 'package:cyberaware/screens/home.dart';

import 'package:cyberaware/global/global.dart' as Global;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LogIn extends StatelessWidget {
  static const String _title = 'CyberAware';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScopeNode actualFocus = FocusScope.of(context);

        if(!actualFocus.hasPrimaryFocus){
          actualFocus.unfocus();
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text('CyberAware'),
          centerTitle: true,
        ),
        body: Stack(
            children: <Widget>[
              Center(
                child: MyStatefulWidget(),
              )
            ]
        ),),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  String title = 'CyberAware';

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>{
  final _formKey = GlobalKey<FormState>();
  var _responseCode, _token;
  final controllerEmail = new TextEditingController();
  final controllerPasswd = new TextEditingController();

  Usuari user = new Usuari();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15.0),
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: TextFormField(
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: controllerEmail,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'No s\'ha escrit cap email.';
                  }
                  RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                  if(!regex.hasMatch(value)){
                    return 'Format d\'email invalid.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextFormField(
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  labelText: 'Contrasenya',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                controller: controllerPasswd,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'No s\'ha escrit cap contrasenya.';
                  }
                  return null;
                },
                obscureText: true,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top:30.0, bottom: 20.0, left: 90.0, right: 90.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      login(controllerEmail.text, controllerPasswd.text).whenComplete(
                          () {
                            if(_responseCode != 201){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Credencials invàlides.'),
                              ));
                            }
                            else{
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home(user))
                              );
                            }
                          }
                      );
                    }

                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.only(top:70.0, bottom: 5.0, left: 40.0, right: 40.0),
                child:Text(
                    'Encara no t\'has registrat? Crea el teu compte.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
            ),
            Padding(
                padding: const EdgeInsets.only(top:5.0, bottom: 20.0, left: 90.0, right: 90.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp())
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                  ),
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
            ),
          ]
        )
    );
  }

  Future<void> login(String email, String password) async{
    print('entro al login');
    http.Response response = await http.post(new Uri.http("10.0.2.2:8000", "/api/login/"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password}));
    _responseCode = response.statusCode;
    var data = jsonDecode(response.body);
    user = Usuari.fromJson(data['user']);
    user.token = data['acces_token'];
    print(user.email);
  }

}