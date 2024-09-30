import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:ui'; // Für den Blur-Effekt
import 'database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOSS - Training of Stunt Strength',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Schwarzer Hintergrund
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Wenn auf das Bild getippt wird, zum Kalender navigieren
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TodayPage()),
            );
          },
          child: Image.asset(
            'assets/logo.png', // Hier wird das Bild verwendet
            fit: BoxFit
                .contain, // Optional: Skaliert das Bild passend zum Bildschirm
          ),
        ),
      ),
    );
  }
}

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  bool _isMenuVisible = false; // Zustand des Menüs
  DateTime _selectedDate = DateTime.now(); // Der aktuell ausgewählte Tag

  // Neues Map, um den Status der Tage zu speichern
  Map<String, String> _dayActivities = {
    'Montag': '',
    'Dienstag': '',
    'Mittwoch': '',
    'Donnerstag': '',
    'Freitag': '',
    'Samstag': '',
    'Sonntag': '',
  };

  @override
  void initState() {
    super.initState();
    _loadDayActivities(); // Lade die gespeicherten Aktivitäten
  }

  // Funktion zum Laden der Aktivitäten
  Future<void> _loadDayActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Lade Cheer-Tage
    // Angenommen, _dayActivities ist ein Map<String, String>
    _dayActivities.forEach((day, _) {
      bool? cheer = prefs.getBool('cheer_$day') ?? false;
      bool? progress = prefs.getBool('progress_$day') ?? false;

      if (cheer) {
        _dayActivities[day] = 'assets/Cheer.png'; // Setze Cheer-Bild
      } else if (progress) {
        _dayActivities[day] = 'Progress'; // Setze Progress-Text
      } else {
        _dayActivities[day] = ''; // Leerer String für Tage ohne Aktivität
      }
    });

