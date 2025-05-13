import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:broker/models/transaction_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _db;

  Future<void> initDB() async {
    if (_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'broker.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            type TEXT,
            amount REAL,
            category TEXT,
            note TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertTransaction(TransactionModel tx) async {
    return await _db!.insert('transactions', tx.toMap());
  }

  Future<List<TransactionModel>> getTransactionsByUser(String userId) async {
    final List<Map<String, dynamic>> maps = await _db!.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return maps.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<void> deleteTransaction(int id) async {
    await _db!.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
