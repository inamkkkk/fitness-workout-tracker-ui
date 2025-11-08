import 'package:flutter/material.dart';
import 'package:fitness_workout_tracker/providers/workout_provider.dart';
import 'package:provider/provider.dart';
import 'package:fitness_workout_tracker/models/workout.dart';
import 'package:fitness_workout_tracker/screens/workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutProvider>(context, listen: false).loadWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
      ),
      body: workoutProvider.workouts.isEmpty
          ? const Center(
              child: Text('No workouts yet. Add a new workout.'),
            )
          : ListView.builder(
              itemCount: workoutProvider.workouts.length,
              itemBuilder: (context, index) {
                final workout = workoutProvider.workouts[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(workout.name),
                    subtitle: Text('Created at: ${workout.createdAt}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        workoutProvider.deleteWorkout(workout.id!);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutScreen(workoutId: workout.id!),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddWorkoutDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddWorkoutDialog(BuildContext context) async {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    String workoutName = '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Workout'),
          content:
          TextFormField(
            decoration: const InputDecoration(hintText: 'Workout Name'),
            onChanged: (value) {
              workoutName = value;
            },
          ),

          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                if (workoutName.isNotEmpty) {
                  workoutProvider.addWorkout(Workout(name: workoutName, createdAt: DateTime.now().toString()));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
