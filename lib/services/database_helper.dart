import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fitness_workout_tracker/models/workout.dart';
import 'package:fitness_workout_tracker/models/exercise.dart';

class DatabaseHelper {
  static const _databaseName = 'WorkoutTracker.db';
  static const _databaseVersion = 1;

  static const tableWorkouts = 'workouts';
  static const tableExercises = 'exercises';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableWorkouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableExercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workoutId INTEGER NOT NULL,
        name TEXT NOT NULL,
        sets INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        FOREIGN KEY (workoutId) REFERENCES $tableWorkouts(id)
      )
    ''');
  }

  Future<int> insertWorkout(Workout workout) async {
    final db = await instance.database;
    return await db.insert(tableWorkouts, workout.toMap());
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableWorkouts);
    return List.generate(maps.length, (i) {
      return Workout.fromMap(maps[i]);
    });
  }

  Future<int> updateWorkout(Workout workout) async {
    final db = await instance.database;
    return await db.update(
      tableWorkouts,
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> deleteWorkout(int id) async {
    final db = await instance.database;
    await db.delete(
      tableExercises,
      where: 'workoutId = ?',
      whereArgs: [id],
    );
    return await db.delete(
      tableWorkouts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertExercise(Exercise exercise) async {
    final db = await instance.database;
    return await db.insert(tableExercises, exercise.toMap());
  }

  Future<List<Exercise>> getExercises(int workoutId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableExercises,
      where: 'workoutId = ?',
      whereArgs: [workoutId],
    );
    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await instance.database;
    return await db.update(
      tableExercises,
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableExercises,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
