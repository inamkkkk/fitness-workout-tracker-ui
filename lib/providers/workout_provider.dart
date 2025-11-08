import 'package:flutter/foundation.dart';
import 'package:fitness_workout_tracker/models/workout.dart';
import 'package:fitness_workout_tracker/models/exercise.dart';
import 'package:fitness_workout_tracker/services/database_helper.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Exercise> _exercises = [];

  List<Workout> get workouts => _workouts;
  List<Exercise> get exercises => _exercises;

  Future<void> loadWorkouts() async {
    _workouts = await DatabaseHelper.instance.getWorkouts();
    notifyListeners();
  }

  Future<void> addWorkout(Workout workout) async {
    await DatabaseHelper.instance.insertWorkout(workout);
    await loadWorkouts();
  }

  Future<void> updateWorkout(Workout workout) async {
    await DatabaseHelper.instance.updateWorkout(workout);
    await loadWorkouts();
  }

  Future<void> deleteWorkout(int id) async {
    await DatabaseHelper.instance.deleteWorkout(id);
    await loadWorkouts();
  }

  Future<void> loadExercises(int workoutId) async {
    _exercises = await DatabaseHelper.instance.getExercises(workoutId);
    notifyListeners();
  }

  Future<void> addExercise(Exercise exercise) async {
    await DatabaseHelper.instance.insertExercise(exercise);
    await loadExercises(exercise.workoutId);
  }

  Future<void> updateExercise(Exercise exercise) async {
    await DatabaseHelper.instance.updateExercise(exercise);
    await loadExercises(exercise.workoutId);
  }

  Future<void> deleteExercise(int id) async {
    final workoutId = _exercises.firstWhere((element) => element.id == id).workoutId;
    await DatabaseHelper.instance.deleteExercise(id);
    await loadExercises(workoutId);
  }
}
