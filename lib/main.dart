import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de alumnos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _alumnos = [];

@override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the page initializes
  }
  
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/students'));
    if (response.statusCode == 200) {
      setState(() {
        _alumnos = json.decode(response.body); 
        print(_alumnos);
      });
    } else {
      throw Exception('Falla al cargar los datos');
    }
  }
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _edadController = TextEditingController();
  TextEditingController _grupoController = TextEditingController();
  TextEditingController _promedioGeneralController = TextEditingController();

  void addAlumno(String nombre, int edad, String grupo, double promedioGeneral) async {

    // Send HTTP POST request to the API
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/students'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': nombre,
        'edad': edad,
        'grupo': grupo,
        'promedioGeneral': promedioGeneral,
      }),
    );

    if (response.statusCode == 200) {
      // If successful, add item to the local list
      setState(() {
        _alumnos.add(<String, dynamic>{'nombre': nombre, 'edad': edad, 'grupo':grupo });
      });
    } else {
      // Handle error appropriately
      print('Failed to add item. Error: ${response.statusCode}');
    }
  }
  void updateItem(int id, String nombre, int edad, String grupo, double promedioGeneral, int index) async {

    // Send HTTP POST request to the API
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8080/api/students/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': nombre,
        'edad': edad,
        'grupo': grupo,
        'promedioGeneral': promedioGeneral,
      }),
    );

    if (response.statusCode == 200) {
      // If successful, add item to the local list
      setState(() {
        _alumnos.add(<String, dynamic>{'nombre': nombre, 'edad': edad, 'grupo':grupo, 'promedioGeneral': promedioGeneral });
        _alumnos.removeAt(index);
      });
    } else {
      // Handle error appropriately
      print('Failed to add item. Error: ${response.statusCode}');
    }
  }

  // void deleteItem(int index) {
  //   setState(() {
  //     alumnos.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de alumnos'),
        backgroundColor: Colors.blue,
      ),
      body: _alumnos.isEmpty
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator if data is being fetched
            )
          : ListView.builder(
              itemCount: _alumnos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_alumnos[index]['nombre']),
                  subtitle: Text('Grupo: ${_alumnos[index]["grupo"]} Edad: ${_alumnos[index]["edad"]} Promedio General: ${_alumnos[index]["promedioGeneral"]}'),
                  trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _nombreController.text = _alumnos[index]['nombre'];
                    _edadController.text = _alumnos[index]['edad'].toString();
                    _grupoController.text = _alumnos[index]['grupo'];
                    _promedioGeneralController.text = _alumnos[index]['promedioGeneral'].toString();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Editar alumno'),
                          content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _nombreController,
                              decoration: InputDecoration(labelText: 'Nombre'),
                            ),
                            TextField(
                              controller: _edadController,
                              decoration: InputDecoration(labelText: 'Edad'),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              controller: _grupoController,
                              decoration: InputDecoration(labelText: 'Grupo'),
                            ),
                            TextField(
                              controller: _promedioGeneralController,
                              decoration: InputDecoration(labelText: 'Promedio general'),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                updateItem(_alumnos[index]['id'], 
                                _nombreController.text, 
                                int.parse(_edadController.text),
                                _grupoController.text,
                                double.parse(_promedioGeneralController.text), 
                                index);
                              _nombreController.clear();
                              _edadController.clear();
                              _grupoController.clear();
                              _promedioGeneralController.clear();
                              Navigator.pop(context);
                              },
                              child: Text('Guardar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirmar eliminación'),
                          content: Text('¿Estás seguro de eliminar este alumno?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // deleteItem(index);
                                Navigator.pop(context);
                              },
                              child: Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Agregar nuevo alumno'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: _edadController,
                      decoration: InputDecoration(labelText: 'Edad'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _grupoController,
                      decoration: InputDecoration(labelText: 'Grupo'),
                    ),
                    TextField(
                      controller: _promedioGeneralController,
                      decoration: InputDecoration(labelText: 'Promedio general'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      addAlumno(_nombreController.text, 
                                int.parse(_edadController.text),
                                _grupoController.text,
                                double.parse(_promedioGeneralController.text));
                      _nombreController.clear();
                      _edadController.clear();
                      _grupoController.clear();
                      _promedioGeneralController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Añadir'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}