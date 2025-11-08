import 'package:flutter/material.dart';
import 'package:fitness_workout_tracker/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:fitness_workout_tracker/providers/workout_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => WorkoutProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Workout Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
