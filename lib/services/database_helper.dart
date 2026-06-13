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
      version: 2,
      onCreate: (db, version) async {
        // Create the scores table with patient_uid
        await db.execute('''
          CREATE TABLE scores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT UNIQUE,          -- store as YYYY-MM-DD
            composite_score INTEGER,
            domain_scores TEXT,        -- we'll store a JSON string
            difficulty TEXT,
            patient_uid TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // add patient_uid column for existing databases
          try {
            await db.execute('ALTER TABLE scores ADD COLUMN patient_uid TEXT');
          } catch (e) {
            // ignore if column already exists
          }
        }
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

  // Get all scores sorted by date (filtered by patient UID if provided)
  Future<List<Map<String, dynamic>>> getAllScores({String? patientUid}) async {
    final db = await database;
    if (patientUid == null || patientUid.isEmpty) {
      return [];
    }
    return await db.query(
      'scores',
      where: 'patient_uid = ?',
      whereArgs: [patientUid],
      orderBy: 'date ASC',
    );
  }

  // Get the latest score (filtered by patient UID if provided)
  Future<Map<String, dynamic>?> getLatestScore({String? patientUid}) async {
    final db = await database;
    final uid = patientUid;
    if (uid == null || uid.isEmpty) {
      return null;
    }
    final List<Map<String, dynamic>> results = await db.query(
      'scores',
      where: 'patient_uid = ?',
      whereArgs: [uid],
      orderBy: 'date DESC',
      limit: 1,
    );
    if (results.isEmpty) return null;
    return results.first;
  }
}
