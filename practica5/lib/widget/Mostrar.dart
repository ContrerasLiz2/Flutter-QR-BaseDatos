
import 'package:flutter/material.dart';
import 'package:practica5/widget/BDH.dart';

class Mostrar extends StatefulWidget {
  const Mostrar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Clase();
  }
}

class Clase extends State<Mostrar> {
  List<Map<String, dynamic>> productos = [];

  void cargarDatos() async {
    final valores = await BDH().obtenerProductos();
    setState(() {
      productos = valores;
    });
  }

  void enviarAliminar(String codigo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content: const Text('¿Desea eliminar el producto?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                await BDH().eliminarProducto(codigo);
                Navigator.of(context).pop();
                cargarDatos();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mostrar Datos'),
        backgroundColor: Colors.blue,
      ),
      body: productos.isEmpty
          ? const Center(
              child: Text('No hay productos disponibles'),
            )
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return ListTile(
                  title: Text('Código: ${producto['codigo']}'),
                  subtitle: Text('Nombre: ${producto['nombre']}'),
                  trailing: Wrap(
                    direction: Axis.vertical,
                    spacing: 8,
                    children: [
                      Text('Precio: \$${producto['precio']}'),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          enviarAliminar(producto['codigo']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

