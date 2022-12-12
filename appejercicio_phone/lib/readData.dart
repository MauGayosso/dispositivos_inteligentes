import 'package:appejercicio/getData.dart';
import 'package:appejercicio/preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

Future<void> saveData() async {
  try{
    var curl = Uri.parse(
        "https://flutterfirebase-ec7fe-default-rtdb.firebaseio.com/ejercicios.json");
    final response = await http.get(curl);
    final users = json.decode(response.body);
    var calorias = users['Calorias'].toString();
    var distancia = users['Distancia'].toString();
    var pasos = users['Pasos'].toString();
    var bpm = users['bpm'].toString();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final formatted = formatter.format(now);

    var curl2 = Uri.parse(
        "https://flutterfirebase-ec7fe-default-rtdb.firebaseio.com/registros.json");
    var datos = {'Calorias':calorias,'Distancia':distancia,'Pasos':pasos,'bpm':bpm,'fecha':formatted};
    await http.post(curl2,body:json.encode(datos));

  }
  catch(e){
    print(e.toString());
  }
}
class ReadData extends StatefulWidget{
  @override
  _ReadDataState createState() => _ReadDataState();
}


class _ReadDataState extends State<ReadData>{

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
      appBar: AppBar(title: const Text('Ejercicios'),
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
          OutlinedButton(onPressed: (){saveData();}, child: const Text('Guardar Registro')),
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
          "https://flutterfirebase-ec7fe-default-rtdb.firebaseio.com/ejercicios.json");
      final response = await http.get(curl);
      final users = json.decode(response.body);

      data.clear();
      var calorias = users['Calorias'].toString();
      var distancia = users['Distancia'].toString();
      var pasos = users['Pasos'].toString();
      var bpm = users['bpm'].toString();

      data.add('Calorias quemadas : $calorias');
      data.add('Distancia recorrida : $distancia'+'m');
      data.add('Pasos totales : $pasos');
      data.add('Ritmo cardiaco : $bpm');


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