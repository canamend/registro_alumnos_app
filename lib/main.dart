import 'package:flutter/material.dart';

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
  List<String> alumnos = ['Alumno 1', 'Alumno 2', 'Alumno 3']; // dummy data

  TextEditingController _controller = TextEditingController();

  void addItem(String nuevoAlumno) {
    setState(() {
      alumnos.add(nuevoAlumno);
    });
  }

  void updateItem(int index, String updatedItem) {
    setState(() {
      alumnos[index] = updatedItem;
    });
  }

  void deleteItem(int index) {
    setState(() {
      alumnos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de alumnos'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: alumnos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(alumnos[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _controller.text = alumnos[index];
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
                                updateItem(index, _controller.text);
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
                                deleteItem(index);
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
                      addItem(_controller.text);
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