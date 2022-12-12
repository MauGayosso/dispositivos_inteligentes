import 'package:appejercicio/getData.dart';
import 'package:appejercicio/preferences.dart';
import 'package:appejercicio/readData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ReadRegister extends StatefulWidget{
  @override
  _ReadRegisterState createState() => _ReadRegisterState();
}


class _ReadRegisterState extends State<ReadRegister>{

  @override
  void initState(){
    this.getData();
    super.initState();
  }
  int _selectedDestination = 0;
  List<String> data = [];
  bool rd = true;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Registros'),
      ),body:Column(
      children: [Expanded(child: ListView.builder(padding: const EdgeInsets.fromLTRB(30, 20, 50, 50),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            child: ListTile(
              title: Text(data[index],style: TextStyle(fontSize: 20),),
            ),
          );
        },)),
        OutlinedButton(
          onPressed: (){
            readData();
          },

          child: const Text('Actualizar'),
        ),],
    ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(50.0),
              child: Text('Menu'),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety_rounded),
              title: const Text('Ejercicio'),
              selected: _selectedDestination == 0,
              onTap: () => selectDestination(0),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Registros Guardados'),
              selected: _selectedDestination == 1,
              onTap: () => selectDestination(1),
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle),
              title: const Text('Preferencias'),
              selected: _selectedDestination == 2,
              onTap: () => selectDestination(2),
            ),
          ],
        ),
      ),
    );

  }
  Future<void> getData() async {
    try {
      var curl = Uri.parse(
          "https://flutterfirebase-ec7fe-default-rtdb.firebaseio.com/registros.json");
      final response = await http.get(curl);
      final users = json.decode(response.body);
      data.clear();
      final datos = [];
      final date = [];
      for(var i in users.values){
        datos.add(i);
      }
      for(var n in datos) {
        data.add(n.toString());
        date.add(n.toString());
      }

      print(date);
      for(var i in date){
        print(i);
      }




      setState(() {
        rd=false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void readData() {
    getData();
  }
  void selectDestination(int index) {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ReadData()));
    } else if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ReadRegister()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ReadPreferences()));

    }
  }
}