import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Packages {
  final int id;
  final String name;

  Packages({required this.id, required this.name});

  factory Packages.fromMap(Map<String, dynamic> json) => new Packages(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Exercises {
  final int id;
  final String name;
  final String execution;
  final int exerciseClass;

  Exercises(
      {required this.id,
      required this.name,
      required this.execution,
      required this.exerciseClass});

  factory Exercises.fromMap(Map<String, dynamic> json) => new Exercises(
        id: json['id'],
        name: json['name'],
        execution: json['execution'],
        exerciseClass: json['class'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'execution': execution,
      'class': exerciseClass,
    };
  }
}

class TrainingPlan {
  final int id;
  final int packagesId;
  final int day;

  TrainingPlan({required this.id, required this.packagesId, required this.day});

  factory TrainingPlan.fromMap(Map<String, dynamic> json) => new TrainingPlan(
        id: json['id'],
        packagesId: json['packages_id'],
        day: json['day'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'packages_id': packagesId,
      'day': day,
    };
  }
}

class TrainingDetail {
  final int id;
  final int trainingPlanId;
  final int? exerciseId;
  final int? exerciseClass;
  final String sets;
  final String reps;
  final String resttimes;

  TrainingDetail({
    required this.id,
    required this.trainingPlanId,
    this.exerciseId,
    this.exerciseClass,
    required this.sets,
    required this.reps,
    required this.resttimes,
  });

  factory TrainingDetail.fromMap(Map<String, dynamic> json) =>
      new TrainingDetail(
        id: json['id'],
        trainingPlanId: json['training_plan_id'],
        exerciseId: json['exercise_id'],
        exerciseClass: json['exercise_class'],
        sets: json['sets'],
        reps: json['reps'],
        resttimes: json['resttimes'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'training_plan_id': trainingPlanId,
      'exercise_id': exerciseId,
      'exercise_class': exerciseClass,
      'sets': sets,
      'reps': reps,
      'resttimes': resttimes,
    };
  }
}

class ExerciseResults {
  final int id;
  final int exerciseId;
  final String date;
  final int? weight;
  final int reps;

  ExerciseResults({
    required this.id,
    required this.exerciseId,
    required this.date,
    this.weight,
    required this.reps,
  });

  factory ExerciseResults.fromMap(Map<String, dynamic> json) =>
      new ExerciseResults(
        id: json['id'],
        exerciseId: json['exercise_id'],
        date: json['date'],
        weight: json['weight'],
        reps: json['reps'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercise_id': exerciseId,
      'date': date,
      'weight': weight,
      'reps': reps,
    };
  }
}

class DatabaseHelper {
  // Singleton-Instanz
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  // Private Konstruktor

  // Getter für die Datenbankinstanz
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialisierung der Datenbank
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'toss_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Packages (
            id INTEGER PRIMARY KEY,
            name TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE Exercises (
            id INTEGER PRIMARY KEY,
            name TEXT,
            execution TEXT,
            class INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE TrainingPlan (
            id INTEGER PRIMARY KEY,
            packages_id INTEGER,
            day INTEGER,
            FOREIGN KEY (packages_id) REFERENCES Packages(id)
          );
        ''');

        await db.execute('''
          CREATE TABLE TrainingDetail (
            id INTEGER PRIMARY KEY,
            training_plan_id INTEGER,
            exercise_id INTEGER DEFAULT NULL,
            exercise_class INTEGER DEFAULT NULL,
            sets TEXT,
            reps TEXT,
            resttimes TEXT,
            FOREIGN KEY (training_plan_id) REFERENCES TrainingPlan(id),
            FOREIGN KEY (exercise_id) REFERENCES Exercises(id),
            FOREIGN KEY (exercise_class) REFERENCES Exercises(class)
          );
        ''');

        await db.execute('''
          CREATE TABLE ExerciseResults (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            exercise_id INTEGER,
            date TEXT,
            weight REAL,
            reps INTEGER,
            FOREIGN KEY (exercise_id) REFERENCES Exercises(id)
          );
        ''');

        await insertPackages(db);
        await insertExercises(db);
        await insertrainingPlanData(db);
      },
    );
  }

  // Methoden, um Daten aus den verschiedenen Tabellen abzurufen

  Future<void> insertPackages(Database db) async {
    final db = await database;

    await db.insert('Packages', {'id': 1, 'name': 'essential'});
    await db.insert('Packages', {'id': 2, 'name': 'progress'});
    await db.insert('Packages', {'id': 3, 'name': 'peak'});
  }

  Future<void> insertExercises(Database db) async {
    final db = await database;

    // Übungen
    await db.insert('Exercises', {
      'id': 1,
      'name': '3 Sec Squad jump',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 1
    });
    await db.insert('Exercises', {
      'id': 2,
      'name': 'Box Jump',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 1
    });
    await db.insert('Exercises', {
      'id': 3,
      'name': 'Jumping lunge to lunge',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 1
    });
    await db.insert('Exercises', {
      'id': 4,
      'name': 'Hop, Hop Stick',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 1
    });
    await db.insert('Exercises', {
      'id': 5,
      'name': 'Depth Jump Freeze',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 1
    });
    await db.insert('Exercises', {
      'id': 6,
      'name': 'Depth Jump Rebound to 2 leg',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 1
    });
    await db.insert('Exercises', {
      'id': 7,
      'name': 'Drop jump Rebound to 2 leg',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 1
    });
    await db.insert('Exercises', {
      'id': 20,
      'name': 'B Power Clean',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 2
    });
    await db.insert('Exercises', {
      'id': 21,
      'name': 'B Squat Clean',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 2
    });
    await db.insert('Exercises', {
      'id': 22,
      'name': 'B Hang Power Clean',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 2
    });
    await db.insert('Exercises', {
      'id': 23,
      'name': 'B Hang Squat Clean',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 2
    });
    await db.insert('Exercises', {
      'id': 24,
      'name': 'B Power Snatch',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 2
    });
    await db.insert('Exercises', {
      'id': 25,
      'name': 'B Squat Snatch',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 2
    });
    await db.insert('Exercises', {
      'id': 26,
      'name': 'B Hang Power Snatch',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 2
    });
    await db.insert('Exercises', {
      'id': 27,
      'name': 'B Hang Squat Snatch',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 2
    });
    await db.insert('Exercises', {
      'id': 40,
      'name': 'B Power Jerk',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 3
    });
    await db.insert('Exercises', {
      'id': 41,
      'name': 'B Split Jerk',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 3
    });
    await db.insert('Exercises', {
      'id': 42,
      'name': 'B Thruster',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 3
    });
    await db.insert('Exercises', {
      'id': 43,
      'name': 'Barbell Squat Jump',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 3
    });
    await db.insert('Exercises', {
      'id': 44,
      'name': 'Wall Ball',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 3
    });
    await db.insert('Exercises', {
      'id': 45,
      'name': '2-Handed Kettlebell Swing',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 3
    });
    await db.insert('Exercises', {
      'id': 46,
      'name': '1-Handed Kettlebell Swing',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 3
    });
    await db.insert('Exercises', {
      'id': 47,
      'name': 'Side Walking Kettlebell Swing',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 3
    });
    await db.insert('Exercises', {
      'id': 60,
      'name': 'B Back Squat',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 4
    });
    await db.insert('Exercises', {
      'id': 61,
      'name': 'B Overhead Squat',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 4
    });
    await db.insert('Exercises', {
      'id': 62,
      'name': 'B Front Squat',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 4
    });
    await db.insert('Exercises', {
      'id': 63,
      'name': 'B Forward Lunge',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 4
    });
    await db.insert('Exercises', {
      'id': 64,
      'name': 'B Backward Lunge',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 4
    });
    await db.insert('Exercises', {
      'id': 65,
      'name': 'K Forward 1-Arm Lunge',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 4
    });
    await db.insert('Exercises', {
      'id': 66,
      'name': 'K Backward 1-Arm Lunge',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 4
    });
    await db.insert('Exercises', {
      'id': 67,
      'name': 'Pistol Squat',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 4
    });
    await db.insert('Exercises', {
      'id': 80,
      'name': 'Standing Barbell Press chest',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 81,
      'name': 'Standing Barbell Press neck',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 82,
      'name': 'B Chaos Strict Press',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 83,
      'name': 'B Push Press',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 84,
      'name': 'D Push Press',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 85,
      'name': 'D 1-Arm Push Press',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 86,
      'name': 'K 1-Arm Cupie Balance Press',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 87,
      'name': 'Standing Dumbbell Press',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 88,
      'name': 'Banded Push Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 89,
      'name': 'Banded Diamond Push Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 90,
      'name': 'Elevated-feet Push Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 91,
      'name': 'Elevated Push Up Release (low to high)',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 5
    });
    await db.insert('Exercises', {
      'id': 100,
      'name': 'B Deadlift',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 6
    });
    await db.insert('Exercises', {
      'id': 101,
      'name': 'B Deficit Deadlift',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 6
    });
    await db.insert('Exercises', {
      'id': 102,
      'name': 'B Romanian Deadlift',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 6
    });
    await db.insert('Exercises', {
      'id': 103,
      'name': 'B Good Morning',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 6
    });
    await db.insert('Exercises', {
      'id': 104,
      'name': 'B Good Morning to Squat',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 6
    });
    await db.insert('Exercises', {
      'id': 105,
      'name': 'T Up & Down Hamstring Curl',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 6
    });
    await db.insert('Exercises', {
      'id': 106,
      'name': '1-Leg Glute Bridge',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 6
    });
    await db.insert('Exercises', {
      'id': 120,
      'name': 'Chin Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 7
    });
    await db.insert('Exercises', {
      'id': 121,
      'name': 'Pull Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 7
    });
    await db.insert('Exercises', {
      'id': 122,
      'name': 'B Bent Over Row Overhand Grip',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 7
    });
    await db.insert('Exercises', {
      'id': 123,
      'name': 'B Bent Over Row Underhand Grip',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 7
    });
    await db.insert('Exercises', {
      'id': 124,
      'name': 'D 1-Arm Bent Over Row',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 7
    });
    await db.insert('Exercises', {
      'id': 125,
      'name': 'B Seal Row',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 7
    });
    await db.insert('Exercises', {
      'id': 140,
      'name': 'B Extension Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 8
    });
    await db.insert('Exercises', {
      'id': 141,
      'name': 'D Extension Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 8
    });
    await db.insert('Exercises', {
      'id': 142,
      'name': 'D 1-Arm Cupie Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 8
    });
    await db.insert('Exercises', {
      'id': 143,
      'name': 'K 1-Arm Cupie Balance',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 8
    });
    await db.insert('Exercises', {
      'id': 144,
      'name': 'Handstand Hold Chestwall',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 8
    });
    await db.insert('Exercises', {
      'id': 145,
      'name': 'Handstand Hold Backwall',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 8
    });
    await db.insert('Exercises', {
      'id': 146,
      'name': 'K Turkish Get Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 8
    });
    await db.insert('Exercises', {
      'id': 147,
      'name': 'Plate Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 8
    });
    await db.insert('Exercises', {
      'id': 148,
      'name': 'B Forward Overhead Lunge',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 8
    });
    await db.insert('Exercises', {
      'id': 149,
      'name': 'B Overhead Squat Bottom Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 8
    });
    await db.insert('Exercises', {
      'id': 160,
      'name': 'Dips',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 161,
      'name': 'D 1-Arm Tricep Kick Back',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 162,
      'name': 'D 2-Arm Tricep Overhead Extension',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 163,
      'name': 'Skull Crusher',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 164,
      'name': 'B Bicep Curl',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 165,
      'name': 'D Hammer Curl',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 166,
      'name': 'D Twisted Bicep Curl',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 167,
      'name': 'Banded Face Pull',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 168,
      'name': 'Steering Wheel',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 169,
      'name': 'D Shoulder Rollercoaster',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 170,
      'name': 'D Shoulder L-Raises',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 171,
      'name': 'B Popeye (forward & backward)',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 172,
      'name': 'B Forearm Extension',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 173,
      'name': 'B Forearm Flexion',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 174,
      'name': 'Forearm Kettlebell Turn',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 175,
      'name': 'Forearm Towel Bottom Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 9
    });
    await db.insert('Exercises', {
      'id': 180,
      'name': 'Band Pull Apart',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 181,
      'name': 'Band Pull Apart Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 182,
      'name': '1-Arm Banded Row & Rotate',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 183,
      'name': '1-Arm Band Front Raise',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 184,
      'name': 'K Low Windmill',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 185,
      'name': 'Incline IYTs',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 186,
      'name': 'Lying Overhead Pres',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 187,
      'name': 'Lego Man',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 188,
      'name': 'External Shoulder Rotation',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 189,
      'name': 'External Shoulder Rotation (high)',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 190,
      'name': 'External Shoulder Rotation (abducted)',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 191,
      'name': '1-Leg Elevated Calf Raise',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 192,
      'name': '3-Way Ankle Prehab',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 193,
      'name': 'Reverse Calf Raise',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 10
    });
    await db.insert('Exercises', {
      'id': 200,
      'name': 'Hanging Tuck to Straight Legs',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 201,
      'name': 'Hanging Tuck Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 202,
      'name': 'Side Plank with leg up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 203,
      'name': 'K Side Bend',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 204,
      'name': 'P Russian Twist',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 205,
      'name': 'P Cross Body Pull',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 206,
      'name': 'B Kneeling Roll Out',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 207,
      'name': 'Straight Arm Crunch',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 208,
      'name': 'Leg Raise to Candlestick',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 209,
      'name': 'K 2-Arm Overhead Sit Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 210,
      'name': 'D 1-Arm Farmer Carry',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 211,
      'name': 'Dead Bug',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 212,
      'name': 'Reverse Hyper',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 213,
      'name': 'Superman',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 214,
      'name': 'P Full Hyperextension Segmental',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 11
    });
    await db.insert('Exercises', {
      'id': 220,
      'name': '1-arm Cupie Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 221,
      'name': '1-Arm Farmer carry',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 222,
      'name': '3 sec Squat Jump',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 223,
      'name': 'B Kneeling Roll Out',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 224,
      'name': 'B Lunge Variation',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 225,
      'name': 'B Romanian Deadlift',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 226,
      'name': 'Back Squad',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 227,
      'name': 'B Back Squad',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 228,
      'name': 'Banded Face Pull',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 229,
      'name': 'Barbell Squat Jump',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 230,
      'name': 'Box Jump',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 231,
      'name': 'Chaos Strict Press',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 232,
      'name': 'Chin Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 233,
      'name': 'Chin Up Variation',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 234,
      'name': 'Clean',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 235,
      'name': 'Clean Variation',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 236,
      'name': 'Cross Body Pull',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 237,
      'name': 'D Extension Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 238,
      'name': 'D Shoulder Rollercoaster',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 239,
      'name': 'Dead Bug',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 240,
      'name': 'Depth jump Freeze',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 241,
      'name': 'Depth Jump to Box',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 242,
      'name': 'Drop Jump',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 243,
      'name': 'Elevated calf raise',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 244,
      'name': 'B Extension Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 245,
      'name': 'Front Squad',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 246,
      'name': 'Front Squad',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 247,
      'name': 'Full Hyperextension Segmental',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 248,
      'name': 'Hanging Tuck Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 249,
      'name': 'Hanging Tuck to Straight Legs',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 250,
      'name': 'Hop, Hop & Stick',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 251,
      'name': 'K 1-arm Cupie Balance',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 252,
      'name': 'K 1-arm Overhead Sit Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 253,
      'name': 'K Side Bend',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 254,
      'name': 'Lego Man',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 255,
      'name': 'Lunge',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 20
    });
    await db.insert('Exercises', {
      'id': 256,
      'name': 'Lunge to Lunge',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 257,
      'name': 'Overheadsquad',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 258,
      'name': 'P Incline IYTs',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 259,
      'name': 'Pistol Squad',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 20
    });
    await db.insert('Exercises', {
      'id': 260,
      'name': 'Plate Hold',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 261,
      'name': 'Power Jerk',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 262,
      'name': 'Pull Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 263,
      'name': 'Reverse Calf Raise',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 264,
      'name': 'Reverse Hyper',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 265,
      'name': 'Russian Twist',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 266,
      'name': 'Side Plank leg up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 267,
      'name': 'Skull Crusher',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 268,
      'name': 'Split Jerk',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 269,
      'name': 'Snatch',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 270,
      'name': 'Split Jerk',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 271,
      'name': 'Squat',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 272,
      'name': 'Steering Wheel',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 273,
      'name': 'Straight Arm Crunch',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 274,
      'name': 'Superman',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 275,
      'name': 'Turkish Get Up',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
    await db.insert('Exercises', {
      'id': 276,
      'name': 'Wall Ball',
      'execution':
          'https://www.youtube.com/watch?v=LWDfJzgRUjw&ab_channel=carpediemMagazin',
      'class': 0
    });
  }

  Future<void> insertrainingPlanData(Database db) async {
    final db = await database;

    // Trainingspläne
    await db.insert('TrainingPlan', {'id': 1, 'packages_id': 2, 'day': 1});

    /* */ await db.insert('TrainingDetail', {
      'id': 1,
      'training_plan_id': 1,
      'exercise_id': 5,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '1-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 2,
      'training_plan_id': 1,
      'exercise_id': 227,
      'exercise_class': null,
      'sets': '3',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 3,
      'training_plan_id': 1,
      'exercise_id': null,
      'exercise_class': 6,
      'sets': '3',
      'reps': '8',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 4,
      'training_plan_id': 1,
      'exercise_id': null,
      'exercise_class': 5,
      'sets': '3',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 5,
      'training_plan_id': 1,
      'exercise_id': 233,
      'exercise_class': null,
      'sets': '3',
      'reps': 'max',
      'resttimes': '2-3 mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 6,
      'training_plan_id': 1,
      'exercise_id': 140,
      'exercise_class': null,
      'sets': '3',
      'reps': '60sec',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 7,
      'training_plan_id': 1,
      'exercise_id': null,
      'exercise_class': 9,
      'sets': '3',
      'reps': '12-15',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 8,
      'training_plan_id': 1,
      'exercise_id': 248,
      'exercise_class': null,
      'sets': '2',
      'reps': 'Max',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 9,
      'training_plan_id': 1,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 2, 'packages_id': 2, 'day': 2});

    /* */ await db.insert('TrainingDetail', {
      'id': 21,
      'training_plan_id': 2,
      'exercise_id': null,
      'exercise_class': 1,
      'sets': '3',
      'reps': '5',
      'resttimes': '1-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 22,
      'training_plan_id': 2,
      'exercise_id': 269,
      'exercise_class': null,
      'sets': '4',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 23,
      'training_plan_id': 2,
      'exercise_id': 40,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 24,
      'training_plan_id': 2,
      'exercise_id': null,
      'exercise_class': 20,
      'sets': '3',
      'reps': '8',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 25,
      'training_plan_id': 2,
      'exercise_id': null,
      'exercise_class': 8,
      'sets': '2',
      'reps': '30sec',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 26,
      'training_plan_id': 2,
      'exercise_id': 160,
      'exercise_class': null,
      'sets': '3',
      'reps': '8-10',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 27,
      'training_plan_id': 2,
      'exercise_id': null,
      'exercise_class': 10,
      'sets': '3',
      'reps': '10-12',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 28,
      'training_plan_id': 2,
      'exercise_id': 274,
      'exercise_class': null,
      'sets': '2',
      'reps': '15',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 29,
      'training_plan_id': 2,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15 oder 30sec',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 3, 'packages_id': 2, 'day': 3});

    /* */ await db.insert('TrainingDetail', {
      'id': 31,
      'training_plan_id': 3,
      'exercise_id': null,
      'exercise_class': 3,
      'sets': '3',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 32,
      'training_plan_id': 3,
      'exercise_id': 245,
      'exercise_class': null,
      'sets': '4',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 33,
      'training_plan_id': 3,
      'exercise_id': 100,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '3-3.5mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 34,
      'training_plan_id': 3,
      'exercise_id': null,
      'exercise_class': 5,
      'sets': '3',
      'reps': 'max',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 35,
      'training_plan_id': 3,
      'exercise_id': null,
      'exercise_class': 7,
      'sets': '3',
      'reps': '12-15',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 36,
      'training_plan_id': 3,
      'exercise_id': null,
      'exercise_class': 9,
      'sets': '3',
      'reps': '10-12',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 37,
      'training_plan_id': 3,
      'exercise_id': 243,
      'exercise_class': null,
      'sets': '2',
      'reps': '10-15',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 38,
      'training_plan_id': 3,
      'exercise_id': 221,
      'exercise_class': null,
      'sets': '3',
      'reps': '20 Meter',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 39,
      'training_plan_id': 3,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15 oder 30sec',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 4, 'packages_id': 2, 'day': 4});

    /* */ await db.insert('TrainingDetail', {
      'id': 41,
      'training_plan_id': 4,
      'exercise_id': 5,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '1-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 42,
      'training_plan_id': 4,
      'exercise_id': 227,
      'exercise_class': null,
      'sets': '3',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 43,
      'training_plan_id': 4,
      'exercise_id': null,
      'exercise_class': 6,
      'sets': '3',
      'reps': '8',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 44,
      'training_plan_id': 4,
      'exercise_id': null,
      'exercise_class': 5,
      'sets': '3',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 45,
      'training_plan_id': 4,
      'exercise_id': 233,
      'exercise_class': null,
      'sets': '3',
      'reps': 'max',
      'resttimes': 2 - 3
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 46,
      'training_plan_id': 4,
      'exercise_id': 140,
      'exercise_class': null,
      'sets': '3',
      'reps': '60sec',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 47,
      'training_plan_id': 4,
      'exercise_id': null,
      'exercise_class': 9,
      'sets': '3',
      'reps': '12-15',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 48,
      'training_plan_id': 4,
      'exercise_id': 248,
      'exercise_class': null,
      'sets': '2',
      'reps': 'Max',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 49,
      'training_plan_id': 4,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 5, 'packages_id': 2, 'day': 5});

    /* */ await db.insert('TrainingDetail', {
      'id': 51,
      'training_plan_id': 5,
      'exercise_id': null,
      'exercise_class': 1,
      'sets': '3',
      'reps': '5',
      'resttimes': '1-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 52,
      'training_plan_id': 5,
      'exercise_id': 269,
      'exercise_class': null,
      'sets': '4',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 53,
      'training_plan_id': 5,
      'exercise_id': 40,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 54,
      'training_plan_id': 5,
      'exercise_id': null,
      'exercise_class': 20,
      'sets': '3',
      'reps': '8',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 55,
      'training_plan_id': 5,
      'exercise_id': null,
      'exercise_class': 8,
      'sets': '2',
      'reps': '30sec',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 56,
      'training_plan_id': 5,
      'exercise_id': 160,
      'exercise_class': null,
      'sets': '3',
      'reps': '8-10',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 57,
      'training_plan_id': 5,
      'exercise_id': null,
      'exercise_class': 10,
      'sets': '3',
      'reps': '10-12',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 58,
      'training_plan_id': 5,
      'exercise_id': 274,
      'exercise_class': null,
      'sets': '2',
      'reps': '15',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 59,
      'training_plan_id': 5,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15 oder 30sec',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 6, 'packages_id': 2, 'day': 6});

    /* */ await db.insert('TrainingDetail', {
      'id': 61,
      'training_plan_id': 6,
      'exercise_id': null,
      'exercise_class': 3,
      'sets': '3',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 62,
      'training_plan_id': 6,
      'exercise_id': 245,
      'exercise_class': null,
      'sets': '4',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 63,
      'training_plan_id': 6,
      'exercise_id': 100,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '3-3.5mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 64,
      'training_plan_id': 6,
      'exercise_id': null,
      'exercise_class': 5,
      'sets': '3',
      'reps': 'max',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 65,
      'training_plan_id': 6,
      'exercise_id': null,
      'exercise_class': 7,
      'sets': '3',
      'reps': '12-15',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 66,
      'training_plan_id': 6,
      'exercise_id': null,
      'exercise_class': 9,
      'sets': '3',
      'reps': '10-12',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 67,
      'training_plan_id': 6,
      'exercise_id': 243,
      'exercise_class': null,
      'sets': '2',
      'reps': '10-15',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 68,
      'training_plan_id': 6,
      'exercise_id': 221,
      'exercise_class': null,
      'sets': '3',
      'reps': '20 Meter',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 69,
      'training_plan_id': 6,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15 oder 30sec',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 7, 'packages_id': 2, 'day': 7});

    /* */ await db.insert('TrainingDetail', {
      'id': 71,
      'training_plan_id': 7,
      'exercise_id': 5,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '1-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 72,
      'training_plan_id': 7,
      'exercise_id': 227,
      'exercise_class': null,
      'sets': '3',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 73,
      'training_plan_id': 7,
      'exercise_id': null,
      'exercise_class': 6,
      'sets': '3',
      'reps': '8',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 74,
      'training_plan_id': 7,
      'exercise_id': null,
      'exercise_class': 5,
      'sets': '3',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 75,
      'training_plan_id': 7,
      'exercise_id': 233,
      'exercise_class': null,
      'sets': '3',
      'reps': 'max',
      'resttimes': 2 - 3
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 76,
      'training_plan_id': 7,
      'exercise_id': 140,
      'exercise_class': null,
      'sets': '3',
      'reps': '60sec',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 77,
      'training_plan_id': 7,
      'exercise_id': null,
      'exercise_class': 9,
      'sets': '3',
      'reps': '12-15',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 78,
      'training_plan_id': 7,
      'exercise_id': 248,
      'exercise_class': null,
      'sets': '2',
      'reps': 'Max',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 79,
      'training_plan_id': 7,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 8, 'packages_id': 2, 'day': 8});

    /* */ await db.insert('TrainingDetail', {
      'id': 81,
      'training_plan_id': 8,
      'exercise_id': null,
      'exercise_class': 1,
      'sets': '3',
      'reps': '5',
      'resttimes': '1-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 82,
      'training_plan_id': 8,
      'exercise_id': 269,
      'exercise_class': null,
      'sets': '4',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 83,
      'training_plan_id': 8,
      'exercise_id': 40,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 84,
      'training_plan_id': 8,
      'exercise_id': null,
      'exercise_class': 20,
      'sets': '3',
      'reps': '8',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 85,
      'training_plan_id': 8,
      'exercise_id': null,
      'exercise_class': 8,
      'sets': '2',
      'reps': '30sec',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 86,
      'training_plan_id': 8,
      'exercise_id': 160,
      'exercise_class': null,
      'sets': '3',
      'reps': '8-10',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 87,
      'training_plan_id': 8,
      'exercise_id': null,
      'exercise_class': 10,
      'sets': '3',
      'reps': '10-12',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 88,
      'training_plan_id': 8,
      'exercise_id': 274,
      'exercise_class': null,
      'sets': '2',
      'reps': '15',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 89,
      'training_plan_id': 8,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15 oder 30sec',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 9, 'packages_id': 2, 'day': 9});

    /* */ await db.insert('TrainingDetail', {
      'id': 91,
      'training_plan_id': 9,
      'exercise_id': null,
      'exercise_class': 3,
      'sets': '3',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 92,
      'training_plan_id': 9,
      'exercise_id': 245,
      'exercise_class': null,
      'sets': '4',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 93,
      'training_plan_id': 9,
      'exercise_id': 100,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '3-3.5mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 94,
      'training_plan_id': 9,
      'exercise_id': null,
      'exercise_class': 5,
      'sets': '3',
      'reps': 'max',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 95,
      'training_plan_id': 9,
      'exercise_id': null,
      'exercise_class': 7,
      'sets': '3',
      'reps': '12-15',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 96,
      'training_plan_id': 9,
      'exercise_id': null,
      'exercise_class': 9,
      'sets': '3',
      'reps': '10-12',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 97,
      'training_plan_id': 9,
      'exercise_id': 243,
      'exercise_class': null,
      'sets': '2',
      'reps': '10-15',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 98,
      'training_plan_id': 9,
      'exercise_id': 221,
      'exercise_class': null,
      'sets': '3',
      'reps': '20 Meter',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 99,
      'training_plan_id': 9,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15 oder 30sec',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 10, 'packages_id': 2, 'day': 10});

    /* */ await db.insert('TrainingDetail', {
      'id': 101,
      'traing_plan_id': 10,
      'exercise_id': 5,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '1-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 102,
      'training_plan_id': 10,
      'exercise_id': 227,
      'exercise_class': null,
      'sets': '3',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 103,
      'training_plan_id': 10,
      'exercise_id': null,
      'exercise_class': 6,
      'sets': '3',
      'reps': '8',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 104,
      'training_plan_id': 10,
      'exercise_id': null,
      'exercise_class': 5,
      'sets': '3',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 105,
      'training_plan_id': 10,
      'exercise_id': 233,
      'exercise_class': null,
      'sets': '3',
      'reps': 'max',
      'resttimes': '2-3 mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 106,
      'training_plan_id': 10,
      'exercise_id': 140,
      'exercise_class': null,
      'sets': '3',
      'reps': '60sec',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 107,
      'training_plan_id': 10,
      'exercise_id': null,
      'exercise_class': '9',
      'sets': '3',
      'reps': '12-15',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 108,
      'training_plan_id': 10,
      'exercise_id': 248,
      'exercise_class': null,
      'sets': '2',
      'reps': 'Max',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 109,
      'training_plan_id': 10,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 11, 'packages_id': 2, 'day': 11});

    /* */ await db.insert('TrainingDetail', {
      'id': 111,
      'training_plan_id': 11,
      'exercise_id': null,
      'exercise_class': 1,
      'sets': '3',
      'reps': '5',
      'resttimes': '1-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 112,
      'training_plan_id': 11,
      'exercise_id': 269,
      'exercise_class': null,
      'sets': '4',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 113,
      'training_plan_id': 11,
      'exercise_id': 40,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 114,
      'training_plan_id': 11,
      'exercise_id': null,
      'exercise_class': 20,
      'sets': '3',
      'reps': '8',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 115,
      'training_plan_id': 11,
      'exercise_id': null,
      'exercise_class': 8,
      'sets': '2',
      'reps': '30sec',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 116,
      'training_plan_id': 11,
      'exercise_id': 160,
      'exercise_class': null,
      'sets': '3',
      'reps': '8-10',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 117,
      'training_plan_id': 11,
      'exercise_id': null,
      'exercise_class': 10,
      'sets': '3',
      'reps': '10-12',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 118,
      'training_plan_id': 11,
      'exercise_id': 274,
      'exercise_class': null,
      'sets': '2',
      'reps': '15',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 119,
      'training_plan_id': 11,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15 oder 30sec',
      'resttimes': '1-1,5min'
    });

    await db.insert('TrainingPlan', {'id': 12, 'packages_id': 2, 'day': 12});

    /* */ await db.insert('TrainingDetail', {
      'id': 121,
      'training_plan_id': 12,
      'exercise_id': null,
      'exercise_class': 3,
      'sets': '3',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 122,
      'training_plan_id': 12,
      'exercise_id': 245,
      'exercise_class': null,
      'sets': '4',
      'reps': '6',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 123,
      'training_plan_id': 12,
      'exercise_id': 100,
      'exercise_class': null,
      'sets': '3',
      'reps': '5',
      'resttimes': '3-3.5mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 124,
      'training_plan_id': 12,
      'exercise_id': null,
      'exercise_class': 5,
      'sets': '3',
      'reps': 'max',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 125,
      'training_plan_id': 12,
      'exercise_id': null,
      'exercise_class': 7,
      'sets': '3',
      'reps': '12-15',
      'resttimes': '2-3mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 126,
      'training_plan_id': 12,
      'exercise_id': null,
      'exercise_class': 9,
      'sets': '3',
      'reps': '10-12',
      'resttimes': 'superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 127,
      'training_plan_id': 12,
      'exercise_id': 243,
      'exercise_class': null,
      'sets': '2',
      'reps': '10-15',
      'resttimes': '1,5-2mins'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 128,
      'training_plan_id': 12,
      'exercise_id': 221,
      'exercise_class': null,
      'sets': '3',
      'reps': '20 Meter',
      'resttimes': 'Superset'
    });
    /* */ await db.insert('TrainingDetail', {
      'id': 129,
      'training_plan_id': 12,
      'exercise_id': null,
      'exercise_class': 11,
      'sets': '2',
      'reps': '12-15 oder 30sec',
      'resttimes': '1-1,5min'
    });
  }

  Future<List<Map<String, dynamic>>> getPackages() async {
    final db = await database;
    return await db.query('Packages');
  }

  Future<List<Map<String, dynamic>>> getTrainingDetails(int day) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''

SELECT 
    Exercises.name, 
    TrainingDetail.sets, 
    TrainingDetail.reps, 
    TrainingDetail.resttimes
FROM 
    Exercises
JOIN 
    TrainingDetail ON TrainingDetail.exercise_id = Exercises.id
JOIN 
    TrainingPlan ON TrainingDetail.training_plan_id = TrainingPlan.id
WHERE 
    TrainingPlan.packages_id = 2 AND 
    TrainingPlan.day = ?;
  ''', [day]);

    print('TrainingDetails: $results');
    return results;
  }

  Future<List<Map<String, dynamic>>> getAllExercises() async {
    final db = await database;

    // Abrufen aller Daten aus der Tabelle Exercises
    return await db.query('Exercises');
  }

  Future<List<Map<String, dynamic>>> getAllPackages() async {
    final db = await database;

    // Abrufen aller Daten aus der Tabelle Packages
    return await db.query('Packages');
  }
}
