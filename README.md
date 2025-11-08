# Fitness Workout Tracker

A Flutter application for tracking fitness workouts, exercises, sets, reps, and rest periods.

## Features

*   Display a list of exercises.
*   Track sets and reps for each exercise.
*   Timer for rest periods between sets.
*   Data persistence using SQLite.

## Folder Structure


lib/
├── main.dart           # Entry point of the application
├── screens/
│   └── home_screen.dart  # Home screen with workout list
│   └── workout_screen.dart # screen for workout details
├── models/
│   └── exercise.dart   # Exercise model
│   └── workout.dart    # Workout model
├── services/
│   └── database_helper.dart # Database helper class
└── providers/
    └── workout_provider.dart # Provider for state management


## Dependencies

*   flutter:
    sdk: flutter
*   cupertino_icons: ^1.0.2
*   provider: ^6.0.0
*   sqflite: ^2.0.0+4
*   path_provider: ^2.0.0
*   intl: ^0.17.0
*   shared_preferences: ^2.0.0
*   percent_indicator: ^4.2.2
