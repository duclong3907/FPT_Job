import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            jobId INTEGER NOT NULL,
            userId TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertFavorite(int jobId, String userId) async {
    final db = await database;
    await db.insert(
      'favorites',
      {'jobId': jobId, 'userId': userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(int jobId, String userId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'jobId = ? AND userId = ?',
      whereArgs: [jobId, userId],
    );
  }

  Future<List<int>> getFavorites(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => maps[i]['jobId'] as int);
  }
}