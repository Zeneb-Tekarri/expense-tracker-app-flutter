import 'package:expense_tracker_app/models/transaction.dart';
import 'package:expense_tracker_app/models/budget.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'expense_tracker.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE budget (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            category TEXT NOT NULL,
            amount REAL NOT NULL,
            month INTEGER NOT NULL,
            year INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE transactions ADD COLUMN category TEXT NOT NULL DEFAULT "Other"',
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE transactions ADD COLUMN date TEXT NOT NULL DEFAULT "2026-01-01T00:00:00.000"',
          );
        }
        if (oldVersion < 4) {
          await db.execute('''
            CREATE TABLE budget (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              category TEXT NOT NULL,
              amount REAL NOT NULL,
              month INTEGER NOT NULL,
              year INTEGER NOT NULL
            )
          ''');
        }
      },
    );
  }

  // Transaction CRUD operations
  Future<int> insertTransaction(TransactionModel transaction,) async {
    final db = await database;

    return await db.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  Future<List<TransactionModel>> getTransactions()  async {
    final db = await database;
    final List<Map<String, dynamic>> maps =  await db.query('transactions');

    return List.generate(maps.length,(index) => TransactionModel.fromMap(
      maps[index], ),);
  }

  Future<int> updateTransaction(TransactionModel transaction,) async {
    final db = await database;

    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id,) async {
    final db = await database;

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Budget CRUD operations
  Future<int> insertBudget(BudgetModel budget,) async {
    final db = await database;

    return await db.insert(
      'budget',
      budget.toMap(),
    );
  }

  Future<List<BudgetModel>> getBudgets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budget');

    return List.generate(maps.length, (index) => BudgetModel.fromMap(
      maps[index],),);
  }

  Future<int> updateBudget(BudgetModel budget,) async {
    final db = await database;

    return await db.update(
      'budget',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  Future<int> deleteBudget(int id,) async {
    final db = await database;

    return await db.delete(
      'budget',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}