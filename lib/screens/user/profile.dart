import 'dart:convert';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

}