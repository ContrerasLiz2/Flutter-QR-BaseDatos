import 'package:flutter/material.dart';
import 'package:practica5/widget/BDH.dart';
import 'package:practica5/widget/Mostrar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QR extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Clase();
  }
}

class Clase extends State<QR> {
  bool _ventanaMostrada = false;

  void mostrarDatosQR(String numeros) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController precioController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Datos QR'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Código: $numeros',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                String nombre = nombreController.text;
                String precio = precioController.text;

                if (nombre.isNotEmpty && precio.isNotEmpty) {
                  await BDH().insertarProductos(numeros, nombre, double.parse(precio));
                  Navigator.pop(context);
                  setState(() {
                    _ventanaMostrada = false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, completa todos los campos')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aplicación QR Base de Datos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Mostrar()),
              );
            },
          ),
        ],
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_ventanaMostrada) return;

          final codigo = capture.barcodes.first;
          final String numeros = codigo.rawValue ?? 'Sin Código';
          print('Código detectado: $numeros');

          setState(() {
            _ventanaMostrada = true;
          });

          mostrarDatosQR(numeros);
        },
      ),
    );
  }
}
