
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; 
import 'package:path/path.dart';

class BDH {
  static final BDH _instance = BDH._internal();
  
  factory BDH() => _instance;   
  
  BDH._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async { 
    return await openDatabase(
      join(await getDatabasesPath(), 'Abarrotes.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE productos(
            codigo TEXT PRIMARY KEY,
            nombre TEXT NOT NULL,
            precio REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertarProductos(String codigo, String nombre, double precio) async {
    final db = await database;
    return await db!.insert(
      'productos',
      {
        'codigo': codigo,
        'nombre': nombre,
        'precio': precio,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // evita errores por claves duplicadas
    );
  }

  Future<List<Map<String, dynamic>>> obtenerProductos() async {
    final db = await database;
    return await db!.query('productos');
  } 

  Future<int> eliminarProducto(String codigo) async {
    final db = await database;
    return await db!.delete(
      'productos',
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }
}
