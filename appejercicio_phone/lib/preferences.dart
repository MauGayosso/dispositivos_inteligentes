import 'package:appejercicio/getData.dart';
import 'package:appejercicio/readData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class ReadPreferences extends StatefulWidget{
  @override
  _ReadPreferencesState createState() => _ReadPreferencesState();
}


class _ReadPreferencesState extends State<ReadPreferences>{

  @override
  void initState(){
    this.readData();
    super.initState();
  }
  int _selectedDestination = 0;
  List<String> data = [];
  bool rd = true;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Datos de Usuario'),
      ),body:Column(
      children: [Expanded(child: ListView.builder(padding: const EdgeInsets.fromLTRB(30, 20, 50, 50),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            child: Text(data[index], style: const TextStyle(fontSize: 30),),
          );
        },)),
        Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            OutlinedButton(
              onPressed: (){
                readData();
              },

              child: const Text('Actualizar'),
            )
          ]
          ,
        )
      ],
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
          ],
        ),
      ),
    );
  }
  Future<void> getData() async {
    try {
      var curl = Uri.parse(
          "https://flutterfirebase-ec7fe-default-rtdb.firebaseio.com/preferencias.json");
      final response = await http.get(curl);
      final users = json.decode(response.body);

      data.clear();
      print(users);
      for (var i in users){
        data.add('Altura: '+ i["altura"] + 'cm');
        data.add('Peso: ' + i["peso"] + 'kg');
        data.add('Edad: ' + i["edad"]);
        data.add('Sexo: '+i["sexo"]);
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
    }
  }
}