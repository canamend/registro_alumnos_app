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
  TextEditingController _controller = TextEditingController();

  // void addItem(String nuevoAlumno) {
  //   setState(() {
  //     alumnos.add(nuevoAlumno);
  //   });
  // }

  // void updateItem(int index, String updatedItem) {
  //   setState(() {
  //     alumnos[index] = updatedItem;
  //   });
  // }

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
                  subtitle: Text(_alumnos[index]['grupo']),
                  trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _controller.text = _alumnos[index];
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Editar alumno'),
                          content: TextField(
                            controller: _controller,
                            autofocus: true,
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
                                // updateItem(index, _controller.text);
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
                content: TextField(
                  controller: _controller,
                  autofocus: true,
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
                      // addItem(_controller.text);
                      _controller.clear();
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