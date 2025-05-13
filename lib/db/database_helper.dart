import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDB('broker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        password TEXT NOT NULL,
        moneda_preferida TEXT NOT NULL,
        modo_oscuro INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transacciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        monto REAL NOT NULL,
        categoria TEXT,
        nota TEXT NOT NULL,
        fecha TEXT NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
      )
    ''');
  }
}