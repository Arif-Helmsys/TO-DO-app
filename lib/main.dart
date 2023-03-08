import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

final locator = GetIt.instance;

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>("tasks");
  for (var i in taskBox.values) {
    if (i.createdAt.day != DateTime.now().day) {
      taskBox.delete(i.id);
    }
  }
}

void setup() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await setupHive();

  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}
