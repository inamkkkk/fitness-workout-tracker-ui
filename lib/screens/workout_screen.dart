import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fitness_workout_tracker/providers/workout_provider.dart';
import 'package:provider/provider.dart';
import 'package:fitness_workout_tracker/models/exercise.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WorkoutScreen extends StatefulWidget {
  final int workoutId;

  const WorkoutScreen({Key? key, required this.workoutId}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  TextEditingController exerciseNameController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  Timer? _timer;
  int _start = 0; // Duration in seconds
  bool _isRunning = false;
  double _progress = 0.0;
  int _restDuration = 60; //Default rest duration in seconds
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutProvider>(context, listen: false)
          .loadExercises(widget.workoutId);
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _start = _restDuration;
    _isRunning = true;
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _isRunning = false;
            _progress = 0.0;
          });
        } else {
          setState(() {
            _start--;
            _progress = 1 - (_start / _restDuration);
          });
        }
      },
    );
  }

  void stopTimer() {
    if (_timer != null) {
      setState(() {
        _timer!.cancel();
        _isRunning = false;
        _progress = 0.0;
        _start = 0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    exerciseNameController.dispose();
    setsController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final exercises = workoutProvider.exercises;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: exercises.isEmpty
                  ? const Center(
                      child: Text('No exercises added yet.'),
                    )
                  : ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Sets: ${exercise.sets}, Reps: ${exercise.reps}'),
                                ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),onPressed: () {
                                  workoutProvider.deleteExercise(exercise.id!);},),
                              ],
                            ),
                          ),
                        );
                      },
                    ),            ),
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 8.0,
              percent: _progress,
              center: Text(_isRunning ? "$_start" : "Rest"),
              progressColor: Colors.green,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isRunning ? stopTimer : startTimer,
              child: Text(_isRunning ? 'Stop Rest' : 'Start Rest'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddExerciseDialog(context, widget.workoutId);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddExerciseDialog(BuildContext context, int workoutId) async {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Exercise'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: exerciseNameController,
                  decoration: const InputDecoration(hintText: 'Exercise Name'),
                ),
                TextFormField(
                  controller: setsController,
                  decoration: const InputDecoration(hintText: 'Sets'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: repsController,
                  decoration: const InputDecoration(hintText: 'Reps'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                exerciseNameController.clear();
                setsController.clear();
                repsController.clear();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final name = exerciseNameController.text;
                final sets = int.tryParse(setsController.text) ?? 0;
                final reps = int.tryParse(repsController.text) ?? 0;

                if (name.isNotEmpty && sets > 0 && reps > 0) {
                  workoutProvider.addExercise(
                    Exercise(
                      workoutId: workoutId,
                      name: name,
                      sets: sets,
                      reps: reps,
                    ),
                  );
                  Navigator.of(context).pop();
                  exerciseNameController.clear();
                  setsController.clear();
                  repsController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
