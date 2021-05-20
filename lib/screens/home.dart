import 'package:cyberaware/models/Usuari.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'menu/menu.dart';

class Home extends StatefulWidget {
  Home(this.user);
  Usuari user;

  static const String _title = 'CyberAware';
  @override
  _HomeState createState() => _HomeState();


}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(widget.user),
      appBar: AppBar(
        title: Text(
          'Inici',
          style: TextStyle(
            color: Colors.white,
          ),

        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
    );

  }

}