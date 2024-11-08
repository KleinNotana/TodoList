import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todolist/screens/homescreen.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

void main() async {
  tz.initializeTimeZones();
  await hiveInit();
  await requestPermission();
  runApp(MyApp());
}

Future hiveInit() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  } catch (e) {
    print(e);
  }
}

Future requestPermission() async {
  // Request notification permission
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }

  
  var statusAlarm = await Permission.scheduleExactAlarm.status;
  print("statusAlarm: $statusAlarm");

  await Permission.scheduleExactAlarm.request();

}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestPermission(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading spinner while waiting for permission
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show error message if something went wrong
        } else {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              textTheme: TextTheme(
                headlineSmall: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
                headlineLarge: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              useMaterial3: true,
            ),
            home: const MyHomePage(title: 'Todo List'),
          );
        }
      },
    );
  }
}
