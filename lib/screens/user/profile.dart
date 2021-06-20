import 'dart:convert';
import 'dart:io';

import 'package:cyberaware/models/Usuari.dart';
import 'package:cyberaware/screens/menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget{
  Profile(this.user);
  Usuari user;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{

  final _formKey = GlobalKey<FormState>();

  final _controllerText = TextEditingController();
  var _token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Menu(widget.user),
      appBar: AppBar(
        title: Text(
          'Perfil d\'usuari',
          style: TextStyle(
            color: Colors.white,
          ),

        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: (){
                showDialog(context: context, builder: (context){
                  _controllerText.text = "";
                  return AlertDialog(
                      title: Text('Escriu els camps que vols editar.',
                        style: TextStyle(fontSize: 24),),
                      content: Form(
                        key: _formKey,
                        child: Container(
                          height: 170,
                          child: Column(
                            children: [
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Nom i cognoms',
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                controller: _controllerText,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'No s\'ha escrit cap informacio.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                height: 50,
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: (){
                                    if(_formKey.currentState.validate()){
                                      update(_controllerText.text).whenComplete(() => Navigator.pop(context));
                                    }
                                  },
                                  child: Text(
                                    'Actualitzar',
                                    style: TextStyle(fontSize: 18),),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  );
                });
              },
              icon: Icon(Icons.edit)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none ,
            alignment: Alignment.center,
            children: <Widget>[
              Image(
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.cover,
                image: NetworkImage('https://cdn.pixabay.com/photo/2018/01/17/20/22/analytics-3088958_1280.jpg'),),
              Positioned(
                bottom: -70,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),)
              ),
            ],
          ),
          SizedBox(height: 90.0,),
          ListTile(
              title: Center(child: Text(
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 20,
                  )
                ),
              ),
            subtitle: Center(
              child: Text(
                widget.user.empresa,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey
                ),
              )
            ),
          ),
          ListTile(
            title: Center(child: Text(
                widget.user.email,
                style: TextStyle(
                  fontSize: 16,
                )
            ),
            ),
          )
        ]
      ),
    );
  }

  Future<void> update(String name) async{
    http.Response response = await http.patch(new Uri.http("cyberaware.pythonanywhere.com", "/api/authentication/update_profile/"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + widget.user.token.toString(),
        },
        body: jsonEncode(<String, String>{
          'name': name,
        }));
    var data = jsonDecode(response.body);
    print(data);
    setState(() {
      _token = widget.user.token;
      widget.user = Usuari.fromJson(data['user']);
      widget.user.token = _token;
    });

  }

}