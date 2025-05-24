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
      join(await getDatabasesPath(), 'Datospersonales.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE datospersonales(
            codigo TEXT PRIMARY KEY,
            nombre TEXT NOT NULL,
            precio REAL NOT NULL,
            correo TEXT NOT NULL,
            edad INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertarDatosPersonales(String codigo, String nombre, double precio, String correo, int edad) async {
    final db = await database;
    return await db!.insert(
      'datospersonales',
      {
        'codigo': codigo,
        'nombre': nombre,
        'precio': precio,
        'correo': correo,
        'edad': edad
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> obtenerDatosPersonales() async {
    final db = await database;
    return await db!.query('datospersonales');
  }

  Future<int> eliminarDatoPersonal(String codigo) async {
    final db = await database;
    return await db!.delete(
      'datospersonales',
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }
}