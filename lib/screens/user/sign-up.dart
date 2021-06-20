import 'dart:convert';

import 'package:cyberaware/models/Empresa.dart';
import 'package:cyberaware/models/Usuari.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../home.dart';
import 'login.dart';

class SignUp extends StatelessWidget {
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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn())
              );
            },
          ),
          title: Text('Sign Up'),
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
  List<String> responseError = [];
  final _controllerEmail = new TextEditingController();
  final _controllerPasswd = new TextEditingController();
  final _controllerPasswdConfirm = new TextEditingController();
  final _controllerNombre = TextEditingController();
  final _controllerUsername = TextEditingController();
  var _controllerEmpresa = TextEditingController();

  EmpresaList _list_empreses = new EmpresaList();
  var _empreses = ['AMB'];

  Usuari user = new Usuari();

  @override
  void initState() {
    List<String> responseError = [];
    getEmpreses();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15.0),
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
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
                  controller: _controllerEmail,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'No s\'ha escrit cap email.';
                    }
                    RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                    if(!regex.hasMatch(value)){
                      return 'Format d\'email invalid.';
                    }
                    if(responseError.contains('email')){
                      return 'Aquest email ja pertany a un altre usuari.';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
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
                  controller: _controllerPasswd,
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
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                child: TextFormField(
                  style: TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: 'Confirma Contrasenya',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  controller: _controllerPasswdConfirm,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'No s\'ha escrit la confirmació de contrasenya.';
                    }
                    if(value != _controllerPasswd.text){
                      return 'Les contrasenyes no coincideixen';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                child: TextFormField(
                  style: TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  controller: _controllerUsername,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'No s\'ha escrit cap username.';
                    }
                    if(responseError.contains('username')){
                      return 'Aquest username ja pertany a un altre usuari.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                child: TextFormField(
                  style: TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nom i cognoms',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  controller: _controllerNombre,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'No s\'ha escrit cap nom.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                child: DropdownButtonFormField(
                  style: TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: 'Empresa',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  items: _empreses.map((String a){
                    return DropdownMenuItem(
                    value: a,
                    child: Text(a)
                    );
                  }).toList(),
                  onChanged: (value){
                    setState(() {
                      _controllerEmpresa.text = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'No s\'ha seleccionat cap empresa.' : null,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top:30.0, bottom: 20.0, left: 90.0, right: 90.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        signUp().whenComplete(() {
                          if(_responseCode != 201){
                            return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Sing Up incorrecte.')));
                          }
                          else{
                            login(_controllerEmail.text, _controllerPasswd.text).whenComplete(() {
                              if(_responseCode == 201){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home(user))
                                );
                              }
                            });

                          }
                        });
                      }

                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                    ),
                    child: Text('Sign Up', style: TextStyle(color: Colors.white),),
                  )
              )
            ]
        )
    );
  }

  Future<void> getEmpreses() async{
    final response = await http.get(new Uri.http('cyberaware.pythonanywhere.com', "/api/authentication/empreses/"));
    var data = jsonDecode(response.body);
    _list_empreses = EmpresaList.fromJson(data['results']);
    setState(() {
      _empreses = _list_empreses.getNoms();
    });
  }

  Future<void> signUp() async{
    http.Response response = await http.post(new Uri.http("cyberaware.pythonanywhere.com", "/api/authentication/signup/"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'username': _controllerUsername.text,
          'password': _controllerPasswd.text,
          'password_confirmation': _controllerPasswdConfirm.text,
          'email': _controllerEmail.text,
          'name': _controllerNombre.text,
          'empresa': _controllerEmpresa.text,
        }));
    _responseCode = response.statusCode;
    print(_responseCode);
    if (_responseCode != 201){
      Map<String, dynamic> data = jsonDecode(response.body);
      responseError=[];
      for (var name in data.keys){
        responseError.add(name);
      }
    }
  }

  Future<void> login(String email, String password) async{
    http.Response response = await http.post(new Uri.http("cyberaware.pythonanywhere.com", "/api/authentication/login/"),
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
  }
}