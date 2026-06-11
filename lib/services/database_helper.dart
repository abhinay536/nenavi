import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern – only one instance of this class
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'nenavi.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the scores table
        await db.execute('''
          CREATE TABLE scores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT UNIQUE,          -- store as YYYY-MM-DD
            composite_score INTEGER,
            domain_scores TEXT,        -- we'll store a JSON string
            difficulty TEXT
          )
        ''');
      },
    );
  }

  // Insert a new score (or replace if date already exists)
  Future<void> insertScore(Map<String, dynamic> score) async {
    final db = await database;
    await db.insert(
      'scores',
      score,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all scores sorted by date
  Future<List<Map<String, dynamic>>> getAllScores() async {
    final db = await database;
    return await db.query('scores', orderBy: 'date ASC');
  }

  // Get the latest score
  Future<Map<String, dynamic>?> getLatestScore() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'scores',
      orderBy: 'date DESC',
      limit: 1,
    );
    if (results.isEmpty) return null;
    return results.first;
  }
}