// ListView zur Anzeige der Aktivitäten
    ListView.builder(
      itemCount: _dayActivities.length,
      itemBuilder: (context, index) {
        final day = _dayActivities.keys.elementAt(index);
        final activity = _dayActivities[day];

        return ListTile(
          title: activity!.isNotEmpty && activity.endsWith('.png')
              ? Image.asset(activity) // Bild anzeigen, wenn es ein Bild ist
              : Text(activity.isNotEmpty
                  ? activity
                  : 'Keine Aktivität'), // Andernfalls Text anzeigen
        );
      },
    );

    setState(() {}); // Aktualisiere den Zustand, um die UI zu aktualisieren
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heute'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Hauptinhalt
          Container(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Wochentag und Datum anzeigen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Linker Pfeil
                    IconButton(
                      icon: Icon(Icons.arrow_left, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate
                              .subtract(Duration(days: 1)); // Einen Tag zurück
                        });
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getWeekday(_selectedDate), // Wochentag
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          DateFormat('dd.MM.yyyy')
                              .format(_selectedDate), // Datum
                          style: TextStyle(
                              fontSize: 18, color: Colors.white), // Textfarbe
                        ),
                      ],
                    ),
                    // Rechter Pfeil
                    IconButton(
                      icon: Icon(Icons.arrow_right, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate
                              .add(Duration(days: 1)); // Einen Tag vorwärts
                        });
                      },
                    ),
                  ],
                ),
                // Platz für das Trainingsprogramm
                Expanded(
                  child: ListView.builder(
                    itemCount: 1, // Nur für den aktuellen Tag
                    itemBuilder: (context, index) {
                      String day = getWeekday(
                          _selectedDate); // Aktuellen Wochentag holen
                      String activity =
                          _dayActivities[day] ?? ''; // Aktuelle Aktivität

                      return ListTile(
                        title: Text(
                            activity.isNotEmpty
                                ? activity
                                : 'Rest Day', // Zeige nur die Aktivität an
                            style: TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Overlay-Blur und Menü
          if (_isMenuVisible) ...[
            // Blur-Effekt
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            // Menü überlagern
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildMenuItem('Plan', Icons.fitness_center),
                  buildMenuItem('Pakete', Icons.pages),
                  buildMenuItem('Community', Icons.people),
                  buildMenuItem('Warm up', Icons.local_fire_department),
                ],
              ),
            ),
          ],
          // Zentraler Button
          Positioned(
            bottom: 20, // Abstand vom unteren Bildschirmrand
            left: MediaQuery.of(context).size.width / 2 -
                30, // Button in der Mitte
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isMenuVisible = !_isMenuVisible; // Menü umschalten
                });
              },
              child: Image.asset(
                'assets/icon.png', // Pfad zu deinem Bild
                width: 60, // Breite des Bildes anpassen
                height: 60, // Höhe des Bildes anpassen
              ),
            ),
          )
        ],
      ),
    );
  }

  // Methode zum Erstellen eines Menüpunktes
  Widget buildMenuItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          if (title == 'Plan') {
            // Navigation zur PlanPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlanPage()),
            );
          } else if (title == 'Warm up') {
            // Hier hinzufügen
            // Navigation zur WarmupPage
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WarmupPage()), // Neue Page hier
            );
          } else {
            // Andere Menü-Logik
            print('$title angeklickt');
          }
        },
        icon: Icon(icon),
        label: Text(title),
      ),
    );
  }

  String getWeekday(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Montag';
      case 2:
        return 'Dienstag';
      case 3:
        return 'Mittwoch';
      case 4:
        return 'Donnerstag';
      case 5:
        return 'Freitag';
      case 6:
        return 'Samstag';
      case 7:
        return 'Sonntag';
      default:
        return '';
    }
  }
}

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  DateTime? _startDate;

  // Maps für Cheer und Progress
  Map<String, bool> _selectedDaysCheer = {
    'Montag': false,
    'Dienstag': false,
    'Mittwoch': false,
    'Donnerstag': false,
    'Freitag': false,
    'Samstag': false,
    'Sonntag': false,
  };

  Map<String, bool> _selectedDaysProgress = {
    'Montag': false,
    'Dienstag': false,
    'Mittwoch': false,
    'Donnerstag': false,
    'Freitag': false,
    'Samstag': false,
    'Sonntag': false,
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Speichern der Tage und des Startdatums
  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedDaysCheer.forEach((day, isSelected) {
      prefs.setBool('cheer_$day', isSelected);
    });
    _selectedDaysProgress.forEach((day, isSelected) {
      prefs.setBool('progress_$day', isSelected);
    });
  }

  // Laden der gespeicherten Präferenzen
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedDaysCheer.forEach((day, _) {
      _selectedDaysCheer[day] = prefs.getBool('cheer_$day') ?? false;
    });
    _selectedDaysProgress.forEach((day, _) {
      _selectedDaysProgress[day] = prefs.getBool('progress_$day') ?? false;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planen'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            String day = _getDayByIndex(index);
            return Column(
              children: [
                Text(day, style: TextStyle(color: Colors.white)),
                Row(
                  children: [
                    Checkbox(
                      value: _selectedDaysCheer[day],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedDaysCheer[day] = value!;
                          _savePreferences(); // Speichern nach der Änderung
                        });
                      },
                    ),
                    Text('Cheer', style: TextStyle(color: Colors.white)),
                    Checkbox(
                      value: _selectedDaysProgress[day],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedDaysProgress[day] = value!;
                          _savePreferences(); // Speichern nach der Änderung
                        });
                      },
                    ),
                    Text('Progress', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Divider(color: Colors.white),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getDayByIndex(int index) {
    switch (index) {
      case 0:
        return 'Montag';
      case 1:
        return 'Dienstag';
      case 2:
        return 'Mittwoch';
      case 3:
        return 'Donnerstag';
      case 4:
        return 'Freitag';
      case 5:
        return 'Samstag';
      case 6:
        return 'Sonntag';
      default:
        return '';
    }
  }
}

class WarmupPage extends StatefulWidget {
  @override
  _WarmupPageState createState() => _WarmupPageState();
}

class _WarmupPageState extends State<WarmupPage> {
  late Future<List<Map<String, dynamic>>> _packages;

  @override
  void initState() {
    super.initState();
    _packages = DatabaseHelper()
        .getAllPackages(); // Daten aus der Packages-Tabelle abrufen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warmup Packages'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _packages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Ladeanzeige
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
                child: Text('Fehler: ${snapshot.error}')); // Fehleranzeige
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('Keine Daten vorhanden');
            return Center(
                child: Text('Keine Pakete gefunden.')); // Keine Daten gefunden
          }

          // Prüfen, wie viele Pakete gefunden wurden
          print('${snapshot.data!.length} Pakete gefunden');

          final packages = snapshot.data!;
          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return ListTile(
                title: Text(package['name'] ??
                    'Kein Paketname'), // Name des Pakets anzeigen
              );
            },
          );
        },
      ),
    );
  }
}
